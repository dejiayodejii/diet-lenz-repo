import 'dart:convert';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:openapi/api.dart';
import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/component/custom_textfield.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/core/services/toast_service.dart';
import 'package:diet_lenz/core/utils/loader.dart';
import 'package:diet_lenz/features/bottom_nav/bottom.dart';
import 'package:diet_lenz/features/food_logging/controller/food_logging_viewmodel.dart';
import 'package:diet_lenz/features/recipe/controller/recipe_viewmodel.dart';
import 'package:diet_lenz/widgets/calorie_badge.dart';
import 'package:diet_lenz/widgets/macro_progress_item.dart';
import 'package:diet_lenz/widgets/pulsating_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalyseResultDetail extends ConsumerStatefulWidget {
  const AnalyseResultDetail(this.analysis, {super.key});
  final FoodAnalysisDto analysis;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FoodLogDetailState();
}

class _FoodLogDetailState extends ConsumerState<AnalyseResultDetail> {
  final TextEditingController mealTypeController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  // Editable controllers
  late TextEditingController _foodNameController;

  TextEditingController _reanalyseController = TextEditingController();
  late TextEditingController _descriptionController;
  late TextEditingController _caloriesController;
  late TextEditingController _proteinController;
  late TextEditingController _carbsController;
  late TextEditingController _fatController;
  late TextEditingController _fiberController;

  @override
  void initState() {
    super.initState();
    final analysis = widget.analysis;
    _foodNameController =
        TextEditingController(text: analysis.foodName ?? 'Unknown Food');
    _descriptionController =
        TextEditingController(text: analysis.description ?? '');
    _caloriesController = TextEditingController(
        text: analysis.totalMacros?.calories?.toStringAsFixed(0) ?? '0');
    _proteinController = TextEditingController(
        text: (analysis.totalMacros?.protein?.value ?? 0.0).toStringAsFixed(1));
    _carbsController = TextEditingController(
        text: (analysis.totalMacros?.carbs?.value ?? 0.0).toStringAsFixed(1));
    _fatController = TextEditingController(
        text: (analysis.totalMacros?.fat?.value ?? 0.0).toStringAsFixed(1));
    _fiberController = TextEditingController(
        text: (analysis.totalMacros?.fiber?.value ?? 0.0).toStringAsFixed(1));
  }

  @override
  void dispose() {
    _foodNameController.dispose();
    _descriptionController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    _reanalyseController.dispose();
    _fiberController.dispose();
    mealTypeController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Future<void> _handleReAnalyze() async {
    final text = _reanalyseController.text.trim();
    if (text.isEmpty) return;

    // Build a FoodAnalysisDto with the user's additional description
    final updatedAnalysis = FoodAnalysisDto(
      foodName: _foodNameController.text.trim(),
      description: text,
      imageBase64: widget.analysis.imageBase64,
      totalMacros: MacroNutrientsDto(
        calories: double.tryParse(_caloriesController.text) ?? 0.0,
        protein: QuantityDto(
          value: double.tryParse(_proteinController.text) ?? 0.0,
          unit: widget.analysis.totalMacros?.protein?.unit ?? 'g',
        ),
        carbs: QuantityDto(
          value: double.tryParse(_carbsController.text) ?? 0.0,
          unit: widget.analysis.totalMacros?.carbs?.unit ?? 'g',
        ),
        fat: QuantityDto(
          value: double.tryParse(_fatController.text) ?? 0.0,
          unit: widget.analysis.totalMacros?.fat?.unit ?? 'g',
        ),
        fiber: QuantityDto(
          value: double.tryParse(_fiberController.text) ?? 0.0,
          unit: widget.analysis.totalMacros?.fiber?.unit ?? 'g',
        ),
      ),
    );

    final recipeVM = ref.read(recipeViewModelProvider.notifier);
    final success = await recipeVM.reAnalyzeRecipe(updatedAnalysis);

    if (!mounted) return;

    if (success) {
      final result = ref.read(recipeViewModelProvider).analyzedRecipe;
      if (result != null) {
        setState(() {
          _foodNameController.text =
              result.foodName ?? _foodNameController.text;
          _descriptionController.text = result.description ?? '';
          _caloriesController.text =
              result.totalMacros?.calories?.toStringAsFixed(0) ?? '0';
          _proteinController.text =
              (result.totalMacros?.protein?.value ?? 0.0).toStringAsFixed(1);
          _carbsController.text =
              (result.totalMacros?.carbs?.value ?? 0.0).toStringAsFixed(1);
          _fatController.text =
              (result.totalMacros?.fat?.value ?? 0.0).toStringAsFixed(1);
          _fiberController.text =
              (result.totalMacros?.fiber?.value ?? 0.0).toStringAsFixed(1);
          _reanalyseController.clear();
        });
        ref.read(toastProvider).showSuccess('Analysis updated!');
      }
    } else {
      final error = ref.read(recipeViewModelProvider).errorMessage;
      ref.read(toastProvider).showError(error ?? 'Re-analysis failed');
    }
  }

  double get protein => double.tryParse(_proteinController.text) ?? 0.0;
  double get carbs => double.tryParse(_carbsController.text) ?? 0.0;
  double get fat => double.tryParse(_fatController.text) ?? 0.0;
  double get fiber => double.tryParse(_fiberController.text) ?? 0.0;
  double get calories => double.tryParse(_caloriesController.text) ?? 0.0;

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

  LogMealRequestDtoMealTypeEnum? _selectedMealType;

  String _calculateTotalMacros() {
    final total = protein + carbs + fat + fiber;
    return total.toStringAsFixed(1);
  }

  Future<void> _handleAddToLog() async {
    final foodLoggingVM = ref.read(foodLoggingViewModelProvider.notifier);

    // Validate meal type
    if (_selectedMealType == null) {
      ref.read(toastProvider).showError(
            'Please select a meal type (Breakfast, Lunch, Dinner, or Snack)',
          );

      return;
    }

    // Build edited FoodAnalysisDto from controller values
    final editedAnalysis = FoodAnalysisDto(
      foodName: _foodNameController.text.trim(),
      description: _descriptionController.text.trim(),
      imageBase64: widget.analysis.imageBase64,
      totalMacros: MacroNutrientsDto(
        calories: double.tryParse(_caloriesController.text) ?? 0.0,
        protein: QuantityDto(
          value: double.tryParse(_proteinController.text) ?? 0.0,
          unit: widget.analysis.totalMacros?.protein?.unit ?? 'g',
        ),
        carbs: QuantityDto(
          value: double.tryParse(_carbsController.text) ?? 0.0,
          unit: widget.analysis.totalMacros?.carbs?.unit ?? 'g',
        ),
        fat: QuantityDto(
          value: double.tryParse(_fatController.text) ?? 0.0,
          unit: widget.analysis.totalMacros?.fat?.unit ?? 'g',
        ),
        fiber: QuantityDto(
          value: double.tryParse(_fiberController.text) ?? 0.0,
          unit: widget.analysis.totalMacros?.fiber?.unit ?? 'g',
        ),
      ),
    );

    // Create log meal request
    final request = LogMealRequestDto(
      foodAnalysis: editedAnalysis,
      mealType: _selectedMealType!,
      notes: noteController.text.trim().isEmpty
          ? null
          : noteController.text.trim(),
      servingMultiplier: 1.0, // Default serving size
    );

    // Log the meal
    final result = await foodLoggingVM.logMeal(request);

    // Check for errors
    final state = ref.read(foodLoggingViewModelProvider);
    if (!result) {
      if (mounted) {
        ref.read(toastProvider).showError(
              'Failed to log meal: ${state.errorMessage}',
            );
      }
    } else {
      // Success
      if (true) {
        ref.read(toastProvider).showSuccess(
              'Meal logged successfully!',
            );
        final foodLoggingVm = ref.read(foodLoggingViewModelProvider.notifier);
        foodLoggingVm.clearAllRecipes();
        foodLoggingVm.invalidateCache();
        final date = DateTime.now();
        ref
            .read(foodLoggingViewModelProvider.notifier)
            .getUserRecipes(date: date, refresh: true);
        ref
            .read(foodLoggingViewModelProvider.notifier)
            .getDashboard(date: date, refresh: true);
        NavigationService.pushAndRemoveUntil(child: BottomNavScreen());
      }
    }
  }

  Widget _buildMealTypeSelector() {
    final mealTypes = LogMealRequestDtoMealTypeEnum.values;
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
            // Format name: BREAKFAST -> Breakfast
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
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: DraggableScrollableSheet(
                initialChildSize: 0.75,
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
                        // Drag handle
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
                        // Header
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Edit Details',
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
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceGrey,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.close,
                                      color: Colors.white, size: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                            color: AppColors.borderColor, thickness: 0.5),
                        // Form content
                        Expanded(
                          child: ListView(
                            controller: scrollController,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            children: [
                              // Food Info Section
                              _buildSectionHeader('Food Info'),
                              const SizedBox(height: 12),
                              _buildSheetTextField(
                                controller: _foodNameController,
                                label: 'Food Name',
                                onChanged: () {
                                  setSheetState(() {});
                                  setState(() {});
                                },
                              ),
                              const SizedBox(height: 14),
                              _buildSheetTextField(
                                controller: _descriptionController,
                                label: 'Description',
                                maxLines: 3,
                                onChanged: () {
                                  setSheetState(() {});
                                  setState(() {});
                                },
                              ),
                              const SizedBox(height: 24),

                              // Nutrition Section
                              _buildSectionHeader('Nutrition'),
                              const SizedBox(height: 12),

                              // Calories - full width, prominent
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color:
                                        AppColors.primaryColor.withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor
                                            .withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                          Icons.local_fire_department,
                                          color: AppColors.primaryColor,
                                          size: 22),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Calories',
                                            style: TextStyle(
                                              color: AppColors.textLightGrey,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          SizedBox(
                                            width: 120,
                                            child: TextField(
                                              controller: _caloriesController,
                                              keyboardType: const TextInputType
                                                  .numberWithOptions(
                                                  decimal: true),
                                              style: const TextStyle(
                                                color: AppColors.primaryColor,
                                                fontSize: 22,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              onChanged: (_) {
                                                setSheetState(() {});
                                                setState(() {});
                                              },
                                              decoration: const InputDecoration(
                                                isDense: true,
                                                contentPadding: EdgeInsets.zero,
                                                border: InputBorder.none,
                                                suffixText: 'kcal',
                                                suffixStyle: TextStyle(
                                                  color:
                                                      AppColors.textLightGrey,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Macros in 2x2 grid
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildMacroCard(
                                      label: 'Protein',
                                      controller: _proteinController,
                                      unit: widget.analysis.totalMacros?.protein
                                              ?.unit ??
                                          'g',
                                      color: const Color(0xFF4CAF50),
                                      icon: Icons.fitness_center,
                                      onChanged: () {
                                        setSheetState(() {});
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildMacroCard(
                                      label: 'Carbs',
                                      controller: _carbsController,
                                      unit: widget.analysis.totalMacros?.carbs
                                              ?.unit ??
                                          'g',
                                      color: const Color(0xFF2196F3),
                                      icon: Icons.grain,
                                      onChanged: () {
                                        setSheetState(() {});
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildMacroCard(
                                      label: 'Fat',
                                      controller: _fatController,
                                      unit: widget.analysis.totalMacros?.fat
                                              ?.unit ??
                                          'g',
                                      color: const Color(0xFFFF9800),
                                      icon: Icons.water_drop,
                                      onChanged: () {
                                        setSheetState(() {});
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildMacroCard(
                                      label: 'Fiber',
                                      controller: _fiberController,
                                      unit: widget.analysis.totalMacros?.fiber
                                              ?.unit ??
                                          'g',
                                      color: const Color(0xFF8BC34A),
                                      icon: Icons.eco,
                                      onChanged: () {
                                        setSheetState(() {});
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 28),

                              // Save button
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
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
          },
        );
      },
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

  Widget _buildSheetTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    required VoidCallback onChanged,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      onChanged: (_) => onChanged(),
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        filled: true,
        fillColor: AppColors.surfaceGrey,
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
          borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5),
        ),
        labelText: label,
        labelStyle:
            const TextStyle(color: AppColors.textLightGrey, fontSize: 13),
      ),
    );
  }

  Widget _buildMacroCard({
    required String label,
    required TextEditingController controller,
    required String unit,
    required Color color,
    required IconData icon,
    required VoidCallback onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: color.withOpacity(0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 32,
            child: TextField(
              controller: controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
              onChanged: (_) => onChanged(),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                suffixText: unit,
                suffixStyle: TextStyle(
                  color: color.withOpacity(0.6),
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recipeState = ref.watch(recipeViewModelProvider);
    final state = ref.watch(foodLoggingViewModelProvider);
    return BlurryModalProgressHUD(
      inAsyncCall: state.isLoading || recipeState.isLoading,
      child: Scaffold(
        extendBody: false,
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 350,
                  width: double.infinity,
                  child: widget.analysis.imageBase64 != null
                      ? Image.memory(
                          base64Decode(widget.analysis.imageBase64!),
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          AppImages.salad,
                          scale: 2,
                          fit: BoxFit.cover,
                        ),
                ),
                Positioned(
                  top: 40.0,
                  left: 15,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      // Food name + edit button
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              _foodNameController.text,
                              style: const TextStyle(
                                fontFamily: AppFonts.lato,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: _showEditBottomSheet,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color:
                                      AppColors.primaryColor.withOpacity(0.3),
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.edit_outlined,
                                      color: AppColors.primaryColor, size: 15),
                                  SizedBox(width: 4),
                                  Text(
                                    'Edit',
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Calorie + total macros badges
                      Row(
                        children: [
                          CalorieBadge(
                            text: '${calories.toStringAsFixed(0)} cal',
                            width: 85,
                          ),
                          const SizedBox(width: 10),
                          CalorieBadge(
                            text: '${_calculateTotalMacros()}g',
                            backgroundColor: AppColors.surfaceGrey,
                            textColor: Colors.white,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Description
                      Text(
                        _descriptionController.text.isEmpty
                            ? 'No description available'
                            : _descriptionController.text,
                        style: const TextStyle(
                          fontFamily: AppFonts.lato,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textLightGrey,
                        ),
                      ),
                      const SizedBox(height: 20),
                      PulsatingBorder(
                        borderWidth: 3,
                        color: AppColors.primaryColor,
                        child: LabelTextFormField(
                          noBorder: true,
                          suffixIcon: GestureDetector(
                            onTap: _handleReAnalyze,
                            child: const Icon(Icons.send,
                                size: 20, color: AppColors.primaryColor),
                          ),
                          maxLines: 2,
                          controller: _reanalyseController,
                          hintText:
                              "Anything missing? (e.g., 'fried in oil' or 'large size')",
                        ),
                      ),
                      const SizedBox(height: 20),
                      MacroProgressItem(
                        label: 'Protein',
                        currentValue:
                            '${protein.toStringAsFixed(1)}${widget.analysis.totalMacros?.protein?.unit ?? "g"}',
                        targetValue: '',
                        progress: getRelativeProgress(protein),
                      ),
                      const SizedBox(height: 20),
                      MacroProgressItem(
                        label: 'Carbs',
                        currentValue:
                            '${carbs.toStringAsFixed(1)}${widget.analysis.totalMacros?.carbs?.unit ?? "g"}',
                        targetValue: '',
                        progress: getRelativeProgress(carbs),
                      ),
                      const SizedBox(height: 20),
                      MacroProgressItem(
                        label: 'Fat',
                        currentValue:
                            '${fat.toStringAsFixed(1)}${widget.analysis.totalMacros?.fat?.unit ?? "g"}',
                        targetValue: '',
                        progress: getRelativeProgress(fat),
                      ),
                      const SizedBox(height: 20),
                      MacroProgressItem(
                        label: 'Fiber',
                        currentValue:
                            '${fiber.toStringAsFixed(1)}${widget.analysis.totalMacros?.fiber?.unit ?? "g"}',
                        targetValue: '',
                        progress: getRelativeProgress(fiber),
                      ),
                      const SizedBox(height: 20),
                      _buildMealTypeSelector(),
                      const SizedBox(height: 20),
                      LabelTextFormField(
                        hintText: "Note about meal",
                        controller: noteController,
                      ),
                      const SizedBox(height: 20),
                      CustomYafButton(
                        text: "Add to Log",
                        onPressed: _handleAddToLog,
                      ),
                      SizedBox(
                          height: 30 + MediaQuery.of(context).padding.bottom),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
