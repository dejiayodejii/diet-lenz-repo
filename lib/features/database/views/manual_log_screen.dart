import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/component/custom_textfield.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/core/services/toast_service.dart';
import 'package:diet_lenz/features/database/views/database_search_screen.dart';
import 'package:diet_lenz/features/food_logging/controller/food_logging_viewmodel.dart';
import 'package:diet_lenz/features/home/views/widgets/logged_meal_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/api.dart';

final _decimalFormatter = FilteringTextInputFormatter.allow(
  RegExp(r'^\d*\.?\d{0,2}'),
);

String? _numberValidator(String? value) {
  final text = value?.trim() ?? '';
  if (text.isEmpty) return 'Required';
  if (double.tryParse(text) == null) return 'Invalid';
  return null;
}

class ManualLogScreen extends ConsumerStatefulWidget {
  const ManualLogScreen({super.key, this.loggedMeal});

  final MealLogResponseDto? loggedMeal;

  @override
  ConsumerState<ManualLogScreen> createState() => _ManualLogScreenState();
}

class _ManualLogScreenState extends ConsumerState<ManualLogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController(text: '');
  final _servingMultiplierController = TextEditingController(text: '');
  final _proteinController = TextEditingController(text: '');
  final _carbsController = TextEditingController(text: '');
  final _fatController = TextEditingController(text: '');
  final _fiberController = TextEditingController(text: '');
  bool _isSubmitting = false;
  final List<FoodAnalysisDto> _ingredients = [];
  MacroNutrientsDto? _savedEditMacros;
  double _savedEditAmount = 1;

  @override
  void initState() {
    super.initState();
    final meal = widget.loggedMeal;
    final analysis = meal?.foodAnalysis;
    final macros = analysis?.totalMacros;
    _savedEditMacros = macros;
    _savedEditAmount = meal?.servingMultiplier ?? 1;
    _nameController.text = analysis?.foodName ?? meal?.foodName ?? '';
    _caloriesController.text = _formatInitial(macros?.calories);
    _servingMultiplierController.text = _formatInitial(meal?.servingMultiplier);
    _proteinController.text = _formatInitial(macros?.protein?.value);
    _carbsController.text = _formatInitial(macros?.carbs?.value);
    _fatController.text = _formatInitial(macros?.fat?.value);
    _fiberController.text = _formatInitial(macros?.fiber?.value);
    if (meal != null) {
      _servingMultiplierController.addListener(_onEditAmountChanged);
    }
  }

  @override
  void dispose() {
    _servingMultiplierController.removeListener(_onEditAmountChanged);
    _nameController.dispose();
    _caloriesController.dispose();
    _servingMultiplierController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    _fiberController.dispose();
    super.dispose();
  }

  Future<void> _addToFoodLog() async {
    if (!_formKey.currentState!.validate()) return;

    if (widget.loggedMeal != null &&
        _parseNumber(_servingMultiplierController.text) <= 0) {
      ref.read(toastProvider).showError('Enter an amount greater than zero');
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isSubmitting = true);

    final foodAnalysis = FoodAnalysisDto(
      foodName: _nameController.text.trim(),
      description: _nameController.text.trim(),
      totalMacros: MacroNutrientsDto(
        calories: _parseNumber(_caloriesController.text),
        protein: QuantityDto(
          value: _parseNumber(_proteinController.text),
          unit: 'g',
        ),
        carbs: QuantityDto(
          value: _parseNumber(_carbsController.text),
          unit: 'g',
        ),
        fat: QuantityDto(
          value: _parseNumber(_fatController.text),
          unit: 'g',
        ),
        fiber: QuantityDto(
          value: _parseNumber(_fiberController.text),
          unit: 'g',
        ),
      ),
    );

    final request = LogMealRequestDto(
      foodAnalysis: foodAnalysis,
      mealType: LogMealRequestDtoMealTypeEnum.fromJson(
            widget.loggedMeal?.mealType?.value,
          ) ??
          LogMealRequestDtoMealTypeEnum.DINNER,
      servingMultiplier: widget.loggedMeal == null
          ? _parseNumber(_servingMultiplierController.text)
          : _parseNumber(_servingMultiplierController.text)
              .clamp(0.01, double.infinity),
      source_: LogMealRequestDtoSource_Enum.MANUAL,
      loggedDate: widget.loggedMeal?.loggedDate,
    );

    final notifier = ref.read(foodLoggingViewModelProvider.notifier);
    final success = widget.loggedMeal == null
        ? await notifier.logMeal(request)
        : await notifier.editMealLog(
            id: widget.loggedMeal!.id!,
            mealRequest: request,
          );

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    if (!success) {
      final error = ref.read(foodLoggingViewModelProvider).errorMessage;
      ref.read(toastProvider).showError('Failed to log meal: $error');
      return;
    }

    if (!mounted) return;
    // final loggedDate = widget.loggedMeal?.loggedDate;
    // if (loggedDate != null) {
    notifier
      ..getUserRecipes(date: DateTime.now(), refresh: true)
      ..getDashboard(date: DateTime.now(), refresh: true);
    // }
    ref.read(toastProvider).showSuccess(
          widget.loggedMeal == null
              ? 'Meal logged successfully!'
              : 'Meal updated successfully!',
        );
    Navigator.of(context).pop(true);
  }

  double _parseNumber(String value) {
    return double.tryParse(value.trim()) ?? 0;
  }

  String _formatInitial(double? value) {
    if (value == null) return '';
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toString();
  }

  void _onEditAmountChanged() {
    final macros = _savedEditMacros;
    if (macros == null || _savedEditAmount <= 0) return;

    final amount = _parseNumber(_servingMultiplierController.text);
    if (amount <= 0) return;
    final factor = amount / _savedEditAmount;

    _caloriesController.text = _formatNumber((macros.calories ?? 0) * factor);
    _proteinController.text =
        _formatNumber((macros.protein?.value ?? 0) * factor);
    _carbsController.text = _formatNumber((macros.carbs?.value ?? 0) * factor);
    _fatController.text = _formatNumber((macros.fat?.value ?? 0) * factor);
    _fiberController.text = _formatNumber((macros.fiber?.value ?? 0) * factor);
  }

  Future<void> _openIngredientSearch() async {
    FocusScope.of(context).unfocus();
    final ingredient = await Navigator.of(context).push<FoodAnalysisDto>(
      MaterialPageRoute(
        builder: (_) => const DatabaseSearchScreen(
          selectingIngredient: true,
        ),
      ),
    );

    if (!mounted || ingredient == null) return;

    final normalizedName = _ingredientName(ingredient).toLowerCase();
    final alreadyAdded = _ingredients.any(
      (item) => _ingredientName(item).toLowerCase() == normalizedName,
    );
    if (alreadyAdded) {
      ref.read(toastProvider).showError('Ingredient already added');
      return;
    }

    setState(() {
      _ingredients.add(ingredient);
      _updateTotalsFromIngredients();
    });
  }

  void _removeIngredient(FoodAnalysisDto ingredient) {
    setState(() {
      _ingredients.remove(ingredient);
      _updateTotalsFromIngredients();
    });
  }

  void _updateTotalsFromIngredients() {
    final totals = _ingredients.fold<_IngredientTotals>(
      const _IngredientTotals(),
      (sum, ingredient) => sum.add(ingredient.totalMacros),
    );

    _setNumber(_caloriesController, totals.calories);
    _setNumber(_proteinController, totals.protein);
    _setNumber(_carbsController, totals.carbs);
    _setNumber(_fatController, totals.fat);
    _setNumber(_fiberController, totals.fiber);
  }

  void _setNumber(TextEditingController controller, double value) {
    controller.text = _ingredients.isEmpty ? '' : _formatNumber(value);
  }

  String _ingredientName(FoodAnalysisDto ingredient) {
    final name = ingredient.foodName?.trim();
    return name == null || name.isEmpty ? 'Unknown ingredient' : name;
  }

  String _formatNumber(double value) {
    return value == value.roundToDouble()
        ? value.round().toString()
        : value
            .toStringAsFixed(2)
            .replaceFirst(RegExp(r'0+$'), '')
            .replaceFirst(
              RegExp(r'\.$'),
              '',
            );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        actions: [
          if (widget.loggedMeal != null)
            LoggedMealActions(loggedMeal: widget.loggedMeal!),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    LabelTextFormField(
                      labelText: 'Name',
                      controller: _nameController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      maxLines: 3,
                      useSpace: false,
                      radius: 14,
                      fillColor: const Color(0xFF141414),
                      focusedBorderWidth: 1.5,
                      contentPadding: const EdgeInsets.all(18),
                      textAlignVertical: TextAlignVertical.top,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter food name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    LabelTextFormField(
                      labelText: 'Calories',
                      hintText: "0",
                      controller: _caloriesController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [_decimalFormatter],
                      validator: _numberValidator,
                      useSpace: false,
                      fillColor: const Color(0xFF262422),
                      borderColor: const Color(0xFF9A9A9A),
                      focusedBorderColor: AppColors.primaryColor,
                      focusedBorderWidth: 1.5,
                      textAlignVertical: TextAlignVertical.center,
                      suffixIcon: const _ManualUnitSuffix('cal'),
                    ),
                    const SizedBox(height: 24),
                    LabelTextFormField(
                      labelText: 'Portion',
                      hintText: "e.g 1 bowl, 2oog, 2 slices",
                      controller: _servingMultiplierController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [_decimalFormatter],
                      validator: _numberValidator,
                      useSpace: false,
                      fillColor: const Color(0xFF262422),
                      borderColor: const Color(0xFF9A9A9A),
                      focusedBorderColor: AppColors.primaryColor,
                      focusedBorderWidth: 1.5,
                      textAlignVertical: TextAlignVertical.center,
                      // suffixIcon: const _ManualUnitSuffix('cal'),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _ManualMacroInput(
                            label: 'Protein',
                            controller: _proteinController,
                          ),
                        ),
                        const SizedBox(width: 22),
                        Expanded(
                          child: _ManualMacroInput(
                            label: 'Carbs',
                            controller: _carbsController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _ManualMacroInput(
                            label: 'Fats',
                            controller: _fatController,
                          ),
                        ),
                        const SizedBox(width: 22),
                        Expanded(
                          child: _ManualMacroInput(
                            label: 'Fibre',
                            controller: _fiberController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (_ingredients.isNotEmpty) ...[
                      const Text(
                        'Ingredients',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _ingredients.map((ingredient) {
                          return InputChip(
                            label: Text(_ingredientName(ingredient)),
                            onDeleted: () => _removeIngredient(ingredient),
                            deleteIcon: const Icon(Icons.close, size: 18),
                            backgroundColor:
                                const Color.fromRGBO(255, 90, 22, 0.22),
                            deleteIconColor: AppColors.white,
                            labelStyle: const TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],
                    _buildAddIngredientCard(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(
                    28, 12, 28, 28 + MediaQuery.of(context).padding.bottom),
                child: CustomYafButton(
                    width: double.infinity,
                    isLoading: _isSubmitting,
                    onPressed: _isSubmitting ? null : _addToFoodLog,
                    text: widget.loggedMeal == null
                        ? "Add to food log"
                        : "Save changes")),
          ],
        ),
      ),
    );
  }

  Widget _buildAddIngredientCard() {
    return GestureDetector(
      onTap: _openIngredientSearch,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFFF6B35).withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.add_circle_outline,
                  color: const Color(0xFFFF6B35).withValues(alpha: 0.7),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  _ingredients.isEmpty
                      ? 'Add Ingredient'
                      : 'Add another ingredient',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 6,
              children: [
                _buildMacroInfo(
                  _ingredients.isEmpty
                      ? '__ cal'
                      : '${_caloriesController.text} cal',
                ),
                _buildMacroInfo(
                  _ingredients.isEmpty
                      ? 'Protein: __g'
                      : 'Protein: ${_proteinController.text}g',
                ),
                _buildMacroInfo(
                  _ingredients.isEmpty
                      ? 'Carbs: __g'
                      : 'Carbs: ${_carbsController.text}g',
                ),
                _buildMacroInfo(
                  _ingredients.isEmpty
                      ? 'Fat: __g'
                      : 'Fat: ${_fatController.text}g',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroInfo(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey, fontSize: 12),
    );
  }
}

class _IngredientTotals {
  const _IngredientTotals({
    this.calories = 0,
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
    this.fiber = 0,
  });

  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;

  _IngredientTotals add(MacroNutrientsDto? macros) {
    return _IngredientTotals(
      calories: calories + (macros?.calories ?? 0),
      protein: protein + (macros?.protein?.value ?? 0),
      carbs: carbs + (macros?.carbs?.value ?? 0),
      fat: fat + (macros?.fat?.value ?? 0),
      fiber: fiber + (macros?.fiber?.value ?? 0),
    );
  }
}

class _ManualMetricInput extends StatelessWidget {
  const _ManualMetricInput({
    required this.label,
    required this.controller,
    required this.unit,
    this.fontSize = 34,
  });

  final String label;
  final TextEditingController controller;
  final String unit;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return LabelTextFormField(
      labelText: label,
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [_decimalFormatter],
      validator: _numberValidator,
      useSpace: false,
      hintText: "0",
      radius: 24,
      fillColor: const Color(0xFF262422),
      borderColor: AppColors.primaryColor,
      focusedBorderColor: AppColors.primaryColor,
      focusedBorderWidth: 1.5,
      textAlignVertical: TextAlignVertical.center,
      suffixIcon: _ManualUnitSuffix(unit),
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

class _ManualUnitSuffix extends StatelessWidget {
  const _ManualUnitSuffix(this.unit);

  final String unit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 18),
      child: Center(
        widthFactor: 1,
        child: Text(
          unit,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _ManualMacroInput extends StatelessWidget {
  const _ManualMacroInput({
    required this.label,
    required this.controller,
  });

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return _ManualMetricInput(
      label: label,
      controller: controller,
      unit: 'g',
      fontSize: 34,
    );
  }
}
