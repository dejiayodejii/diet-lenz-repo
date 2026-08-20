import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/core/services/toast_service.dart';
import 'package:diet_lenz/features/camera/database_result.dart';
import 'package:diet_lenz/features/database/controller/database_history_provider.dart';
import 'package:diet_lenz/features/food_logging/controller/food_logging_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/api.dart';

class FoodSearchResultTile extends ConsumerStatefulWidget {
  const FoodSearchResultTile({
    super.key,
    required this.food,
    this.fromDatabaseSearch = false,
    this.onTap,
    this.onAdd,
  });

  final FoodAnalysisDto food;
  final bool fromDatabaseSearch;
  final VoidCallback? onTap;
  final VoidCallback? onAdd;

  @override
  ConsumerState<FoodSearchResultTile> createState() =>
      _FoodSearchResultTileState();
}

class _FoodSearchResultTileState extends ConsumerState<FoodSearchResultTile> {
  bool _isSubmitting = false;

  Future<void> _logFood() async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    final request = LogMealRequestDto(
        foodAnalysis: widget.food,
        mealType: LogMealRequestDtoMealTypeEnum.DINNER,
        servingMultiplier: 1,
        source_: LogMealRequestDtoSource_Enum.SEARCH);
    final foodLoggingViewModel =
        ref.read(foodLoggingViewModelProvider.notifier);
    final success = await foodLoggingViewModel.logMeal(request);

    if (!mounted) return;

    if (!success) {
      setState(() => _isSubmitting = false);
      final error = ref.read(foodLoggingViewModelProvider).errorMessage;
      ref.read(toastProvider).showError(error ?? 'Failed to log meal');
      return;
    }

    if (widget.fromDatabaseSearch) {
      await ref
          .read(databaseLoggedHistoryProvider.notifier)
          .saveLoggedFood(widget.food);
      if (!mounted) return;
    }

    final today = DateTime.now();
    await Future.wait([
      foodLoggingViewModel.getUserRecipes(date: today, refresh: true),
      foodLoggingViewModel.getDashboard(date: today, refresh: true),
    ]);

    if (!mounted) return;
    setState(() => _isSubmitting = false);
    ref.read(toastProvider).showSuccess('Meal logged successfully!');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xff151211),
        borderRadius: BorderRadius.circular(12),
        // border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: InkWell(
              onTap: widget.onTap ??
                  () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => DatabaseResultDetail(
                          widget.food,
                          trackInDatabaseHistory: widget.fromDatabaseSearch,
                        ),
                      ),
                    );
                  },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.food.foodName?.trim().isNotEmpty == true
                        ? widget.food.foodName!.trim()
                        : 'Unknown food',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${widget.food.totalMacros?.calories ?? 0} cal per 100g',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _isSubmitting ? null : widget.onAdd ?? _logFood,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: SizedBox(
                height: 20,
                width: 20,
                child: _isSubmitting && widget.onAdd == null
                    ? const CircularProgressIndicator(
                        color: AppColors.primaryColor,
                        strokeWidth: 2,
                      )
                    : Image.asset(AppImages.add, scale: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
