import 'package:diet_lenz/core/providers/api_providers.dart';
import 'package:diet_lenz/core/providers/storage_providers.dart';
import 'package:diet_lenz/core/services/api_service.dart';
import 'package:diet_lenz/core/services/storage_service.dart';
import 'package:diet_lenz/features/database/views/manual_log_screen.dart';
import 'package:diet_lenz/features/recipe/controller/recipe_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openapi/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _IngredientRecipeViewModel extends RecipeViewModel {
  _IngredientRecipeViewModel(this.food) : super(ApiService());

  final FoodAnalysisDto food;

  @override
  Future<bool> searchFood(String query) async {
    state = RecipeState(
      searchResults: [food],
      searchQuery: query.trim(),
    );
    return true;
  }
}

void main() {
  testWidgets('selected database ingredient updates totals and can be removed',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final storageService = await StorageService.getInstance();
    final ingredient = FoodAnalysisDto(
      foodName: 'Cooked rice',
      totalMacros: MacroNutrientsDto(
        calories: 130,
        protein: QuantityDto(value: 2.7, unit: 'g'),
        carbs: QuantityDto(value: 28.2, unit: 'g'),
        fat: QuantityDto(value: 0.3, unit: 'g'),
        fiber: QuantityDto(value: 0.4, unit: 'g'),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          apiServiceProvider.overrideWithValue(ApiService()),
          storageServiceProvider.overrideWithValue(storageService),
          recipeViewModelProvider.overrideWith(
            (ref) => _IngredientRecipeViewModel(ingredient),
          ),
        ],
        child: const MaterialApp(home: ManualLogScreen()),
      ),
    );

    await tester.scrollUntilVisible(
      find.text('Add Ingredient'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Add Ingredient'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'rice');
    await tester.tap(find.byIcon(Icons.search));
    await tester.pump();
    expect(find.text('Cooked rice'), findsOneWidget);

    await tester.tap(find.text('Cooked rice'));
    await tester.pumpAndSettle();

    expect(find.byType(InputChip), findsOneWidget);
    expect(find.text('130 kcal'), findsOneWidget);
    expect(find.text('Protein: 2.7g'), findsOneWidget);
    expect(find.text('Carbs: 28.2g'), findsOneWidget);
    expect(find.text('Fat: 0.3g'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();

    expect(find.byType(InputChip), findsNothing);
    expect(find.text('__ kcal'), findsOneWidget);
  });
}
