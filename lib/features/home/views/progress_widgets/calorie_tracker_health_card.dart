part of '../progress.dart';

class CalorieTrackerHealthCard extends StatelessWidget {
  const CalorieTrackerHealthCard({
    super.key,
    required this.healthState,
    required this.selectedIndex,
    required this.onRangeChanged,
    required this.onRequestPermissions,
  });

  static const _tabs = ['Daily', 'Weekly', 'Monthly'];

  final HealthUiState healthState;
  final int selectedIndex;
  final ValueChanged<int> onRangeChanged;
  final Future<void> Function() onRequestPermissions;

  @override
  Widget build(BuildContext context) {
    final showInitialLoading = healthState.isLoading &&
        healthState.healthData.calorieBurnSeries.isEmpty &&
        healthState.healthData.activeCalories == 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 18),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Calorie Tracker',
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
          if (healthState.needsPermissions)
            _HealthPermissionPanel(onRequest: onRequestPermissions)
          else if (healthState.isUnavailable)
            const _HealthUnavailablePanel()
          else ...[
            SizedBox(
              height: 250,
              child: showInitialLoading
                  ? const _CalorieChartShimmer()
                  : _CalorieBurnLineChart(
                      points: healthState.healthData.calorieBurnSeries,
                    ),
            ),
            const SizedBox(height: 18),
            showInitialLoading
                ? const _HealthMetricTileShimmerRow()
                : _HealthMetricTileRow(healthData: healthState.healthData),
          ],
        ],
      ),
    );
  }
}

class _CalorieBurnLineChart extends StatelessWidget {
  const _CalorieBurnLineChart({required this.points});

  final List<HealthMetricPoint> points;

  @override
  Widget build(BuildContext context) {
    final safePoints = points.isEmpty
        ? [
            HealthMetricPoint(
              label: 'Mon',
              date: DateTime(1970),
              value: 0,
            ),
          ]
        : points;
    final spots = safePoints.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.value);
    }).toList();
    final maxValue =
        spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
    final maxY = _roundedChartMax(maxValue);
    final maxX = spots.length > 1 ? (spots.length - 1).toDouble() : 1.0;

    return Stack(
      children: [
        LineChart(
          LineChartData(
            minX: 0,
            maxX: maxX,
            minY: 0,
            maxY: maxY,
            gridData: FlGridData(
              drawVerticalLine: true,
              verticalInterval: 1,
              horizontalInterval: maxY / 4,
              getDrawingHorizontalLine: (_) => const FlLine(
                color: Color.fromRGBO(48, 48, 48, 1),
                strokeWidth: 1,
              ),
              getDrawingVerticalLine: (_) => const FlLine(
                color: Color.fromRGBO(48, 48, 48, 1),
                strokeWidth: 1,
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: const Border(
                left: BorderSide(color: Color.fromRGBO(48, 48, 48, 1)),
                bottom: BorderSide(color: Color.fromRGBO(48, 48, 48, 1)),
              ),
            ),
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
                  reservedSize: 44,
                  interval: maxY / 4,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      _formatAxisValue(value),
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
                  reservedSize: 32,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index < 0 || index >= safePoints.length) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        safePoints[index].label,
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
                tooltipBgColor: AppColors.primaryColor,
                getTooltipItems: (spots) {
                  return spots.map((spot) {
                    return LineTooltipItem(
                      '${spot.y.round()} cal',
                      const TextStyle(
                        color: Colors.black,
                        fontFamily: AppFonts.lato,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    );
                  }).toList();
                },
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                curveSmoothness: 0.22,
                color: AppColors.primaryColor,
                barWidth: 3,
                isStrokeCapRound: true,
                belowBarData: BarAreaData(show: false),
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: AppColors.primaryColor,
                      strokeWidth: 0,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        if (spots.isNotEmpty)
          Positioned(
            left: 0,
            right: 0,
            top: 70,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b).round()} kcal',
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: AppFonts.lato,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  double _roundedChartMax(double value) {
    if (value <= 0) return 600;

    final scaled = (value * 1.25).ceilToDouble();
    final step = scaled <= 1000
        ? 100
        : scaled <= 5000
            ? 500
            : 1000;
    final rounded = (scaled / step).ceil() * step;
    return rounded < 600 ? 600 : rounded.toDouble();
  }

  String _formatAxisValue(double value) {
    if (value >= 1000) {
      final thousands = value / 1000;
      return thousands % 1 == 0
          ? '${thousands.toInt()}k'
          : '${thousands.toStringAsFixed(1)}k';
    }

    return value.round().toString();
  }
}

class _HealthMetricTileRow extends StatelessWidget {
  const _HealthMetricTileRow({required this.healthData});

  final HealthData healthData;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _HealthMetricTile(
            icon: Image.asset(AppImages.step, height: 26, width: 26),
            value: _formatNumber(healthData.steps),
            label: 'STEPS',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _HealthMetricTile(
            icon: Image.asset(AppImages.burn, height: 26, width: 26),
            value: '${_formatNumber(healthData.activeCalories)} CAL',
            label: 'CAL BURN',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _HealthMetricTile(
            icon: Image.asset(AppImages.heart, height: 26, width: 26),
            value: healthData.heartRateAvg != null
                ? '${healthData.heartRateAvg!.round()} BPM'
                : '-- BPM',
            label: 'HEARTBEAT',
          ),
        ),
      ],
    );
  }

  String _formatNumber(num value) {
    if (value >= 1000) {
      return value is int
          ? NumberFormat.decimalPattern().format(value)
          : value.toStringAsFixed(value >= 100 ? 0 : 1);
    }
    return value.round().toString();
  }
}

class _HealthMetricTile extends StatelessWidget {
  const _HealthMetricTile({
    required this.icon,
    required this.value,
    required this.label,
  });

  final Widget icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(43, 49, 58, 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(height: 14),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              maxLines: 1,
              style: const TextStyle(
                color: AppColors.white,
                fontFamily: AppFonts.lato,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 2),
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

class _HealthPermissionPanel extends StatelessWidget {
  const _HealthPermissionPanel({required this.onRequest});

  final Future<void> Function() onRequest;

  @override
  Widget build(BuildContext context) {
    final source = Platform.isIOS ? 'Apple Health' : 'Health Connect';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Platform.isAndroid
              ? 'Diet Lenz reads your steps, active calories burned, and heart '
                  'rate from Health Connect to display daily, weekly, and monthly '
                  'activity metrics alongside your nutrition and weight progress. '
                  'Access is optional and read-only. This data is not used for '
                  'advertising or shared with third parties.'
              : 'Connect $source to show your steps, active calories burned, and '
                  'heart rate alongside your nutrition and weight progress.',
          style: const TextStyle(
            color: AppColors.textLightGrey,
            fontFamily: AppFonts.lato,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: CustomYafButton(
            text: 'Connect $source',
            width: double.infinity,
            height: 50,
            radius: 14,
            onPressed: onRequest,
          ),
        ),
      ],
    );
  }
}

class _HealthUnavailablePanel extends StatelessWidget {
  const _HealthUnavailablePanel();

  @override
  Widget build(BuildContext context) {
    final source = Platform.isIOS ? 'Apple Health' : 'Health Connect';
    return Text(
      '$source is not available on this device.',
      style: const TextStyle(
        color: AppColors.textLightGrey,
        fontFamily: AppFonts.lato,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _CalorieChartShimmer extends StatelessWidget {
  const _CalorieChartShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color.fromRGBO(31, 36, 39, 1),
      highlightColor: const Color.fromRGBO(58, 63, 70, 1),
      child: Padding(
        padding: const EdgeInsets.only(left: 36, bottom: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            5,
            (index) => Container(
              height: 2,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HealthMetricTileShimmerRow extends StatelessWidget {
  const _HealthMetricTileShimmerRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        3,
        (index) => Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 0 : 5,
              right: index == 2 ? 0 : 5,
            ),
            child: Shimmer.fromColors(
              baseColor: const Color.fromRGBO(31, 36, 39, 1),
              highlightColor: const Color.fromRGBO(58, 63, 70, 1),
              child: Container(
                height: 106,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
