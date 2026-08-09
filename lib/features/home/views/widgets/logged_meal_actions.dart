import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/core/services/toast_service.dart';
import 'package:diet_lenz/features/food_logging/controller/food_logging_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/api.dart';

class LoggedMealActions extends ConsumerStatefulWidget {
  const LoggedMealActions({
    super.key,
    required this.loggedMeal,
    this.onDeleted,
  });

  final MealLogResponseDto loggedMeal;
  final VoidCallback? onDeleted;

  @override
  ConsumerState<LoggedMealActions> createState() => _LoggedMealActionsState();
}

class _LoggedMealActionsState extends ConsumerState<LoggedMealActions> {
  late bool _isFavorite;
  bool _isTogglingFavorite = false;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.loggedMeal.isFavorite ?? false;
  }

  @override
  void didUpdateWidget(covariant LoggedMealActions oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.loggedMeal.isFavorite != widget.loggedMeal.isFavorite) {
      _isFavorite = widget.loggedMeal.isFavorite ?? false;
    }
  }

  Future<void> _toggleFavorite() async {
    final recipeId = widget.loggedMeal.recipeId;
    if (recipeId == null || recipeId.isEmpty || _isTogglingFavorite) {
      if (recipeId == null || recipeId.isEmpty) {
        ref
            .read(toastProvider)
            .showError('Favorite is unavailable for this meal');
      }
      return;
    }

    final wasFavorite = _isFavorite;
    setState(() {
      _isFavorite = !wasFavorite;
      _isTogglingFavorite = true;
    });

    final success = await ref
        .read(foodLoggingViewModelProvider.notifier)
        .toggleFavoriteLocally(recipeId, fallbackRecipe: widget.loggedMeal);
    if (!mounted) return;

    setState(() {
      _isTogglingFavorite = false;
      if (!success) _isFavorite = wasFavorite;
    });

    if (!success) {
      final error = ref.read(foodLoggingViewModelProvider).errorMessage;
      ref.read(toastProvider).showError(error ?? 'Failed to update favorite');
      return;
    }

    ref.read(toastProvider).showSuccess(
          wasFavorite ? 'Removed from favorites' : 'Added to favorites',
        );
  }

  Future<void> _confirmDelete() async {
    final id = widget.loggedMeal.id;
    if (id == null || id.isEmpty || _isDeleting) {
      if (id == null || id.isEmpty) {
        ref.read(toastProvider).showError('Unable to delete this meal log');
      }
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.backgroundColor,
        title:
            const Text('Delete meal?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'This will remove the meal from your food log.',
          style: TextStyle(color: AppColors.textLightGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
    if (shouldDelete != true || !mounted) return;

    setState(() => _isDeleting = true);
    final loggedDate = widget.loggedMeal.loggedDate ?? DateTime.now();
    final success = await ref
        .read(foodLoggingViewModelProvider.notifier)
        .deleteMealLog(id: id, loggedDate: loggedDate);
    if (!mounted) return;

    if (!success) {
      setState(() => _isDeleting = false);
      final error = ref.read(foodLoggingViewModelProvider).errorMessage;
      ref.read(toastProvider).showError(error ?? 'Failed to delete meal');
      return;
    }

    ref.read(foodLoggingViewModelProvider.notifier)
      ..getUserRecipes(date: loggedDate, refresh: true)
      ..getDashboard(date: loggedDate, refresh: true);
    ref.read(toastProvider).showSuccess('Meal deleted successfully');
    widget.onDeleted?.call();
    if (widget.onDeleted == null && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canFavorite = widget.loggedMeal.recipeId?.isNotEmpty == true;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _isDeleting ? null : _confirmDelete,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: _isDeleting
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.delete_outline),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        GestureDetector(
          onTap: _isTogglingFavorite ? null : _toggleFavorite,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: _isTogglingFavorite
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.redAccent : null,
                  ),
          ),
        ),
      ],
    );
  }
}
