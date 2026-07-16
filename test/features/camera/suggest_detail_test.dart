import 'package:diet_lenz/core/providers/api_providers.dart';
import 'package:diet_lenz/core/services/api_service.dart';
import 'package:diet_lenz/features/camera/suggest_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openapi/api.dart';

void main() {
  testWidgets('portion scales suggestion calories and macro cards',
      (tester) async {
    final suggestion = SuggestedFoodAnalysis(
      foodName: 'Chicken Salad',
      description: 'One suggested portion',
      totalMacros: MacroNutrientsDto(
        calories: 250,
        protein: QuantityDto(value: 20, unit: 'g'),
        carbs: QuantityDto(value: 30, unit: 'g'),
        fat: QuantityDto(value: 10, unit: 'g'),
        fiber: QuantityDto(value: 5, unit: 'g'),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          apiServiceProvider.overrideWithValue(ApiService()),
        ],
        child: MaterialApp(
          home: SuggestMealDetailScreen(
            suggestion: suggestion,
            headerImage: const SizedBox(height: 350),
          ),
        ),
      ),
    );

    expect(find.text('Portion'), findsOneWidget);
    expect(find.text('250'), findsOneWidget);
    expect(find.text('Carb'), findsOneWidget);
    expect(find.text('Protein'), findsOneWidget);
    expect(find.text('Fat'), findsOneWidget);
    expect(find.text('Fiber'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, '1'), '2');
    await tester.pump();

    expect(find.text('500'), findsOneWidget);
    expect(find.text('60g'), findsOneWidget);
    expect(find.text('40g'), findsOneWidget);
    expect(find.text('20g'), findsOneWidget);
    expect(find.text('10g'), findsOneWidget);
  });
}
