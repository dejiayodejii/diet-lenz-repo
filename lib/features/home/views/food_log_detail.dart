import 'dart:developer';

import 'package:openapi/api.dart';
import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/core/services/toast_service.dart';
import 'package:diet_lenz/core/utils/loader.dart';
import 'package:diet_lenz/features/bottom_nav/bottom.dart';
import 'package:diet_lenz/features/food_logging/controller/food_logging_viewmodel.dart';
import 'package:diet_lenz/widgets/calorie_badge.dart';
import 'package:diet_lenz/widgets/macro_progress_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FoodLogDetail extends ConsumerStatefulWidget {
  final RecipeResponseDto? recipe;
  final FavoriteRecipeResponseDto? favorite;
  final MealLogResponseDto? loggedMeal;
  final bool fromFavorite;

  const FoodLogDetail({
    super.key,
    this.recipe,
    this.favorite,
    this.loggedMeal,
    this.fromFavorite = false,
  }) : assert(recipe != null || favorite != null || loggedMeal != null,
            'A recipe, favorite, or logged meal must be provided');

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FoodLogDetailState();
}

class _FoodLogDetailState extends ConsumerState<FoodLogDetail> {
  LogMealRequestDtoMealTypeEnum? _selectedMealType =
      LogMealRequestDtoMealTypeEnum.DINNER;
  MealLogResponseDto? _editedLoggedMeal;
  FoodAnalysisDto? _editedFoodAnalysis;
  String? _editedNotes;
  double _servingMultiplier = 1.0;

  MealLogResponseDto? get _loggedMeal => _editedLoggedMeal ?? widget.loggedMeal;

  bool get _canManageLoggedMeal =>
      _mealLogId != null && _mealLogId!.isNotEmpty && !widget.fromFavorite;

  String? get _mealLogId => _loggedMeal?.id ?? widget.recipe?.id;

  @override
  void initState() {
    super.initState();
    log("meal logged is ${widget.recipe}");
    _selectedMealType = _requestMealTypeFromLoggedMeal(_loggedMeal?.mealType) ??
        LogMealRequestDtoMealTypeEnum.DINNER;
    _servingMultiplier = _loggedMeal?.servingMultiplier ?? 1.0;
    _editedNotes = _loggedMeal?.notes;
  }

  // Helper getters to extract data from either recipe or favorite
  String get foodName =>
      _editedFoodAnalysis?.foodName ??
      _loggedMeal?.foodName ??
      widget.recipe?.foodName ??
      widget.favorite?.foodName ??
      "Unknown Food";

  String get description =>
      _editedFoodAnalysis?.description ??
      _editedNotes ??
      _loggedMeal?.notes ??
      widget.recipe?.description ??
      widget.favorite?.description ??
      "No description available";

  String? get imageUrl =>
      _loggedMeal?.imageUrl ??
      widget.recipe?.imageUrl ??
      widget.favorite?.imageUrl;

  MacroInfoDto? get macros => widget.recipe?.macros ?? widget.favorite?.macros;

  double get calories =>
      _editedFoodAnalysis?.totalMacros?.calories ??
      _loggedMeal?.foodAnalysis?.totalMacros?.calories ??
      macros?.calories ??
      0.0;
  double get protein =>
      _editedFoodAnalysis?.totalMacros?.protein?.value ??
      _loggedMeal?.foodAnalysis?.totalMacros?.protein?.value ??
      macros?.proteinGrams ??
      0.0;
  double get carbs =>
      _editedFoodAnalysis?.totalMacros?.carbs?.value ??
    _loggedMeal?.foodAnalysis?.totalMacros?.carbs?.value ??
      macros?.carbsGrams ??
      0.0;
  double get fat =>
      _editedFoodAnalysis?.totalMacros?.fat?.value ??
    _loggedMeal?.foodAnalysis?.totalMacros?.fat?.value ??
      macros?.fatGrams ??
      0.0;
  double get fiber =>
      _editedFoodAnalysis?.totalMacros?.fiber?.value ??
      _loggedMeal?.foodAnalysis?.totalMacros?.fiber?.value ??
      macros?.fiberGrams ??
      0.0;

  double get totalWeight => protein + carbs + fat + fiber;

  // Calculate the maximum macro value for relative comparison
  double get maxMacroValue {
    final values = [protein, carbs, fat, fiber];
    return values.reduce((a, b) => a > b ? a : b);
  }

  // Calculate relative progress for each macro (0.0 to 1.0)
  double getRelativeProgress(double value) {
    if (maxMacroValue == 0) return 0.0;
    return (value / maxMacroValue).clamp(0.0, 1.0);
  }

  String? get _recipeId =>
      widget.recipe?.id ?? widget.favorite?.recipeId ?? _loggedMeal?.recipeId;

  FoodAnalysisDto _buildFoodAnalysis() {
    return FoodAnalysisDto(
      foodName: foodName,
      description: description,
      totalMacros: MacroNutrientsDto(
        calories: calories,
        protein: QuantityDto(value: protein, unit: 'g'),
        carbs: QuantityDto(value: carbs, unit: 'g'),
        fat: QuantityDto(value: fat, unit: 'g'),
        fiber: QuantityDto(value: fiber, unit: 'g'),
      ),
    );
  }

  LogMealRequestDtoMealTypeEnum? _requestMealTypeFromLoggedMeal(
    MealLogResponseDtoMealTypeEnum? mealType,
  ) {
    if (mealType == null) return null;
    return LogMealRequestDtoMealTypeEnum.fromJson(mealType.value);
  }

  Future<void> _handleRelog() async {
    if (_selectedMealType == null) {
      ref.read(toastProvider).showError(
            'Please select a meal type',
          );
      return;
    }

    final foodLoggingVM = ref.read(foodLoggingViewModelProvider.notifier);

    final request = LogMealRequestDto(
      existingRecipeId: _recipeId,
      foodAnalysis: _recipeId == null ? _buildFoodAnalysis() : null,
      mealType: _selectedMealType!,
      //  source_:widget.loggedMeal.foodSource.
      servingMultiplier: 1.0,
    );

    final result = await foodLoggingVM.logMeal(request);

    if (!result) {
      if (mounted) {
        final errorMsg = ref.read(foodLoggingViewModelProvider).errorMessage;
        ref.read(toastProvider).showError(
              'Failed to log meal: $errorMsg',
            );
      }
    } else {
      if (true) {
        ref.read(toastProvider).showSuccess('Meal logged successfully!');
        //
        log('✅ Meal logged successfully, refreshing dashboard and recipes');
        final date = DateTime.now();
        ref
            .read(foodLoggingViewModelProvider.notifier)
            .getUserRecipes(date: date, refresh: true);
        ref
            .read(foodLoggingViewModelProvider.notifier)
            .getDashboard(date: date, refresh: true);

        NavigationService.pushAndRemoveUntil(child: const BottomNavScreen());
      }
    }
  }

  Future<void> _handleEditMeal({
    required FoodAnalysisDto foodAnalysis,
    required LogMealRequestDtoMealTypeEnum mealType,
    required double servingMultiplier,
    String? notes,
  }) async {
    final mealLogId = _mealLogId;
    if (mealLogId == null || mealLogId.isEmpty) {
      ref.read(toastProvider).showError('Unable to edit this meal log');
      return;
    }

    final loggedDate = _loggedMeal?.loggedDate ?? DateTime.now();
    final request = LogMealRequestDto(
      // existingRecipeId: mealLogId,
      foodAnalysis: foodAnalysis,
      mealType: mealType,
      servingMultiplier: servingMultiplier,
      loggedDate: loggedDate,
      notes: notes,
    );

    final result = await ref
        .read(foodLoggingViewModelProvider.notifier)
        .editMealLog(id: mealLogId, mealRequest: request);

    if (!mounted) return;

    if (!result) {
      final errorMsg = ref.read(foodLoggingViewModelProvider).errorMessage;
      ref.read(toastProvider).showError('Failed to edit meal: $errorMsg');
      return;
    }

    final updatedMeal = ref.read(foodLoggingViewModelProvider).loggedMeal;
    setState(() {
      _editedLoggedMeal = updatedMeal;
      _editedFoodAnalysis = updatedMeal == null ? foodAnalysis : null;
      _editedNotes = notes;
      _selectedMealType = mealType;
      _servingMultiplier = servingMultiplier;
    });

    ref.read(foodLoggingViewModelProvider.notifier)
      ..getUserRecipes(date: loggedDate, refresh: true)
      ..getDashboard(date: loggedDate, refresh: true);
    ref.read(toastProvider).showSuccess('Meal updated successfully');
  }

  Future<void> _confirmDeleteMeal() async {
    final mealLogId = _mealLogId;
    if (mealLogId == null || mealLogId.isEmpty) {
      ref.read(toastProvider).showError('Unable to delete this meal log');
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.backgroundColor,
          title: const Text(
            'Delete meal?',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'This will remove the meal from your food log.',
            style: TextStyle(color: AppColors.textLightGrey),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    final loggedDate = _loggedMeal?.loggedDate ?? DateTime.now();
    final result = await ref
        .read(foodLoggingViewModelProvider.notifier)
        .deleteMealLog(id: mealLogId, loggedDate: loggedDate);

    if (!mounted) return;

    if (!result) {
      final errorMsg = ref.read(foodLoggingViewModelProvider).errorMessage;
      ref.read(toastProvider).showError('Failed to delete meal: $errorMsg');
      return;
    }

    ref.read(foodLoggingViewModelProvider.notifier)
      ..getUserRecipes(date: loggedDate, refresh: true)
      ..getDashboard(date: loggedDate, refresh: true);
    ref.read(toastProvider).showSuccess('Meal deleted successfully');
    Navigator.of(context).pop(true);
  }

  Widget _buildMealTypeSelector() {
    const mealTypes = LogMealRequestDtoMealTypeEnum.values;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Meal Type",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12.0,
          runSpacing: 12.0,
          children: mealTypes.map((type) {
            final isSelected = _selectedMealType == type;
            final typeValue = type.value;
            final name = typeValue[0] + typeValue.substring(1).toLowerCase();

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedMealType = type;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryColor
                      : Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryColor
                        : Colors.grey.shade700,
                  ),
                ),
                child: Text(
                  name,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showEditBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditMealBottomSheet(
        foodName: foodName,
        description: description,
        calories: calories,
        protein: protein,
        carbs: carbs,
        fat: fat,
        fiber: fiber,
        servingMultiplier: _servingMultiplier,
        selectedMealType:
            _selectedMealType ?? LogMealRequestDtoMealTypeEnum.DINNER,
        onSubmit: _handleEditMeal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final foodLoggingState = ref.watch(foodLoggingViewModelProvider);
    return BlurryModalProgressHUD(
      inAsyncCall: foodLoggingState.isLoading,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text(''),
          actions: [
            if (_canManageLoggedMeal) ...[
              IconButton(
                onPressed: _showEditBottomSheet,
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit meal',
              ),
              IconButton(
                onPressed: _confirmDeleteMeal,
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Delete meal',
              ),
            ],
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display image from URL or fallback to default
                imageUrl != null && imageUrl!.isNotEmpty
                    ? Image.network(
                        imageUrl!,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            AppImages.chicken,
                            scale: 2,
                          );
                        },
                      )
                    : SizedBox.shrink(),

                // Container(
                //     width: double.infinity,
                //     height: 200,
                //     color: AppColors.surfaceGrey,
                //     child: const Icon(
                //       Icons.restaurant_rounded,
                //       color: AppColors.primaryColor,
                //       size: 58,
                //     ),
                //   ),

                const SizedBox(height: 20),
                Text(
                  foodName,
                  style: const TextStyle(
                    fontFamily: AppFonts.lato,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    CalorieBadge(
                      text: '${calories.toStringAsFixed(2)} cal',
                    ),
                    // const SizedBox(width: 15),
                    // CalorieBadge(
                    //   text: '${totalWeight.toStringAsFixed(0)}g',
                    // ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  description,
                  style: const TextStyle(
                    fontFamily: AppFonts.lato,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 20),
                MacroProgressItem(
                  label: 'Protein',
                  currentValue: '${protein.toStringAsFixed(1)}g',
                  targetValue: '',
                  progress: getRelativeProgress(protein),
                ),
                const SizedBox(height: 20),
                MacroProgressItem(
                  label: 'Carbs',
                  currentValue: '${carbs.toStringAsFixed(1)}g',
                  targetValue: '',
                  progress: getRelativeProgress(carbs),
                ),
                const SizedBox(height: 20),
                MacroProgressItem(
                  label: 'Fat',
                  currentValue: '${fat.toStringAsFixed(1)}g',
                  targetValue: '',
                  progress: getRelativeProgress(fat),
                ),
                const SizedBox(height: 20),
                MacroProgressItem(
                  label: 'Fiber',
                  currentValue: '${fiber.toStringAsFixed(1)}g',
                  targetValue: '',
                  progress: getRelativeProgress(fiber),
                ),
                const SizedBox(height: 30),

                if (widget.fromFavorite) ...[
                  _buildMealTypeSelector(),
                  const SizedBox(height: 30),
                  CustomYafButton(
                    text: "Relog Food",
                    onPressed: _handleRelog,
                  ),
                ],
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EditMealBottomSheet extends StatefulWidget {
  const _EditMealBottomSheet({
    required this.foodName,
    required this.description,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.servingMultiplier,
    required this.selectedMealType,
    required this.onSubmit,
  });

  final String foodName;
  final String description;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;
  final double servingMultiplier;
  final LogMealRequestDtoMealTypeEnum selectedMealType;
  final Future<void> Function({
    required FoodAnalysisDto foodAnalysis,
    required LogMealRequestDtoMealTypeEnum mealType,
    required double servingMultiplier,
    String? notes,
  }) onSubmit;

  @override
  State<_EditMealBottomSheet> createState() => _EditMealBottomSheetState();
}

class _EditMealBottomSheetState extends State<_EditMealBottomSheet> {
  late LogMealRequestDtoMealTypeEnum _mealType;
  late final TextEditingController _foodNameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _caloriesController;
  late final TextEditingController _proteinController;
  late final TextEditingController _carbsController;
  late final TextEditingController _fatController;
  late final TextEditingController _fiberController;
  late final TextEditingController _servingController;

  @override
  void initState() {
    super.initState();
    _mealType = widget.selectedMealType;
    _foodNameController = TextEditingController(text: widget.foodName);
    _descriptionController = TextEditingController(
      text: widget.description == 'No description available'
          ? ''
          : widget.description,
    );
    _caloriesController = TextEditingController(
      text: _formatNumber(widget.calories),
    );
    _proteinController = TextEditingController(
      text: _formatNumber(widget.protein),
    );
    _carbsController = TextEditingController(
      text: _formatNumber(widget.carbs),
    );
    _fatController = TextEditingController(
      text: _formatNumber(widget.fat),
    );
    _fiberController = TextEditingController(
      text: _formatNumber(widget.fiber),
    );
    _servingController = TextEditingController(
      text: _formatNumber(widget.servingMultiplier),
    );
  }

  @override
  void dispose() {
    _foodNameController.dispose();
    _descriptionController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    _fiberController.dispose();
    _servingController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final parsedCalories = _parsePositiveDouble(_caloriesController.text);
    final parsedProtein = _parseNonNegativeDouble(_proteinController.text);
    final parsedCarbs = _parseNonNegativeDouble(_carbsController.text);
    final parsedFat = _parseNonNegativeDouble(_fatController.text);
    final parsedFiber = _parseNonNegativeDouble(_fiberController.text);
    final parsedServing = _parsePositiveDouble(_servingController.text);

    if (_foodNameController.text.trim().isEmpty ||
        parsedCalories == null ||
        parsedProtein == null ||
        parsedCarbs == null ||
        parsedFat == null ||
        parsedFiber == null ||
        parsedServing == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid meal details')),
      );
      return;
    }

    final foodAnalysis = FoodAnalysisDto(
      foodName: _foodNameController.text.trim(),
      description: _descriptionController.text.trim(),
      totalMacros: MacroNutrientsDto(
        calories: parsedCalories,
        protein: QuantityDto(value: parsedProtein, unit: 'g'),
        carbs: QuantityDto(value: parsedCarbs, unit: 'g'),
        fat: QuantityDto(value: parsedFat, unit: 'g'),
        fiber: QuantityDto(value: parsedFiber, unit: 'g'),
      ),
    );

    Navigator.pop(context);
    await widget.onSubmit(
      foodAnalysis: foodAnalysis,
      mealType: _mealType,
      servingMultiplier: parsedServing,
      notes: _descriptionController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.78,
        minChildSize: 0.5,
        maxChildSize: 0.92,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 8),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade600,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Edit Meal',
                        style: TextStyle(
                          fontFamily: AppFonts.lato,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.surfaceGrey,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: AppColors.borderColor, thickness: 0.5),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    children: [
                      _buildSectionHeader('Food Info'),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: _foodNameController,
                        label: 'Food Name',
                      ),
                      const SizedBox(height: 14),
                      _buildTextField(
                        controller: _descriptionController,
                        label: 'Notes',
                        maxLines: 3,
                      ),
                      const SizedBox(height: 20),
                      _buildSectionHeader('Meal Type'),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: LogMealRequestDtoMealTypeEnum.values.map(
                          (type) {
                            final isSelected = _mealType == type;
                            return GestureDetector(
                              onTap: () => setState(() => _mealType = type),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 9,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryColor
                                      : AppColors.surfaceGrey,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _formatMealType(type.value),
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.black
                                        : Colors.white,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                      const SizedBox(height: 24),
                      _buildSectionHeader('Nutrition'),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: _caloriesController,
                        label: 'Calories',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        suffixText: 'kcal',
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _proteinController,
                              label: 'Protein',
                              suffixText: 'g',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField(
                              controller: _carbsController,
                              label: 'Carbs',
                              suffixText: 'g',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _fatController,
                              label: 'Fat',
                              suffixText: 'g',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField(
                              controller: _fiberController,
                              label: 'Fiber',
                              suffixText: 'g',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _buildTextField(
                        controller: _servingController,
                        label: 'Serving Multiplier',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Save Changes',
                            style: TextStyle(
                              fontFamily: AppFonts.lato,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 18,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontFamily: AppFonts.lato,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? suffixText,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        filled: true,
        fillColor: AppColors.surfaceGrey,
        suffixText: suffixText,
        suffixStyle: const TextStyle(
          color: AppColors.textLightGrey,
          fontSize: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 1.5,
          ),
        ),
        labelText: label,
        labelStyle: const TextStyle(
          color: AppColors.textLightGrey,
          fontSize: 13,
        ),
      ),
    );
  }

  String _formatNumber(double value) {
    return value.toStringAsFixed(value % 1 == 0 ? 0 : 1);
  }

  String _formatMealType(String value) {
    if (value.isEmpty) return value;
    return value[0] + value.substring(1).toLowerCase();
  }

  double? _parsePositiveDouble(String value) {
    final parsed = double.tryParse(value.trim());
    if (parsed == null || parsed <= 0) return null;
    return parsed;
  }

  double? _parseNonNegativeDouble(String value) {
    final parsed = double.tryParse(value.trim());
    if (parsed == null || parsed < 0) return null;
    return parsed;
  }
}
