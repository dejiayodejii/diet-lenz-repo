part of '../progress.dart';

class WeightProgressCard extends ConsumerStatefulWidget {
  const WeightProgressCard({super.key});

  @override
  ConsumerState<WeightProgressCard> createState() => _WeightProgressCardState();
}

class _WeightProgressCardState extends ConsumerState<WeightProgressCard> {
  static const _tabs = ['Daily', 'Weekly', 'Monthly'];

  int _selectedTab = 0;

  String get _selectedFilter => _tabs[_selectedTab].toLowerCase();

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProfileViewModelProvider);
    final progress = userState.weightProgress;
    final chartPoints = progress?.chartData ?? [];
    final chartSpots = _buildChartSpots(chartPoints);
    final labels = _buildChartLabels(chartPoints);
    final unit = _displayUnit(progress?.summary?.unit ?? progress?.unit);
    final summary = progress?.summary;
    final profile = userState.userProfile;
    final currentWeight =
        summary?.currentWeight ?? profile?.currentWeight ?? profile?.weight;
    final targetWeight = summary?.targetWeight ?? profile?.desiredWeight;
    final lastWeekWeight = summary?.lastWeekWeight;
    final showInitialLoading =
        userState.isWeightProgressLoading && progress == null;

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
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Weight Progress',
                  style: TextStyle(
                    color: AppColors.white,
                    fontFamily: AppFonts.lato,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  final logged = await Navigator.of(context).push<bool>(
                    MaterialPageRoute(
                      builder: (_) => LogWeightScreen(
                        initialWeight: currentWeight?.toDouble(),
                        initialUnit: unit,
                        refreshFilter: _selectedFilter,
                      ),
                    ),
                  );

                  if (logged == true && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Weight logged successfully'),
                      ),
                    );
                  }
                },
                icon: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.white,
                  size: 24,
                ),
                tooltip: 'Edit weight',
              ),
            ],
          ),
          const SizedBox(height: 22),
          _WeightRangeTabs(
            tabs: _tabs,
            selectedIndex: _selectedTab,
            onChanged: (index) {
              setState(() => _selectedTab = index);
              ref
                  .read(userProfileViewModelProvider.notifier)
                  .getWeightProgress(filter: _selectedFilter);
            },
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 220,
            child: showInitialLoading
                ? const _WeightChartShimmer()
                : chartSpots.isEmpty
                    ? const _WeightProgressEmptyState()
                    : _WeightLineChart(
                        spots: chartSpots,
                        labels: labels,
                      ),
          ),
          const SizedBox(height: 24),
          showInitialLoading
              ? const _WeightSummaryShimmerRow()
              : Row(
                  children: [
                    Expanded(
                      child: _WeightSummaryTile(
                        value: _formatWeight(lastWeekWeight, unit),
                        label: 'Last Week',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _WeightSummaryTile(
                        value: _formatWeight(currentWeight, unit),
                        label: 'Current Weight',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _WeightSummaryTile(
                        value: _formatWeight(targetWeight, unit),
                        label: 'Target Weight',
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  List<FlSpot> _buildChartSpots(List<ChartPoint> points) {
    final validPoints = points.where((point) => point.value != null).toList();
    return validPoints.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.value!.toDouble());
    }).toList();
  }

  List<String> _buildChartLabels(List<ChartPoint> points) {
    final validPoints = points.where((point) => point.value != null).toList();
    return validPoints.map((point) {
      if (point.label != null && point.label!.trim().isNotEmpty) {
        return point.label!;
      }
      if (point.date != null) {
        return DateFormat('d MMM').format(point.date!);
      }
      return '';
    }).toList();
  }

  String _displayUnit(String? unit) {
    if (unit == null || unit.trim().isEmpty) return 'Kg';
    return unit.toUpperCase() == 'KG' ? 'Kg' : 'Lb';
  }

  String _formatWeight(num? value, String unit) {
    if (value == null) return '-- $unit';
    final formatted =
        value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(1);
    return '$formatted $unit';
  }
}

class _WeightChartShimmer extends StatelessWidget {
  const _WeightChartShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color.fromRGBO(31, 36, 39, 1),
      highlightColor: const Color.fromRGBO(58, 63, 70, 1),
      child: Padding(
        padding: const EdgeInsets.only(left: 44, right: 10, bottom: 34),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            6,
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

class _WeightSummaryShimmerRow extends StatelessWidget {
  const _WeightSummaryShimmerRow();

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
                height: 76,
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

class _WeightRangeTabs extends StatelessWidget {
  const _WeightRangeTabs({
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: tabs.asMap().entries.map((entry) {
        final index = entry.key;
        final label = entry.value;
        final isSelected = index == selectedIndex;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index == tabs.length - 1 ? 0 : 8,
            ),
            child: GestureDetector(
              onTap: () => onChanged(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color:
                      isSelected ? AppColors.primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(36),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    maxLines: 1,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontFamily: AppFonts.lato,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _WeightLineChart extends StatelessWidget {
  const _WeightLineChart({
    required this.spots,
    required this.labels,
  });

  final List<FlSpot> spots;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const leftTitleWidth = 46.0;
        const rightPadding = 10.0;
        const bottomTitleHeight = 38.0;
        final lastSpot = spots.last;
        final minWeight =
            spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
        final maxWeight =
            spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
        final yPadding = ((maxWeight - minWeight) * 0.25).clamp(3.0, 10.0);
        final minY = (minWeight - yPadding).floorToDouble();
        final maxY = (maxWeight + yPadding).ceilToDouble();
        final yRange = maxY - minY == 0 ? 1.0 : maxY - minY;
        final maxX = spots.length > 1 ? (spots.length - 1).toDouble() : 1.0;
        final plotWidth = constraints.maxWidth - leftTitleWidth - rightPadding;
        final plotHeight = constraints.maxHeight - bottomTitleHeight;
        final valueLeft =
            leftTitleWidth + (plotWidth * (lastSpot.x / maxX)) - 14;
        final valueTop = ((maxY - lastSpot.y) / yRange * plotHeight) + 10;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: rightPadding),
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: maxX,
                  minY: minY,
                  maxY: maxY,
                  gridData: FlGridData(
                    drawVerticalLine: false,
                    horizontalInterval: (yRange / 5).clamp(1.0, 20.0),
                    getDrawingHorizontalLine: (_) => const FlLine(
                      color: Color.fromRGBO(100, 100, 100, 1),
                      strokeWidth: 1.4,
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
                        reservedSize: leftTitleWidth,
                        interval: (yRange / 5).clamp(1.0, 20.0),
                        getTitlesWidget: (value, meta) {
                          if (value < minY || value > maxY) {
                            return const SizedBox.shrink();
                          }
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              color: AppColors.textLightGrey,
                              fontFamily: AppFonts.lato,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: bottomTitleHeight,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= labels.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(
                              labels[index],
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
                  lineTouchData: const LineTouchData(enabled: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      curveSmoothness: 0.18,
                      color: const Color.fromRGBO(213, 214, 216, 1),
                      barWidth: 4,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(show: false),
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 6,
                            color: AppColors.primaryColor,
                            strokeWidth: 0,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: valueLeft,
              top: valueTop,
              child: Text(
                lastSpot.y.toInt().toString(),
                style: const TextStyle(
                  color: AppColors.white,
                  fontFamily: AppFonts.lato,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _WeightProgressEmptyState extends StatelessWidget {
  const _WeightProgressEmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No weight entries yet',
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

class _WeightSummaryTile extends StatelessWidget {
  const _WeightSummaryTile({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(43, 49, 58, 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              maxLines: 1,
              style: const TextStyle(
                color: AppColors.textLightGrey,
                fontFamily: AppFonts.lato,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
