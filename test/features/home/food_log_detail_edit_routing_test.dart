import 'package:diet_lenz/core/providers/api_providers.dart';
import 'package:diet_lenz/core/services/api_service.dart';
import 'package:diet_lenz/features/camera/analyse_result.dart';
import 'package:diet_lenz/features/camera/database_result.dart';
import 'package:diet_lenz/features/camera/suggest_detail.dart';
import 'package:diet_lenz/features/database/views/manual_log_screen.dart';
import 'package:diet_lenz/features/home/views/food_log_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openapi/api.dart';

void main() {
  testWidgets('manual meals edit in ManualLogScreen', (tester) async {
    await _openEditor(
      tester,
      _meal(source: MealLogResponseDtoFoodSourceEnum.MANUAL),
    );

    expect(find.byType(ManualLogScreen), findsOneWidget);
    expect(find.widgetWithText(TextField, '420'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, '2'), '4');
    await tester.pump();

    expect(find.widgetWithText(TextField, '840'), findsOneWidget);
  });

  testWidgets('search meals edit in DatabaseResultDetail', (tester) async {
    await _openEditor(
      tester,
      _meal(source: MealLogResponseDtoFoodSourceEnum.SEARCH),
    );

    expect(find.byType(DatabaseResultDetail), findsOneWidget);
  });

  testWidgets('AI meals without an image edit in SuggestMealDetailScreen',
      (tester) async {
    await _openEditor(
      tester,
      _meal(source: MealLogResponseDtoFoodSourceEnum.AI_IMAGE),
    );

    expect(find.byType(SuggestMealDetailScreen), findsOneWidget);
  });

  testWidgets('AI meals with an image edit in AnalyseResultDetail',
      (tester) async {
    await _openEditor(
      tester,
      _meal(
        source: MealLogResponseDtoFoodSourceEnum.AI_IMAGE,
        imageBase64:
            'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=',
      ),
    );

    expect(find.byType(AnalyseResultDetail), findsOneWidget);
  });
}

Future<void> _openEditor(
  WidgetTester tester,
  MealLogResponseDto meal,
) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [apiServiceProvider.overrideWithValue(ApiService())],
      child: MaterialApp(home: FoodLogDetail(loggedMeal: meal)),
    ),
  );
  await tester.tap(find.byTooltip('Edit meal'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

MealLogResponseDto _meal({
  required MealLogResponseDtoFoodSourceEnum source,
  String? imageUrl,
  String? imageBase64,
}) {
  return MealLogResponseDto(
    id: 'meal-1',
    foodName: 'Rice bowl',
    foodSource: source,
    imageUrl: imageUrl,
    mealType: MealLogResponseDtoMealTypeEnum.DINNER,
    loggedDate: DateTime(2026, 7, 16),
    servingMultiplier: 2,
    foodAnalysis: FoodAnalysisDto(
      foodName: 'Rice bowl',
      description: 'Rice and vegetables',
      imageBase64: imageBase64,
      totalMacros: MacroNutrientsDto(
        calories: 420,
        protein: QuantityDto(value: 15, unit: 'g'),
        carbs: QuantityDto(value: 60, unit: 'g'),
        fat: QuantityDto(value: 12, unit: 'g'),
        fiber: QuantityDto(value: 8, unit: 'g'),
      ),
      measures: [MeasureDto(label: 'Serving', weightGrams: 100)],
    ),
  );
}
