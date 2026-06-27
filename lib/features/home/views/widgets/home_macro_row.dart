import 'package:diet_lenz/features/food_logging/controller/food_logging_viewmodel.dart';
import 'package:diet_lenz/features/home/views/widgets/macro_nutrients_row.dart';
import 'package:diet_lenz/widgets/macro_row_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeMacroRow extends ConsumerWidget {
  const HomeMacroRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foodLoggingState = ref.watch(foodLoggingViewModelProvider);
    final dashboard = foodLoggingState.dashboard;

    if (foodLoggingState.isLoading && dashboard == null) {
      return const MacroRowShimmer();
    }

    if (dashboard == null) {
      return const MacroNutrientsRow(
        carbCurrent: 0,
        carbTarget: 180,
        proteinCurrent: 0,
        proteinTarget: 135,
        fatCurrent: 0,
        fatTarget: 60,
      );
    }

    final carbCurrent = (dashboard.actuals?.carbsGrams ?? 0).round();
    final carbTarget = (dashboard.targets?.carbsGrams ?? 180).round();
    final proteinCurrent = (dashboard.actuals?.proteinGrams ?? 0).round();
    final proteinTarget = (dashboard.targets?.proteinGrams ?? 135).round();
    final fatCurrent = (dashboard.actuals?.fatGrams ?? 0).round();
    final fatTarget = (dashboard.targets?.fatGrams ?? 60).round();

    return MacroNutrientsRow(
      carbCurrent: carbCurrent,
      carbTarget: carbTarget,
      proteinCurrent: proteinCurrent,
      proteinTarget: proteinTarget,
      fatCurrent: fatCurrent,
      fatTarget: fatTarget,
    );
  }
}
