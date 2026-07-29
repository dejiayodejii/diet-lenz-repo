import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/core/constants/app_colors.dart';
import 'package:diet_lenz/core/services/toast_service.dart';
import 'package:diet_lenz/features/home/views/logged_meal_edit_screen.dart';
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
    return GestureDetector(
      onTap: () {
        final editScreen = buildLoggedMealEditScreen(loggedMeal);
        if (editScreen == null) {
          ref.read(toastProvider).showError('Edit not available for this meal');
          return;
        }
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => editScreen),
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
                                  '${loggedMeal.foodAnalysis?.totalMacros?.calories?.toStringAsFixed(1) ?? "0"} cal',
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
                                    'Protein: ${loggedMeal.foodAnalysis?.totalMacros?.protein?.value?.toStringAsFixed(0) ?? "0"}g',
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
                                    'Carbs: ${loggedMeal.foodAnalysis?.totalMacros?.carbs?.value?.toStringAsFixed(0) ?? "0"}g',
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
                                    'Fat: ${loggedMeal.foodAnalysis?.totalMacros?.fat?.value?.toStringAsFixed(2) ?? "0"}g',
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
