import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/food_logging/controller/food_logging_viewmodel.dart';
import 'package:diet_lenz/features/home/views/food_log_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/api.dart';

class FoodLoggedPreview extends ConsumerWidget {
  final MealLogResponseDto loggedMeal;

  const FoodLoggedPreview({
    super.key,
    required this.loggedMeal,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = loggedMeal.isFavorite ?? false;

    return GestureDetector(
      onTap: () {
        NavigationService.push(
          child: FoodLogDetail(
            loggedMeal: loggedMeal,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Stack(
              children: [
                loggedMeal.imageUrl != null && loggedMeal.imageUrl!.isNotEmpty
                    ? Image.network(
                        loggedMeal.imageUrl!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            AppImages.rice,
                            scale: 2,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Image.asset(
                        AppImages.rice,
                        scale: 2,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () async {
                      if (loggedMeal.recipeId != null) {
                        await ref
                            .read(foodLoggingViewModelProvider.notifier)
                            .toggleFavoriteLocally(loggedMeal.recipeId!);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            loggedMeal.foodName ?? "Unknown Food",
            style: const TextStyle(
              fontFamily: AppFonts.lato,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text:
                      '${loggedMeal.consumedMacros?.calories?.toStringAsFixed(0) ?? "0"} kcal',
                  style: const TextStyle(
                    fontFamily: AppFonts.spaceGrotesk,
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const TextSpan(
                  text: ' | ',
                  style: TextStyle(
                    color: Color.fromRGBO(47, 47, 47, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text:
                      'Protein: ${loggedMeal.consumedMacros?.proteinGrams?.toStringAsFixed(0) ?? "0"}g',
                  style: const TextStyle(
                    fontFamily: AppFonts.spaceGrotesk,
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const TextSpan(
                  text: ' | ',
                  style: TextStyle(
                    color: Color.fromRGBO(47, 47, 47, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text:
                      'Carbs: ${loggedMeal.consumedMacros?.carbsGrams?.toStringAsFixed(0) ?? "0"}g',
                  style: const TextStyle(
                    fontFamily: AppFonts.spaceGrotesk,
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const TextSpan(
                  text: ' | ',
                  style: TextStyle(
                    color: Color.fromRGBO(47, 47, 47, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text:
                      'Fat: ${loggedMeal.consumedMacros?.fatGrams?.toStringAsFixed(0) ?? "0"}g',
                  style: const TextStyle(
                    fontFamily: AppFonts.spaceGrotesk,
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
