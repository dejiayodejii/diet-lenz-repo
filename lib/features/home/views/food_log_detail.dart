import 'package:diet_lenz/api_client/lib/api.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/widgets/calorie_badge.dart';
import 'package:diet_lenz/widgets/macro_progress_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FoodLogDetail extends ConsumerStatefulWidget {
  final RecipeResponseDto? recipe;
  final FavoriteRecipeResponseDto? favorite;

  const FoodLogDetail({
    super.key,
    this.recipe,
    this.favorite,
  }) : assert(recipe != null || favorite != null,
            'Either recipe or favorite must be provided');

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FoodLogDetailState();
}

class _FoodLogDetailState extends ConsumerState<FoodLogDetail> {
  // Helper getters to extract data from either recipe or favorite
  String get foodName =>
      widget.recipe?.foodName ?? widget.favorite?.foodName ?? "Unknown Food";

  String get description =>
      widget.recipe?.description ??
      widget.favorite?.description ??
      "No description available";

  String? get imageUrl => widget.recipe?.imageUrl ?? widget.favorite?.imageUrl;

  MacroInfoDto? get macros => widget.recipe?.macros ?? widget.favorite?.macros;

  double get calories => macros?.calories ?? 0.0;
  double get protein => macros?.proteinGrams ?? 0.0;
  double get carbs => macros?.carbsGrams ?? 0.0;
  double get fat => macros?.fatGrams ?? 0.0;
  double get fiber => macros?.fiberGrams ?? 0.0;

  double get totalWeight => protein + carbs + fat + fiber;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display image from URL or fallback to default
              imageUrl != null && imageUrl!.isNotEmpty
                  ? Image.network(
                      imageUrl!,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          AppImages.chicken,
                          scale: 2,
                        );
                      },
                    )
                  : Image.asset(
                      AppImages.chicken,
                      scale: 2,
                    ),
              const SizedBox(height: 20),
              Text(
                foodName,
                style: const TextStyle(
                  fontFamily: AppFonts.lato,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  CalorieBadge(
                    text: '${calories.toStringAsFixed(0)} cal',
                  ),
                  const SizedBox(width: 15),
                  CalorieBadge(
                    text: '${totalWeight.toStringAsFixed(0)}g',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                description,
                style: const TextStyle(
                  fontFamily: AppFonts.lato,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),
              MacroProgressItem(
                label: 'Protein',
                currentValue: '${protein.toStringAsFixed(1)}g',
                targetValue: '',
                progress: getRelativeProgress(protein),
              ),
              const SizedBox(height: 20),
              MacroProgressItem(
                label: 'Carbs',
                currentValue: '${carbs.toStringAsFixed(1)}g',
                targetValue: '',
                progress: getRelativeProgress(carbs),
              ),
              const SizedBox(height: 20),
              MacroProgressItem(
                label: 'Fat',
                currentValue: '${fat.toStringAsFixed(1)}g',
                targetValue: '',
                progress: getRelativeProgress(fat),
              ),
              const SizedBox(height: 20),
              MacroProgressItem(
                label: 'Fiber',
                currentValue: '${fiber.toStringAsFixed(1)}g',
                targetValue: '',
                progress: getRelativeProgress(fiber),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
