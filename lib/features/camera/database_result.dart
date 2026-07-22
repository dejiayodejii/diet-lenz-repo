import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/core/services/toast_service.dart';
import 'package:diet_lenz/features/database/controller/database_history_provider.dart';
import 'package:diet_lenz/features/food_logging/controller/food_logging_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/api.dart';

class DatabaseResultDetail extends ConsumerStatefulWidget {
  const DatabaseResultDetail(
    this.analysis, {
    super.key,
    this.trackInDatabaseHistory = false,
    this.loggedMeal,
  });

  final FoodAnalysisDto analysis;
  final bool trackInDatabaseHistory;
  final MealLogResponseDto? loggedMeal;

  @override
  ConsumerState<DatabaseResultDetail> createState() =>
      _DatabaseResultDetailState();
}

class _DatabaseResultDetailState extends ConsumerState<DatabaseResultDetail> {
  static const _backgroundColor = Color(0xFF101010);
  static const _fieldColor = Color(0xFF141414);
  static const _cardColor = Color(0xFF202528);

  late final TextEditingController _amountController;
  late final List<MeasureDto> _measures;
  late MeasureDto _selectedMeasure;

  late LogMealRequestDtoMealTypeEnum _selectedMealType;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _measures = _prepareMeasures(widget.analysis.measures);
    _selectedMeasure = _measures.firstWhere(
      (measure) => _normalizedLabel(measure) == 'gram',
      orElse: () => _measures.first,
    );

    _selectedMealType = LogMealRequestDtoMealTypeEnum.fromJson(
          widget.loggedMeal?.mealType?.value,
        ) ??
        LogMealRequestDtoMealTypeEnum.DINNER;

    _amountController = TextEditingController(
      text: _formatAmount(widget.loggedMeal?.servingMultiplier ?? 1),
    )..addListener(_onAmountChanged);
  }

  @override
  void dispose() {
    _amountController
      ..removeListener(_onAmountChanged)
      ..dispose();
    super.dispose();
  }

  List<MeasureDto> _prepareMeasures(List<MeasureDto> measures) {
    final usableMeasures = measures
        .where(
          (measure) =>
              measure.label?.trim().isNotEmpty == true &&
              (measure.weightGrams ?? 0) > 0,
        )
        .toList();

    if (usableMeasures.isEmpty) {
      return [MeasureDto(label: 'Gram', weightGrams: 1)];
    }

    const preferredOrder = {
      'cup': 0,
      'ounce': 1,
      'gram': 2,
      'serving': 3,
      'pound': 4,
      'kilogram': 5,
    };

    usableMeasures.sort((first, second) {
      final firstOrder = preferredOrder[_normalizedLabel(first)] ?? 100;
      final secondOrder = preferredOrder[_normalizedLabel(second)] ?? 100;
      return firstOrder.compareTo(secondOrder);
    });
    return usableMeasures;
  }

  void _onAmountChanged() {
    if (mounted) setState(() {});
  }

  double get _amount => double.tryParse(_amountController.text.trim()) ?? 0;

  double get _totalWeightGrams =>
      math.max(0, _amount * (_selectedMeasure.weightGrams ?? 0));

  double get _servingMultiplier => _totalWeightGrams / 100;

  double get _nutritionScaleFactor {
    final loggedMeal = widget.loggedMeal;
    if (loggedMeal == null) return _servingMultiplier;

    final savedAmount = loggedMeal.servingMultiplier ?? 1;
    if (savedAmount <= 0) return 1;
    return _amount / savedAmount;
  }

  double _scaled(double? value) => (value ?? 0) * _nutritionScaleFactor;

  double get _calories => _scaled(widget.analysis.totalMacros?.calories);
  double get _carbs => _scaled(widget.analysis.totalMacros?.carbs?.value);
  double get _protein => _scaled(widget.analysis.totalMacros?.protein?.value);
  double get _fat => _scaled(widget.analysis.totalMacros?.fat?.value);
  double get _fiber => _scaled(widget.analysis.totalMacros?.fiber?.value);

  void _selectMeasure(MeasureDto measure) {
    if (identical(measure, _selectedMeasure)) return;
    setState(() => _selectedMeasure = measure);
  }

  Future<void> _handleAddToLog() async {
    if (_amount <= 0 || _totalWeightGrams <= 0) {
      ref.read(toastProvider).showError('Enter an amount greater than zero');
      return;
    }

    setState(() => _isSubmitting = true);

    final scaledAnalysis = FoodAnalysisDto(
      foodName: widget.analysis.foodName,
      description: widget.analysis.description,
      imageBase64: widget.analysis.imageBase64,
      measures: [_selectedMeasure],
      totalMacros: MacroNutrientsDto(
        calories: _calories,
        protein: QuantityDto(
          value: _protein,
          unit: widget.analysis.totalMacros?.protein?.unit ?? 'g',
        ),
        carbs: QuantityDto(
          value: _carbs,
          unit: widget.analysis.totalMacros?.carbs?.unit ?? 'g',
        ),
        fat: QuantityDto(
          value: _fat,
          unit: widget.analysis.totalMacros?.fat?.unit ?? 'g',
        ),
        fiber: QuantityDto(
          value: _fiber,
          unit: widget.analysis.totalMacros?.fiber?.unit ?? 'g',
        ),
      ),
    );

    final request = LogMealRequestDto(
      foodAnalysis: scaledAnalysis,
      mealType: _selectedMealType,
      // The analysis already contains the totals displayed in the UI.
      // Keep this at one so the backend does not scale them a second time.
      servingMultiplier: _amount,
      source_: LogMealRequestDtoSource_Enum.SEARCH,
    );

    log("request is $request");

    // return;

    final foodLoggingViewModel =
        ref.read(foodLoggingViewModelProvider.notifier);
    final loggedMeal = widget.loggedMeal;
    final success = loggedMeal == null
        ? await foodLoggingViewModel.logMeal(request)
        : await foodLoggingViewModel.editMealLog(
            id: loggedMeal.id!,
            mealRequest: LogMealRequestDto(
              foodAnalysis: request.foodAnalysis,
              mealType: request.mealType,
              servingMultiplier: request.servingMultiplier,
              source_: request.source_,
              loggedDate: loggedMeal.loggedDate,
            ),
          );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (!success) {
      final error = ref.read(foodLoggingViewModelProvider).errorMessage;
      ref.read(toastProvider).showError(error ?? 'Failed to log meal');
      return;
    }

    if (widget.trackInDatabaseHistory) {
      await ref
          .read(databaseLoggedHistoryProvider.notifier)
          .saveLoggedFood(widget.analysis);
      if (!mounted) return;
    }

    ref.read(toastProvider).showSuccess(
          loggedMeal == null
              ? 'Meal logged successfully!'
              : 'Meal updated successfully!',
        );
    final today = loggedMeal?.loggedDate ?? DateTime.now();
    unawaited(foodLoggingViewModel.getUserRecipes(date: today, refresh: true));
    unawaited(foodLoggingViewModel.getDashboard(date: today, refresh: true));
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: 86,
        backgroundColor: _backgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 94,
        leading: Padding(
          padding: const EdgeInsets.only(left: 18, top: 15, bottom: 15),
          child: _CircularBackButton(
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFoodHeader(),
                  const SizedBox(height: 38),
                  const _SectionTitle('Calories'),
                  const SizedBox(height: 18),
                  NutritionReadout(
                    value: _formatNutritionValue(_calories),
                    unit: 'cal',
                  ),
                  const SizedBox(height: 50),
                  const _SectionTitle('Measurement'),
                  const SizedBox(height: 18),
                  _buildMeasureSelector(),
                  const SizedBox(height: 46),
                  const _SectionTitle('Amount'),
                  const SizedBox(height: 18),
                  _buildAmountField(),
                  const SizedBox(height: 46),
                  _buildMacroCards(),
                  const SizedBox(height: 46),
                  const _SectionTitle('Meal Type'),
                  const SizedBox(height: 18),
                  _buildMealTypeSelector(),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            minimum: const EdgeInsets.fromLTRB(18, 12, 18, 12),
            child: CustomYafButton(
              text: widget.loggedMeal == null
                  ? 'Add to Food Log'
                  : 'Save Changes',
              width: double.infinity,
              // height: 72,
              radius: 20,
              fontSize: 22,
              weight: FontWeight.w500,
              isLoading: _isSubmitting,
              onPressed: _isSubmitting ? null : _handleAddToLog,
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(double value) {
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toString();
  }

  Widget _buildFoodHeader() {
    final name = widget.analysis.foodName?.trim();
    final description = widget.analysis.description?.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name?.isNotEmpty == true ? name! : 'Unknown food',
          style: const TextStyle(
            color: Colors.white,
            fontFamily: AppFonts.spaceGrotesk,
            fontSize: 25,
            height: 1.1,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (description?.isNotEmpty == true) ...[
          const SizedBox(height: 5),
          Text(
            description!,
            style: const TextStyle(
              color: Color(0xFFA7A7A7),
              fontFamily: AppFonts.spaceGrotesk,
              fontSize: 17,
              height: 1.2,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMeasureSelector() {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _measures.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final measure = _measures[index];
          return _SelectionChip(
            label: _displayMeasureLabel(measure),
            isSelected: identical(measure, _selectedMeasure),
            onTap: () => _selectMeasure(measure),
          );
        },
      ),
    );
  }

  Widget _buildAmountField() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: _fieldColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryColor, width: 1.3),
      ),
      child: TextField(
        controller: _amountController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,3}')),
        ],
        cursorColor: AppColors.primaryColor,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: AppFonts.spaceGrotesk,
          fontSize: 34,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 10, 13),
          suffixIconConstraints: const BoxConstraints(minWidth: 70),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Align(
              alignment: Alignment.centerRight,
              widthFactor: 1,
              child: Text(
                _amountUnit(_selectedMeasure),
                style: const TextStyle(
                  color: Color(0xFFB9B9B9),
                  fontFamily: AppFonts.spaceGrotesk,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMacroCards() {
    final maxValue =
        math.max(_carbs, math.max(_protein, math.max(_fat, _fiber)));

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: MacroCard(
                label: 'Carb',
                value: _carbs,
                progress: maxValue == 0 ? 0 : _carbs / maxValue,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: MacroCard(
                label: 'Protein',
                value: _protein,
                progress: maxValue == 0 ? 0 : _protein / maxValue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: MacroCard(
                label: 'Fat',
                value: _fat,
                progress: maxValue == 0 ? 0 : _fat / maxValue,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: MacroCard(
                label: 'Fiber',
                value: _fiber,
                progress: maxValue == 0 ? 0 : _fiber / maxValue,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMealTypeSelector() {
    return Row(
      children: LogMealRequestDtoMealTypeEnum.values.indexed.map((entry) {
        final index = entry.$1;
        final mealType = entry.$2;
        final isSelected = mealType == _selectedMealType;
        final value = mealType.value.toLowerCase();
        final label = value[0].toUpperCase() + value.substring(1);

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index == LogMealRequestDtoMealTypeEnum.values.length - 1
                  ? 0
                  : 10,
            ),
            child: _SelectionChip(
              label: label,
              isSelected: isSelected,
              expands: true,
              onTap: () => setState(() => _selectedMealType = mealType),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _normalizedLabel(MeasureDto measure) =>
      measure.label?.trim().toLowerCase() ?? '';

  String _displayMeasureLabel(MeasureDto measure) {
    switch (_normalizedLabel(measure)) {
      case 'ounce':
        return 'Oz';
      case 'pound':
        return 'Lb';
      case 'kilogram':
        return 'Kg';
      default:
        final label = measure.label?.trim() ?? '';
        return label.isEmpty ? 'Measure' : label;
    }
  }

  String _amountUnit(MeasureDto measure) {
    switch (_normalizedLabel(measure)) {
      case 'gram':
        return 'g';
      case 'ounce':
        return 'oz';
      case 'pound':
        return 'lb';
      case 'kilogram':
        return 'kg';
      case 'cup':
        return 'cup';
      case 'serving':
        return 'serving';
      default:
        return measure.label?.trim() ?? '';
    }
  }

  String _formatNutritionValue(double value) {
    if ((value - value.round()).abs() < 0.05) {
      return value.round().toString();
    }
    return value.toStringAsFixed(1);
  }
}

class _CircularBackButton extends StatelessWidget {
  const _CircularBackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF212121),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: const Center(
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontFamily: AppFonts.spaceGrotesk,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class NutritionReadout extends StatelessWidget {
  const NutritionReadout({required this.value, required this.unit});

  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: _DatabaseResultDetailState._fieldColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryColor, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: AppFonts.spaceGrotesk,
                fontSize: 34,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            unit,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: AppFonts.spaceGrotesk,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectionChip extends StatelessWidget {
  const _SelectionChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.expands = false,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool expands;

  @override
  Widget build(BuildContext context) {
    final chip = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: expands ? null : 124,
          height: 42,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: expands ? 6 : 12),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color:
                  isSelected ? AppColors.primaryColor : const Color(0xFF5A5A5A),
              width: isSelected ? 1.4 : 1.2,
            ),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: AppFonts.spaceGrotesk,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );

    return expands ? SizedBox(width: double.infinity, child: chip) : chip;
  }
}

class MacroCard extends StatelessWidget {
  const MacroCard({
    required this.label,
    required this.value,
    required this.progress,
  });

  final String label;
  final double value;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 118,
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 14),
      decoration: BoxDecoration(
        color: _DatabaseResultDetailState._cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: AppFonts.spaceGrotesk,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: progress.clamp(0, 1),
              backgroundColor: const Color(0xFF465057),
              valueColor: const AlwaysStoppedAnimation(AppColors.primaryColor),
            ),
          ),
          const Spacer(),
          Text(
            '${_formatMacroValue(value)}g',
            style: const TextStyle(
              color: Color(0xFFAEB0B1),
              fontFamily: AppFonts.spaceGrotesk,
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  String _formatMacroValue(double value) {
    if ((value - value.round()).abs() < 0.05) {
      return value.round().toString();
    }
    return value.toStringAsFixed(1);
  }
}
