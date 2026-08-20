import 'package:diet_lenz/core/providers/api_providers.dart';
import 'package:diet_lenz/core/services/api_service.dart';
import 'package:diet_lenz/features/camera/analyse_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openapi/api.dart';

void main() {
  testWidgets('food name can be edited inline', (tester) async {
    final food = FoodAnalysisDto(
      foodName: 'Jollof Rice',
      totalMacros: MacroNutrientsDto(calories: 250),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [apiServiceProvider.overrideWithValue(ApiService())],
        child: MaterialApp(home: AnalyseResultDetail(food)),
      ),
    );

    final foodNameField = find.byKey(const ValueKey('food_name_field'));
    expect(foodNameField, findsOneWidget);

    await tester.enterText(foodNameField, 'Chicken Jollof Rice');
    await tester.pump();

    final field = tester.widget<TextField>(foodNameField);
    expect(field.controller?.text, 'Chicken Jollof Rice');
  });

  test('removes bracketed details from displayed measure labels', () {
    expect(measureLabelWithoutBrackets('Cup (250 ml)'), 'Cup');
    expect(
        measureLabelWithoutBrackets('Serving [100 g] {prepared}'), 'Serving');
    expect(measureLabelWithoutBrackets('(100 g)'), 'Measure');
  });

  test('uses the originating source for new logs', () {
    final source = resolveAnalyseResultSource(
      source: LogMealRequestDtoSource_Enum.BARCODE,
    );

    expect(source, LogMealRequestDtoSource_Enum.BARCODE);
  });

  test('preserves the saved source when editing a log', () {
    final source = resolveAnalyseResultSource(
      source: LogMealRequestDtoSource_Enum.AI_IMAGE,
      loggedMeal: MealLogResponseDto(
        foodSource: MealLogResponseDtoFoodSourceEnum.NUTRITION_LABEL,
      ),
    );

    expect(source, LogMealRequestDtoSource_Enum.NUTRITION_LABEL);
  });

  testWidgets('amount scales displayed calories and macros', (tester) async {
    final food = FoodAnalysisDto(
      foodName: 'Jollof Rice',
      description: 'One serving',
      imageBase64:
          'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=',
      totalMacros: MacroNutrientsDto(
        calories: 250,
        protein: QuantityDto(value: 8, unit: 'g'),
        carbs: QuantityDto(value: 40, unit: 'g'),
        fat: QuantityDto(value: 6, unit: 'g'),
        fiber: QuantityDto(value: 3, unit: 'g'),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          apiServiceProvider.overrideWithValue(ApiService()),
        ],
        child: MaterialApp(home: AnalyseResultDetail(food)),
      ),
    );

    expect(find.widgetWithText(TextField, '1'), findsOneWidget);
    expect(find.text('250'), findsOneWidget);
    expect(find.text('Kcal'), findsOneWidget);
    expect(find.text('40g'), findsOneWidget);
    expect(find.text('8g'), findsOneWidget);
    expect(find.text('6g'), findsOneWidget);
    expect(find.text('Fiber'), findsOneWidget);
    expect(find.text('3g'), findsOneWidget);
    final imageProviderBefore = tester.widget<Image>(find.byType(Image)).image;

    await tester.enterText(find.widgetWithText(TextField, '1'), '2');
    await tester.pump();

    expect(find.text('500'), findsOneWidget);
    expect(find.text('80g'), findsOneWidget);
    expect(find.text('16g'), findsOneWidget);
    expect(find.text('12g'), findsOneWidget);
    expect(find.text('6g'), findsOneWidget);
    final imageProviderAfter = tester.widget<Image>(find.byType(Image)).image;
    expect(identical(imageProviderBefore, imageProviderAfter), isTrue);
  });

  testWidgets('measures use amount times weight divided by 100',
      (tester) async {
    final food = FoodAnalysisDto(
      foodName: 'Rice',
      description: 'Measured food',
      totalMacros: MacroNutrientsDto(
        calories: 100,
        protein: QuantityDto(value: 5, unit: 'g'),
        carbs: QuantityDto(value: 20, unit: 'g'),
        fat: QuantityDto(value: 2, unit: 'g'),
        fiber: QuantityDto(value: 1, unit: 'g'),
      ),
      measures: [
        MeasureDto(label: 'Gram', weightGrams: 1),
        MeasureDto(label: 'Serving', weightGrams: 200),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          apiServiceProvider.overrideWithValue(ApiService()),
        ],
        child: MaterialApp(home: AnalyseResultDetail(food)),
      ),
    );

    expect(find.text('Measurement'), findsOneWidget);
    expect(find.text('1'), findsWidgets);

    await tester.ensureVisible(find.text('Serving'));
    await tester.tap(find.text('Serving'));
    await tester.pump();

    expect(find.text('200'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, '1'), '2');
    await tester.pump();

    expect(find.text('400'), findsOneWidget);
    expect(find.text('80g'), findsOneWidget);
    expect(find.text('20g'), findsOneWidget);
    expect(find.text('8g'), findsOneWidget);
    expect(find.text('4g'), findsOneWidget);
  });

  testWidgets('editing starts with scaled totals and adjusts by amount ratio',
      (tester) async {
    final food = FoodAnalysisDto(
      foodName: 'Jollof Rice',
      totalMacros: MacroNutrientsDto(
        calories: 500,
        protein: QuantityDto(value: 16, unit: 'g'),
        carbs: QuantityDto(value: 80, unit: 'g'),
        fat: QuantityDto(value: 12, unit: 'g'),
        fiber: QuantityDto(value: 6, unit: 'g'),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [apiServiceProvider.overrideWithValue(ApiService())],
        child: MaterialApp(
          home: AnalyseResultDetail(
            food,
            loggedMeal: MealLogResponseDto(
              id: 'meal-1',
              servingMultiplier: 2,
              mealType: MealLogResponseDtoMealTypeEnum.DINNER,
            ),
          ),
        ),
      ),
    );

    expect(find.text('500'), findsOneWidget);
    expect(find.text('80g'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, '2'), '4');
    await tester.pump();

    expect(find.text('1000'), findsOneWidget);
    expect(find.text('160g'), findsOneWidget);
  });
}
