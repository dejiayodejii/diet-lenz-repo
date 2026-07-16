import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/core/constants/app_colors.dart';
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
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            color: Color(0xff151211),
            width: double.infinity,
            child: Row(
              children: [
                loggedMeal.imageUrl != null && loggedMeal.imageUrl!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          loggedMeal.imageUrl!,
                          height: 70,
                          width: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              AppImages.rice,
                              scale: 2,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      )
                    : SizedBox.shrink(),
                // Positioned(
                //   top: 10,
                //   right: 10,
                //   child: GestureDetector(
                //     onTap: () async {
                //       if (loggedMeal.recipeId != null) {
                //         await ref
                //             .read(foodLoggingViewModelProvider.notifier)
                //             .toggleFavoriteLocally(loggedMeal.recipeId!);
                //       }
                //     },
                //     child: Container(
                //       padding: const EdgeInsets.all(8),
                //       decoration: BoxDecoration(
                //         color: Colors.black.withValues(alpha: 0.6),
                //         shape: BoxShape.circle,
                //       ),
                //       child: Icon(
                //         isFavorite ? Icons.favorite : Icons.favorite_border,
                //         color: isFavorite ? Colors.red : Colors.white,
                //         size: 24,
                //       ),
                //     ),
                //   ),
                // ),

                loggedMeal.imageUrl != null && loggedMeal.imageUrl!.isNotEmpty
                    ? const SizedBox(width: 10)
                    : SizedBox.shrink(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  loggedMeal.foodName ?? "Unknown Food",
                                  style: const TextStyle(
                                    fontFamily: AppFonts.lato,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${loggedMeal.consumedMacros?.calories?.toStringAsFixed(0) ?? "0"} kcal',
                                  style: const TextStyle(
                                    fontFamily: AppFonts.lato,
                                    fontSize: 18,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 8,
                                    width: 8,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xff999999)),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Protein: ${loggedMeal.consumedMacros?.proteinGrams?.toStringAsFixed(0) ?? "0"}g',
                                    style: const TextStyle(
                                      fontFamily: AppFonts.lato,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 8,
                                    width: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Carbs: ${loggedMeal.consumedMacros?.carbsGrams?.toStringAsFixed(0) ?? "0"}g',
                                    style: const TextStyle(
                                      fontFamily: AppFonts.lato,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 8,
                                    width: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Fat: ${loggedMeal.consumedMacros?.fatGrams?.toStringAsFixed(0) ?? "0"}g',
                                    style: const TextStyle(
                                      fontFamily: AppFonts.lato,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
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
