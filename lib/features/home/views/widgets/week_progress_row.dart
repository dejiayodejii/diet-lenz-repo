import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/main4.dart';
import 'package:flutter/material.dart';

class DayProgress {
  final String day;
  final int date;
  final DateTime fullDate;
  final double progress;
  final bool isToday;

  DayProgress({
    required this.day,
    required this.date,
    required this.fullDate,
    required this.progress,
    required this.isToday,
  });
}

class WeekProgressRow extends StatefulWidget {
  final List<DayProgress> weekDays;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDaySelected;

  const WeekProgressRow({
    super.key,
    required this.weekDays,
    required this.selectedDate,
    required this.onDaySelected,
  });

  @override
  State<WeekProgressRow> createState() => _WeekProgressRowState();
}

class _WeekProgressRowState extends State<WeekProgressRow> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.weekDays.asMap().entries.map((entry) {
          final index = entry.key;
          final dayData = entry.value;
          final isSelected =
              dayData.fullDate.year == widget.selectedDate.year &&
                  dayData.fullDate.month == widget.selectedDate.month &&
                  dayData.fullDate.day == widget.selectedDate.day;
          return Padding(
            padding: EdgeInsets.only(
              right: index < widget.weekDays.length - 1 ? 10 : 0,
            ),
            child: GestureDetector(
              onTap: () => widget.onDaySelected(dayData.fullDate),
              child: BorderProgressContainer(
                progress: dayData.progress,
                width: 57,
                height: 88,
                borderWidth: 2,
                progressColor: AppColors.primaryColor,
                backgroundColor: AppColors.borderGrey,
                borderRadius: 11,
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dayData.day,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color:
                                isSelected ? Colors.white : AppColors.textColor,
                          ),
                        ),
                        Text(
                          '${dayData.date}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color:
                                isSelected ? Colors.white : AppColors.textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
