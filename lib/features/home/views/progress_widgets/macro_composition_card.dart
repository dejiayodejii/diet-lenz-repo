part of '../progress.dart';

class MacroCompositionCard extends ConsumerStatefulWidget {
  const MacroCompositionCard({super.key});

  @override
  ConsumerState<MacroCompositionCard> createState() =>
      _MacroCompositionCardState();
}

class _MacroCompositionCardState extends ConsumerState<MacroCompositionCard> {
  static const _tabs = ['Daily', 'Weekly', 'Monthly'];
  static const _carbsColor = Color.fromRGBO(158, 158, 158, 1);
  static const _fatColor = Color.fromRGBO(246, 246, 246, 1);
  static const _proteinColor = AppColors.primaryColor;

  int _selectedTab = 0;

  String get _selectedFilter => _tabs[_selectedTab].toLowerCase();

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProfileViewModelProvider);
    if (userState.isMacroCompositionStale &&
        !userState.isMacroCompositionLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref.read(userProfileViewModelProvider.notifier).getMacroComposition(
              filter: _selectedFilter,
              refresh: true,
            );
      });
    }

    final composition = userState.macroComposition;
    final percentages = composition?.percentages;
    final macros = composition?.macros;
    final slices = [
      _MacroSlice(
        label: 'Carbs',
        percentage: percentages?.carbs ?? 0,
        grams: macros?.carbsGrams,
        color: _carbsColor,
        textColor: AppColors.white,
      ),
      _MacroSlice(
        label: 'Fat',
        percentage: percentages?.fat ?? 0,
        grams: macros?.fatGrams,
        color: _fatColor,
        textColor: Colors.black,
      ),
      _MacroSlice(
        label: 'Protein',
        percentage: percentages?.protein ?? 0,
        grams: macros?.proteinGrams,
        color: _proteinColor,
        textColor: AppColors.white,
      ),
    ];
    final hasMacroData = slices.any((slice) => slice.percentage > 0);
    final showInitialLoading =
        userState.isMacroCompositionLoading && composition == null;

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
            'Macro Composition',
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
            selectedIndex: _selectedTab,
            onChanged: (index) {
              setState(() => _selectedTab = index);
              ref
                  .read(userProfileViewModelProvider.notifier)
                  .getMacroComposition(filter: _selectedFilter);
            },
          ),
          const SizedBox(height: 28),
          SizedBox(
            height: 250,
            child: showInitialLoading
                ? const _MacroCompositionShimmer()
                : hasMacroData
                    ? _MacroPieChart(slices: slices)
                    : const _MacroCompositionEmptyState(),
          ),
          const SizedBox(height: 18),
          showInitialLoading
              ? const _MacroLegendShimmer()
              : _MacroLegend(slices: slices),
        ],
      ),
    );
  }
}

class _MacroSlice {
  const _MacroSlice({
    required this.label,
    required this.percentage,
    required this.grams,
    required this.color,
    required this.textColor,
  });

  final String label;
  final int percentage;
  final double? grams;
  final Color color;
  final Color textColor;

  _MacroSlice copyWith({int? percentage}) {
    return _MacroSlice(
      label: label,
      percentage: percentage ?? this.percentage,
      grams: grams,
      color: color,
      textColor: textColor,
    );
  }
}

class _MacroPieChart extends StatelessWidget {
  const _MacroPieChart({required this.slices});

  final List<_MacroSlice> slices;

  @override
  Widget build(BuildContext context) {
    final normalizedSlices = _normalizedSlices();

    return PieChart(
      PieChartData(
        sectionsSpace: 0,
        centerSpaceRadius: 0,
        startDegreeOffset: -90,
        pieTouchData: PieTouchData(enabled: false),
        sections: normalizedSlices
            .map(
              (slice) => PieChartSectionData(
                value: slice.percentage.toDouble(),
                title: '${slice.percentage}%',
                radius: 116,
                color: slice.color,
                titleStyle: TextStyle(
                  color: slice.textColor,
                  fontFamily: AppFonts.lato,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  List<_MacroSlice> _normalizedSlices() {
    final activeSlices = slices.where((slice) => slice.percentage > 0).toList();
    final total = activeSlices.fold<int>(
      0,
      (sum, slice) => sum + slice.percentage,
    );

    if (total <= 0) return const [];
    if (total == 100) return activeSlices;

    final normalizedValues = activeSlices.map((slice) {
      return slice.percentage * 100 / total;
    }).toList();
    final roundedValues =
        normalizedValues.map((value) => value.floor()).toList();
    var remaining =
        100 - roundedValues.fold<int>(0, (sum, value) => sum + value);

    final indexesByRemainder = List<int>.generate(activeSlices.length, (index) {
      return index;
    })
      ..sort((a, b) {
        final bRemainder = normalizedValues[b] - normalizedValues[b].floor();
        final aRemainder = normalizedValues[a] - normalizedValues[a].floor();
        return bRemainder.compareTo(aRemainder);
      });

    var cursor = 0;
    while (remaining > 0 && indexesByRemainder.isNotEmpty) {
      roundedValues[indexesByRemainder[cursor % indexesByRemainder.length]]++;
      remaining--;
      cursor++;
    }

    return List<_MacroSlice>.generate(activeSlices.length, (index) {
      return activeSlices[index].copyWith(percentage: roundedValues[index]);
    });
  }
}

class _MacroLegend extends StatelessWidget {
  const _MacroLegend({required this.slices});

  final List<_MacroSlice> slices;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: slices.map((slice) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 14,
                  height: 32,
                  decoration: BoxDecoration(
                    color: slice.color,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                const SizedBox(width: 7),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        slice.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontFamily: AppFonts.lato,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${_formatGrams(slice.grams)}g',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontFamily: AppFonts.lato,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  static String _formatGrams(double? value) {
    if (value == null) return '--';
    return value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(1);
  }
}

class _MacroCompositionShimmer extends StatelessWidget {
  const _MacroCompositionShimmer();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Shimmer.fromColors(
        baseColor: const Color.fromRGBO(31, 36, 39, 1),
        highlightColor: const Color.fromRGBO(58, 63, 70, 1),
        child: Container(
          width: 220,
          height: 220,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _MacroLegendShimmer extends StatelessWidget {
  const _MacroLegendShimmer();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        3,
        (index) => Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Shimmer.fromColors(
              baseColor: const Color.fromRGBO(31, 36, 39, 1),
              highlightColor: const Color.fromRGBO(58, 63, 70, 1),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MacroCompositionEmptyState extends StatelessWidget {
  const _MacroCompositionEmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No macro data yet',
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
