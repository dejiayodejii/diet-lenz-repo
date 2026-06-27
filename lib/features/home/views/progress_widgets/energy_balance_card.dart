part of '../progress.dart';

class EnergyBalanceCard extends ConsumerWidget {
  const EnergyBalanceCard({
    super.key,
    required this.selectedIndex,
    required this.onRangeChanged,
  });

  static const _tabs = ['Daily', 'Weekly', 'Monthly'];

  final int selectedIndex;
  final ValueChanged<int> onRangeChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(userProfileViewModelProvider);
    if (profileState.isEnergyBalanceStale &&
        !profileState.isEnergyBalanceLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(userProfileViewModelProvider.notifier).getEnergyBalance(
              filter: _tabs[selectedIndex].toLowerCase(),
              refresh: true,
            );
      });
    }

    final healthState = ref.watch(healthProvider);
    final energyBalance = profileState.energyBalance;
    final intakePoints = energyBalance?.chartData ?? const <ChartPoint>[];
    final burnPoints = healthState.healthData.calorieBurnSeries;
    final showInitialLoading = profileState.isEnergyBalanceLoading &&
        energyBalance == null &&
        intakePoints.isEmpty;
    final hasHealthData =
        !healthState.needsPermissions && !healthState.isUnavailable;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 18),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Energy Balance',
            style: TextStyle(
              color: AppColors.white,
              fontFamily: AppFonts.lato,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 26),
          _WeightRangeTabs(
            tabs: _tabs,
            selectedIndex: selectedIndex,
            onChanged: onRangeChanged,
          ),
          const SizedBox(height: 28),
          if (showInitialLoading)
            const SizedBox(height: 300, child: _CalorieChartShimmer())
          else if (intakePoints.isEmpty && burnPoints.isEmpty)
            const SizedBox(height: 300, child: _EnergyBalanceEmptyState())
          else ...[
            SizedBox(
              height: 300,
              child: _EnergyBalanceLineChart(
                intakePoints: intakePoints,
                burnPoints: hasHealthData ? burnPoints : const [],
              ),
            ),
            const SizedBox(height: 18),
            const _EnergyBalanceLegend(),
            if (!hasHealthData) ...[
              const SizedBox(height: 16),
              healthState.needsPermissions
                  ? _HealthPermissionPanel(
                      onRequest: () async {
                        await ref
                            .read(healthProvider.notifier)
                            .requestPermissions();
                      },
                    )
                  : const _HealthUnavailablePanel(),
            ],
            const SizedBox(height: 24),
            _EnergyBalanceSummaryRow(
              intakePoints: intakePoints,
              burnPoints: hasHealthData ? burnPoints : const [],
            ),
          ],
        ],
      ),
    );
  }
}

class _EnergyBalanceLineChart extends StatelessWidget {
  const _EnergyBalanceLineChart({
    required this.intakePoints,
    required this.burnPoints,
  });

  final List<ChartPoint> intakePoints;
  final List<HealthMetricPoint> burnPoints;

  @override
  Widget build(BuildContext context) {
    final points = _buildPoints();
    final intakeSpots = points.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.intake);
    }).toList();
    final burnSpots = points.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.burn);
    }).toList();

    final maxValue = points.fold<double>(0, (current, point) {
      final pointMax = point.intake > point.burn ? point.intake : point.burn;
      return pointMax > current ? pointMax : current;
    });
    final maxY = _roundedChartMax(maxValue);
    final maxX = points.length > 1 ? (points.length - 1).toDouble() : 1.0;

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: maxX,
        minY: 0,
        maxY: maxY,
        gridData: FlGridData(
          drawVerticalLine: false,
          horizontalInterval: maxY / 5,
          getDrawingHorizontalLine: (_) => const FlLine(
            color: Color.fromRGBO(26, 26, 26, 1),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 48,
              interval: maxY / 5,
              getTitlesWidget: (value, meta) {
                if (value == 0) return const SizedBox.shrink();
                return Text(
                  value.round().toString(),
                  style: const TextStyle(
                    color: AppColors.textLightGrey,
                    fontFamily: AppFonts.lato,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 34,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= points.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    points[index].label,
                    style: const TextStyle(
                      color: AppColors.textLightGrey,
                      fontFamily: AppFonts.lato,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: const Color.fromRGBO(43, 49, 58, 1),
            getTooltipItems: (spots) {
              return spots.map((spot) {
                final isIntake = spot.barIndex == 0;
                return LineTooltipItem(
                  '${isIntake ? 'Eaten' : 'Burnt'}: ${spot.y.round()} kcal',
                  TextStyle(
                    color: isIntake ? AppColors.primaryColor : AppColors.white,
                    fontFamily: AppFonts.lato,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          _energyLineBar(intakeSpots, AppColors.primaryColor),
          _energyLineBar(burnSpots, AppColors.white),
        ],
      ),
    );
  }

  LineChartBarData _energyLineBar(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      curveSmoothness: 0.28,
      color: color,
      barWidth: 3.5,
      isStrokeCapRound: true,
      belowBarData: BarAreaData(show: false),
      dotData: const FlDotData(show: false),
    );
  }

  List<_EnergyBalanceChartPoint> _buildPoints() {
    final count = intakePoints.length > burnPoints.length
        ? intakePoints.length
        : burnPoints.length;
    final safeCount = count == 0 ? 7 : count;

    return List.generate(safeCount, (index) {
      final intake =
          index < intakePoints.length ? intakePoints[index].value : null;
      final burn = index < burnPoints.length ? burnPoints[index].value : 0.0;
      final label = _labelForIndex(index);
      return _EnergyBalanceChartPoint(
        label: label,
        intake: intake?.toDouble() ?? 0,
        burn: burn,
      );
    });
  }

  String _labelForIndex(int index) {
    if (index < intakePoints.length) {
      final point = intakePoints[index];
      if ((point.label ?? '').isNotEmpty) return point.label!;
      if (point.date != null) return DateFormat('E').format(point.date!);
    }
    if (index < burnPoints.length && burnPoints[index].label.isNotEmpty) {
      return burnPoints[index].label;
    }
    const fallbackLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return fallbackLabels[index % fallbackLabels.length];
  }

  double _roundedChartMax(double value) {
    if (value <= 0) return 3500;
    final scaled = (value * 1.25).ceilToDouble();
    final rounded = (scaled / 500).ceil() * 500;
    return rounded < 1000 ? 1000 : rounded.toDouble();
  }
}

class _EnergyBalanceChartPoint {
  const _EnergyBalanceChartPoint({
    required this.label,
    required this.intake,
    required this.burn,
  });

  final String label;
  final double intake;
  final double burn;
}

class _EnergyBalanceLegend extends StatelessWidget {
  const _EnergyBalanceLegend();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _EnergyLegendItem(
          color: AppColors.primaryColor,
          label: 'Calories Eaten',
        ),
        SizedBox(width: 28),
        _EnergyLegendItem(
          color: AppColors.white,
          label: 'Calories Burnt',
        ),
      ],
    );
  }
}

class _EnergyLegendItem extends StatelessWidget {
  const _EnergyLegendItem({
    required this.color,
    required this.label,
  });

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.white,
            fontFamily: AppFonts.lato,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _EnergyBalanceSummaryRow extends StatelessWidget {
  const _EnergyBalanceSummaryRow({
    required this.intakePoints,
    required this.burnPoints,
  });

  final List<ChartPoint> intakePoints;
  final List<HealthMetricPoint> burnPoints;

  @override
  Widget build(BuildContext context) {
    final deficitDays = _deficitDays();
    final bestBurn = _bestBurnLabel();
    final averageIntake = _averageIntake();

    return Row(
      children: [
        Expanded(
          child: _EnergySummaryTile(
            value: '$deficitDays ${deficitDays == 1 ? 'Day' : 'Days'}',
            label: 'Deficit',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _EnergySummaryTile(
            value: bestBurn,
            label: 'Best Burn',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _EnergySummaryTile(
            value: averageIntake > 0 ? averageIntake.round().toString() : '--',
            label: 'Average Intake',
          ),
        ),
      ],
    );
  }

  int _deficitDays() {
    final count = intakePoints.length < burnPoints.length
        ? intakePoints.length
        : burnPoints.length;
    var days = 0;
    for (var index = 0; index < count; index++) {
      final intake = intakePoints[index].value;
      if (intake != null && burnPoints[index].value > intake.toDouble()) {
        days++;
      }
    }
    return days;
  }

  String _bestBurnLabel() {
    if (burnPoints.isEmpty) return '--';
    var best = burnPoints.first;
    for (final point in burnPoints.skip(1)) {
      if (point.value > best.value) best = point;
    }
    if (best.value <= 0) return '--';
    return best.label.isNotEmpty
        ? best.label
        : DateFormat('E').format(best.date);
  }

  double _averageIntake() {
    final values = intakePoints
        .map((point) => point.value?.toDouble())
        .whereType<double>()
        .where((value) => value > 0)
        .toList();
    if (values.isEmpty) return 0;
    final total = values.fold<double>(0, (sum, value) => sum + value);
    return total / values.length;
  }
}

class _EnergySummaryTile extends StatelessWidget {
  const _EnergySummaryTile({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(43, 49, 58, 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              maxLines: 1,
              style: const TextStyle(
                color: AppColors.white,
                fontFamily: AppFonts.lato,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            style: const TextStyle(
              color: AppColors.textLightGrey,
              fontFamily: AppFonts.lato,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _EnergyBalanceEmptyState extends StatelessWidget {
  const _EnergyBalanceEmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No energy balance data yet',
        style: TextStyle(
          color: AppColors.textLightGrey,
          fontFamily: AppFonts.lato,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
