import 'package:diet_lenz/main3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ruler Picker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const VerticalPickerScreen(),
    );
  }
}

class RulerPickerScreen extends StatefulWidget {
  const RulerPickerScreen({super.key});

  @override
  State<RulerPickerScreen> createState() => _RulerPickerScreenState();
}

class _RulerPickerScreenState extends State<RulerPickerScreen> {
  double selectedValue = 50.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Ruler Picker'),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              // Show integer value (no decimals)
              selectedValue.round().toString(),
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 60),
            RulerPicker(
              minValue: 0,
              maxValue: 100,
              initialValue: selectedValue,
              // step: how much the value changes per tick (e.g., 1),
              // set to 1 to ensure integer increments.
              step: 1,
              // majorTickInterval controls how often a large tick appears (in value units)
              majorTickInterval: 10,
              onValueChanged: (value) {
                setState(() {
                  selectedValue = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class RulerPicker extends StatefulWidget {
  final double minValue;
  final double maxValue;
  final double initialValue;
  final ValueChanged<double> onValueChanged;
  final double height;
  final double step;
  final double majorTickInterval;
  final double tickSpacing;

  const RulerPicker({
    super.key,
    required this.minValue,
    required this.maxValue,
    required this.initialValue,
    required this.onValueChanged,
    this.height = 120,
    this.step = 1.0,
    this.majorTickInterval = 10.0,
    this.tickSpacing = 10.0,
  });

  @override
  State<RulerPicker> createState() => _RulerPickerState();
}

class _RulerPickerState extends State<RulerPicker> {
  late ScrollController _scrollController;
  final double _itemWidth = 10.0;

  @override
  void initState() {
    super.initState();
    // Compute initial offset in pixels based on steps: number of steps from min
    final initialStepIndex =
        ((widget.initialValue - widget.minValue) / widget.step).round();
    final initialOffset = initialStepIndex * _itemWidth;
    _scrollController = ScrollController(initialScrollOffset: initialOffset);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    // Number of steps moved from min (may be fractional during scrolling)
    final steps = offset / _itemWidth;
    final value = widget.minValue + steps * widget.step;
    final clampedValue = value.clamp(widget.minValue, widget.maxValue);
    // Report integer value (rounded) if step is integer; otherwise report nearest step value
    final reported =
        (widget.step >= 1.0) ? clampedValue.roundToDouble() : clampedValue;
    widget.onValueChanged(reported);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalItems =
        ((widget.maxValue - widget.minValue) / widget.step).toInt();
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: widget.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Scrollable ruler
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollEndNotification) {
                // Snap to nearest value
                final offset = _scrollController.offset;
                final nearestStepIndex = (offset / _itemWidth).round();
                final nearestOffset = nearestStepIndex * _itemWidth;
                _scrollController.animateTo(
                  nearestOffset,
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOut,
                );
              }
              return true;
            },
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: screenWidth / 2),
              itemCount: totalItems + 1,
              itemBuilder: (context, index) {
                // Determine ticks based on step and majorTickInterval
                final stepsPerMajor = (widget.majorTickInterval / widget.step)
                    .round()
                    .clamp(1, 1000000);
                final isLargeTick = index % stepsPerMajor == 0;
                final isMediumTick = (stepsPerMajor % 2 == 0)
                    ? index % (stepsPerMajor ~/ 2) == 0
                    : false;

                // Value at this index (not used for labels here but useful)
                final valueAtIndex = widget.minValue + index * widget.step;

                return SizedBox(
                  width: _itemWidth,
                  // Center the tick vertically so longer ticks extend both
                  // above and below the midline, not just downward.
                  child: Center(
                    child: Container(
                      width: 2,
                      height: isLargeTick
                          ? 60
                          : isMediumTick
                              ? 45
                              : 30,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(57, 60, 67, 1),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Center indicator
          SvgPicture.asset(
            "assets/images/indicator.svg",
            color: Colors.white,
          ),
          // Rounded indicator at top
          // IgnorePointer(
          //   child: Positioned(
          //     top: 0,
          //     child: Container(
          //       width: 24,
          //       height: 50,
          //       decoration: BoxDecoration(
          //         color: Colors.transparent,
          //         border: Border.all(color: Colors.blue, width: 3),
          //         borderRadius: BorderRadius.circular(12),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
