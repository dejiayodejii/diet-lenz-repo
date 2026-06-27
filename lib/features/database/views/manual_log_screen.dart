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

OutlineInputBorder _manualInputBorder(
  Color color, {
  double radius = 14,
  double width = 1,
}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(radius),
    borderSide: BorderSide(color: color, width: width),
  );
}

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
  final _caloriesController = TextEditingController(text: '0');
  final _proteinController = TextEditingController(text: '0');
  final _carbsController = TextEditingController(text: '0');
  final _fatController = TextEditingController(text: '0');
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
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
        fiber: QuantityDto(value: 0, unit: 'g'),
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
      body: SafeArea(
        child: Form(
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
                      _ManualBackButton(
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(height: 24),
                      const _ManualFieldLabel('Name'),
                      const SizedBox(height: 10),
                      _ManualTextInput(
                        controller: _nameController,
                        height: 118,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Enter food name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      const _ManualFieldLabel('Calories'),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 266,
                        child: _ManualMetricInput(
                          controller: _caloriesController,
                          unit: 'kcal',
                          fontSize: 44,
                        ),
                      ),
                      const SizedBox(height: 34),
                      Row(
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
                          const SizedBox(width: 22),
                          Expanded(
                            child: _ManualMacroInput(
                              label: 'Fats',
                              controller: _fatController,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const _ManualFieldLabel('Ingredient'),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.add,
                              color: AppColors.primaryColor,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const _ManualIngredientCard(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 12, 28, 28),
                child: SizedBox(
                  width: double.infinity,
                  height: 72,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _addToFoodLog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      disabledBackgroundColor:
                          AppColors.primaryColor.withValues(alpha: 0.45),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Add to Food Log',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ManualBackButton extends StatelessWidget {
  const _ManualBackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        height: 58,
        width: 58,
        decoration: const BoxDecoration(
          color: Color(0xFF242424),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.chevron_left_rounded,
          color: Colors.white,
          size: 34,
        ),
      ),
    );
  }
}

class _ManualFieldLabel extends StatelessWidget {
  const _ManualFieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _ManualTextInput extends StatelessWidget {
  const _ManualTextInput({
    required this.controller,
    this.height,
    this.textInputAction,
    this.validator,
  });

  final TextEditingController controller;
  final double? height;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: TextInputType.text,
        textInputAction: textInputAction,
        maxLines: height == null ? 1 : null,
        expands: height != null,
        textAlignVertical:
            height == null ? TextAlignVertical.center : TextAlignVertical.top,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFF141414),
          contentPadding: const EdgeInsets.all(18),
          errorStyle: const TextStyle(height: 0.9),
          border: _manualInputBorder(AppColors.primaryColor),
          enabledBorder: _manualInputBorder(AppColors.primaryColor),
          focusedBorder: _manualInputBorder(AppColors.primaryColor, width: 1.5),
          errorBorder: _manualInputBorder(Colors.redAccent),
          focusedErrorBorder: _manualInputBorder(Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }
}

class _ManualMetricInput extends StatelessWidget {
  const _ManualMetricInput({
    required this.controller,
    required this.unit,
    this.fontSize = 34,
  });

  final TextEditingController controller;
  final String unit;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 94,
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [_decimalFormatter],
        validator: _numberValidator,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFF262422),
          contentPadding: const EdgeInsets.symmetric(horizontal: 18),
          suffixIcon: Padding(
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
          ),
          border: _manualInputBorder(const Color(0xFF9A9A9A), radius: 24),
          enabledBorder:
              _manualInputBorder(const Color(0xFF9A9A9A), radius: 24),
          focusedBorder: _manualInputBorder(AppColors.primaryColor,
              radius: 24, width: 1.5),
          errorBorder: _manualInputBorder(Colors.redAccent, radius: 24),
          focusedErrorBorder:
              _manualInputBorder(Colors.redAccent, radius: 24, width: 1.5),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        _ManualMetricInput(
          controller: controller,
          unit: 'g',
          fontSize: 34,
        ),
      ],
    );
  }
}

class _ManualIngredientCard extends StatelessWidget {
  const _ManualIngredientCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primaryColor),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Item',
            style: TextStyle(
              color: AppColors.textLightGrey,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          Text(
            '-- kcal  |  Protein: --g  |  Carbs: --g  |  Fat: --g',
            style: TextStyle(
              color: AppColors.textLightGrey,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
