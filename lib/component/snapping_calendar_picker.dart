import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

const _kOrange = Color(0xFFE8622A);
const _kSurface = AppColors.backgroundColor;
const _kSelectedBg = Color(0xFF393C43);
const _kMidText = Color(0xFF9E9E9E);

const _kItemHeight = 60.0;
const _kVisibleItems = 5;
const _kHeaderHeight = 14.0;
const _kPanelOverflowBuffer = 4.0;

class SnappingCalendarPicker extends StatefulWidget {
  const SnappingCalendarPicker({
    super.key,
    this.initialDate,
    this.startYear = 2024,
    this.yearCount = 10,
    this.onDateChanged,
    this.showSelectedDate = true,
  }) : assert(yearCount > 0, 'yearCount must be greater than 0');

  final DateTime? initialDate;
  final int startYear;
  final int yearCount;
  final ValueChanged<DateTime>? onDateChanged;
  final bool showSelectedDate;

  static const monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  State<SnappingCalendarPicker> createState() => _SnappingCalendarPickerState();
}

class _SnappingCalendarPickerState extends State<SnappingCalendarPicker> {
  late int _monthIndex;
  late int _dayIndex;
  late int _yearIndex;

  int get _endYear => widget.startYear + widget.yearCount - 1;

  int get _daysInSelectedMonth {
    final month = _monthIndex + 1;
    final year = widget.startYear + _yearIndex;
    return DateUtils.getDaysInMonth(year, month);
  }

  List<String> get _days =>
      List.generate(_daysInSelectedMonth, (i) => '${i + 1}');

  List<String> get _years =>
      List.generate(widget.yearCount, (i) => '${widget.startYear + i}');

  DateTime get selectedDate {
    final year = widget.startYear + _yearIndex;
    final month = _monthIndex + 1;
    final day = (_dayIndex + 1).clamp(1, _daysInSelectedMonth);
    return DateTime(year, month, day);
  }

  @override
  void initState() {
    super.initState();
    _setIndicesFromDate(widget.initialDate ?? DateTime(widget.startYear));
  }

  @override
  void didUpdateWidget(SnappingCalendarPicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.startYear != widget.startYear ||
        oldWidget.yearCount != widget.yearCount ||
        oldWidget.initialDate != widget.initialDate) {
      _setIndicesFromDate(widget.initialDate ?? selectedDate);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onDateChanged?.call(selectedDate);
      });
    }
  }

  DateTime _clampDateToRange(DateTime date) {
    final year = date.year.clamp(widget.startYear, _endYear);
    final month = date.month.clamp(1, 12);
    final day = date.day.clamp(1, DateUtils.getDaysInMonth(year, month));
    return DateTime(year, month, day);
  }

  void _setIndicesFromDate(DateTime date) {
    final clampedDate = _clampDateToRange(date);
    _monthIndex = clampedDate.month - 1;
    _dayIndex = clampedDate.day - 1;
    _yearIndex = clampedDate.year - widget.startYear;
  }

  void _notifyDateChanged() {
    widget.onDateChanged?.call(selectedDate);
  }

  void _setMonth(int index) {
    setState(() {
      _monthIndex = index;
      _dayIndex = _dayIndex.clamp(0, _daysInSelectedMonth - 1);
    });
    _notifyDateChanged();
  }

  void _setDay(int index) {
    setState(() => _dayIndex = index);
    _notifyDateChanged();
  }

  void _setYear(int index) {
    setState(() {
      _yearIndex = index;
      _dayIndex = _dayIndex.clamp(0, _daysInSelectedMonth - 1);
    });
    _notifyDateChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _DatePickerPanel(
          child: _DrumRollPicker(
            columns: [
              _PickerColumn(
                items: SnappingCalendarPicker.monthNames,
                selectedIndex: _monthIndex,
                onChanged: _setMonth,
                flex: 5,
                alignment: TextAlign.left,
              ),
              _PickerColumn(
                items: _days,
                selectedIndex: _dayIndex,
                onChanged: _setDay,
                flex: 2,
                alignment: TextAlign.center,
              ),
              _PickerColumn(
                items: _years,
                selectedIndex: _yearIndex,
                onChanged: _setYear,
                flex: 3,
                alignment: TextAlign.right,
              ),
            ],
          ),
        ),
        if (widget.showSelectedDate) ...[
          const SizedBox(height: 18),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: Text(
              '${SnappingCalendarPicker.monthNames[selectedDate.month - 1]} ${selectedDate.day}, ${selectedDate.year}',
              key: ValueKey(selectedDate),
              style: const TextStyle(
                color: _kOrange,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _DatePickerPanel extends StatelessWidget {
  const _DatePickerPanel({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (_kItemHeight * _kVisibleItems) +
          _kHeaderHeight +
          42 +
          _kPanelOverflowBuffer,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(
            height: _kHeaderHeight,
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: _PickerHeaderText('Month', TextAlign.left),
                ),
                Expanded(
                  flex: 2,
                  child: _PickerHeaderText('Day', TextAlign.center),
                ),
                Expanded(
                  flex: 3,
                  child: _PickerHeaderText('Year', TextAlign.right),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: _kItemHeight * _kVisibleItems,
            child: child,
          ),
        ],
      ),
    );
  }
}

class _PickerHeaderText extends StatelessWidget {
  const _PickerHeaderText(this.label, this.alignment);
  final String label;
  final TextAlign alignment;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      textAlign: alignment,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.42),
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.1,
      ),
    );
  }
}

class _PickerColumn {
  const _PickerColumn({
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
    required this.flex,
    required this.alignment,
  });

  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final int flex;
  final TextAlign alignment;
}

class _DrumRollPicker extends StatelessWidget {
  const _DrumRollPicker({required this.columns});
  final List<_PickerColumn> columns;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _kSurface,
                    _kSurface.withValues(alpha: 0),
                    _kSurface.withValues(alpha: 0),
                    _kSurface,
                  ],
                  stops: const [0, 0.28, 0.72, 1],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 2,
          right: 2,
          top: (_kVisibleItems ~/ 2) * _kItemHeight,
          height: _kItemHeight,
          child: Container(
            decoration: BoxDecoration(
              color: _kSelectedBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: _kOrange.withValues(alpha: 0.8),
                width: 1.4,
              ),
              boxShadow: [
                BoxShadow(
                  color: _kOrange.withValues(alpha: 0.12),
                  blurRadius: 18,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: columns
                .map(
                  (col) => Expanded(
                    flex: col.flex,
                    child: _ScrollColumn(column: col),
                  ),
                )
                .toList(),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          height: _kItemHeight * 1.4,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _kSurface,
                    _kSurface.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: _kItemHeight * 1.4,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    _kSurface,
                    _kSurface.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ScrollColumn extends StatefulWidget {
  const _ScrollColumn({required this.column});
  final _PickerColumn column;

  @override
  State<_ScrollColumn> createState() => _ScrollColumnState();
}

class _ScrollColumnState extends State<_ScrollColumn> {
  late FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(
      initialItem: widget.column.selectedIndex,
    );
  }

  @override
  void didUpdateWidget(_ScrollColumn old) {
    super.didUpdateWidget(old);

    final newCol = widget.column;
    if (old.column.items != newCol.items ||
        old.column.selectedIndex != newCol.selectedIndex) {
      final clamped = newCol.selectedIndex.clamp(0, newCol.items.length - 1);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_controller.hasClients) return;

        if (_controller.selectedItem == clamped) return;

        if (old.column.items.length != newCol.items.length) {
          _controller.jumpToItem(clamped);
        } else {
          _controller.animateToItem(
            clamped,
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final col = widget.column;

    return ListWheelScrollView.useDelegate(
      controller: _controller,
      itemExtent: _kItemHeight,
      diameterRatio: 3.2,
      magnification: 1.04,
      overAndUnderCenterOpacity: 0.55,
      perspective: 0.002,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: col.onChanged,
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: col.items.length,
        builder: (context, index) {
          final isSelected = index == col.selectedIndex;
          return _PickerItem(
            label: col.items[index],
            isSelected: isSelected,
            alignment: col.alignment,
          );
        },
      ),
    );
  }
}

class _PickerItem extends StatelessWidget {
  const _PickerItem({
    required this.label,
    required this.isSelected,
    required this.alignment,
  });

  final String label;
  final bool isSelected;
  final TextAlign alignment;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      height: _kItemHeight,
      alignment: _textAlignToAlignment(alignment),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        label,
        textAlign: alignment,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: isSelected ? Colors.white : _kMidText,
          fontSize: isSelected ? 21 : 17,
          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
          letterSpacing: isSelected ? -0.2 : 0,
        ),
      ),
    );
  }

  Alignment _textAlignToAlignment(TextAlign ta) {
    switch (ta) {
      case TextAlign.left:
        return Alignment.centerLeft;
      case TextAlign.right:
        return Alignment.centerRight;
      default:
        return Alignment.center;
    }
  }
}
