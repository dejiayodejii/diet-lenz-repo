import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/component/custom_textfield.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/core/services/toast_service.dart';
import 'package:diet_lenz/features/database/controller/database_history_provider.dart';
import 'package:diet_lenz/features/food_logging/controller/food_logging_viewmodel.dart';
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
  const ManualLogScreen({super.key});

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

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    _fiberController.dispose();
    super.dispose();
  }

  Future<void> _addToFoodLog() async {
    if (!_formKey.currentState!.validate()) return;

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
      mealType: LogMealRequestDtoMealTypeEnum.DINNER,
      servingMultiplier: 1.0,
    );

    final success =
        await ref.read(foodLoggingViewModelProvider.notifier).logMeal(request);

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    if (!success) {
      final error = ref.read(foodLoggingViewModelProvider).errorMessage;
      ref.read(toastProvider).showError('Failed to log meal: $error');
      return;
    }

    await ref
        .read(databaseLoggedHistoryProvider.notifier)
        .saveLoggedFood(foodAnalysis);

    if (!mounted) return;
    ref.read(toastProvider).showSuccess('Meal logged successfully!');
    Navigator.of(context).pop();
  }

  double _parseNumber(String value) {
    return double.tryParse(value.trim()) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
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
                      suffixIcon: const _ManualUnitSuffix('kcal'),
                    ),
                    const SizedBox(height: 24),
                    LabelTextFormField(
                      labelText: 'Portion',
                      hintText: "e.g 1 bowl, 2oog, 2 slices",
                      controller: _servingMultiplierController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      // inputFormatters: [_decimalFormatter],
                      // validator: _numberValidator,
                      useSpace: false,
                      fillColor: const Color(0xFF262422),
                      borderColor: const Color(0xFF9A9A9A),
                      focusedBorderColor: AppColors.primaryColor,
                      focusedBorderWidth: 1.5,
                      textAlignVertical: TextAlignVertical.center,
                      suffixIcon: const _ManualUnitSuffix('kcal'),
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
                    text: "Add to food log")),
          ],
        ),
      ),
    );
  }

  Widget _buildAddIngredientCard() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFFF6B35).withOpacity(0.5),
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
                  color: const Color(0xFFFF6B35).withOpacity(0.7),
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  "Item",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMacroInfo("__ kcal"),
                _buildMacroInfo("Protein: __g"),
                _buildMacroInfo("Carbs: __g"),
                _buildMacroInfo("Fat: __g"),
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
