import 'package:diet_lenz/features/camera/database_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openapi/api.dart';

void main() {
  testWidgets('measurement count and weight scale nutrition', (tester) async {
    final food = FoodAnalysisDto(
      foodName: 'Rice Cooked',
      description: 'Generic foods',
      totalMacros: MacroNutrientsDto(
        calories: 130,
        protein: QuantityDto(value: 2.69, unit: 'g'),
        carbs: QuantityDto(value: 28.2, unit: 'g'),
        fat: QuantityDto(value: 0.28, unit: 'g'),
        fiber: QuantityDto(value: 0.4, unit: 'g'),
      ),
      measures: [
        MeasureDto(label: 'Serving', weightGrams: 200),
        MeasureDto(label: 'Gram', weightGrams: 1),
        MeasureDto(label: 'Cup', weightGrams: 158),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: DatabaseResultDetail(food)),
      ),
    );

    expect(find.text('1.3'), findsOneWidget);
    expect(find.widgetWithText(TextField, '1'), findsOneWidget);

    await tester.tap(find.text('Serving'));
    await tester.pump();

    expect(find.widgetWithText(TextField, '1'), findsOneWidget);
    expect(find.text('260'), findsOneWidget);
    expect(find.text('Fiber'), findsOneWidget);
    expect(find.text('0.8g'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '2');
    await tester.pump();

    expect(find.text('520'), findsOneWidget);
    expect(find.text('1.6g'), findsOneWidget);

    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cup'));
    await tester.pump();

    expect(find.widgetWithText(TextField, '2'), findsOneWidget);
    expect(find.text('410.8'), findsOneWidget);
  });

  testWidgets('editing scales from the already-saved amount', (tester) async {
    final food = FoodAnalysisDto(
      foodName: 'Rice Cooked',
      totalMacros: MacroNutrientsDto(
        calories: 410.8,
        protein: QuantityDto(value: 8.5, unit: 'g'),
        carbs: QuantityDto(value: 89.1, unit: 'g'),
        fat: QuantityDto(value: 0.9, unit: 'g'),
        fiber: QuantityDto(value: 1.3, unit: 'g'),
      ),
      measures: [MeasureDto(label: 'Cup', weightGrams: 158)],
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: DatabaseResultDetail(
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

    expect(find.text('410.8'), findsOneWidget);
    await tester.enterText(find.widgetWithText(TextField, '2'), '4');
    await tester.pump();

    expect(find.text('821.6'), findsOneWidget);
  });
}
