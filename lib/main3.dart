import 'package:flutter/material.dart';

class VerticalPickerScreen extends StatefulWidget {
  const VerticalPickerScreen({super.key});

  @override
  State<VerticalPickerScreen> createState() => _VerticalPickerScreenState();
}

class _VerticalPickerScreenState extends State<VerticalPickerScreen> {
  int selectedValue = 18;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Age Picker'),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select your age',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 40),
            VerticalNumberPicker(
              minValue: 0,
              maxValue: 100,
              initialValue: selectedValue,
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

class VerticalNumberPicker extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final int initialValue;
  final ValueChanged<int> onValueChanged;
  final double height;
  final double itemHeight;

  const VerticalNumberPicker({
    super.key,
    required this.minValue,
    required this.maxValue,
    required this.initialValue,
    required this.onValueChanged,
    this.height = 400,
    this.itemHeight = 80,
  });

  @override
  State<VerticalNumberPicker> createState() => _VerticalNumberPickerState();
}

class _VerticalNumberPickerState extends State<VerticalNumberPicker> {
  late ScrollController _scrollController;
  late int _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
    final initialOffset =
        (widget.initialValue - widget.minValue) * widget.itemHeight;
    _scrollController = ScrollController(initialScrollOffset: initialOffset);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    final index = (offset / widget.itemHeight).round();
    final value =
        (widget.minValue + index).clamp(widget.minValue, widget.maxValue);

    if (value != _currentValue) {
      setState(() {
        _currentValue = value;
      });
      widget.onValueChanged(value);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalItems = widget.maxValue - widget.minValue + 1;

    return SizedBox(
      height: widget.height,
      width: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Selection indicator (orange rounded rectangle)
          IgnorePointer(
            child: Container(
              height: widget.itemHeight,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepOrange.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
          // Scrollable numbers
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollEndNotification) {
                // Snap to nearest value
                final offset = _scrollController.offset;
                final nearestIndex = (offset / widget.itemHeight).round();
                final nearestOffset = nearestIndex * widget.itemHeight;

                _scrollController.animateTo(
                  nearestOffset,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                );
              }
              return true;
            },
            child: ListView.builder(
              controller: _scrollController,
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                vertical: (widget.height - widget.itemHeight) / 2,
              ),
              itemCount: totalItems,
              itemBuilder: (context, index) {
                final value = widget.minValue + index;
                return _buildNumberItem(value);
              },
            ),
          ),
          // Overlay selected and neighboring numbers centered on the indicator
          IgnorePointer(
            child: SizedBox(
              height: widget.height,
              width: 280,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Selected value - largest and boldest, always centered
                  Text(
                    _currentValue.toString(),
                    style: const TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.0,
                    ),
                  ),
                  // Immediate neighbors (above and below) - smaller
                  if (_currentValue - 1 >= widget.minValue)
                    Transform.translate(
                      offset: const Offset(0, -80),
                      child: Opacity(
                        opacity: 0.85,
                        child: Text(
                          (_currentValue - 1).toString(),
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                  if (_currentValue + 1 <= widget.maxValue)
                    Transform.translate(
                      offset: const Offset(0, 80),
                      child: Opacity(
                        opacity: 0.85,
                        child: Text(
                          (_currentValue + 1).toString(),
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                  // Next layer (above and below) - even smaller
                  if (_currentValue - 2 >= widget.minValue)
                    Transform.translate(
                      offset: const Offset(0, -160),
                      child: Opacity(
                        opacity: 0.65,
                        child: Text(
                          (_currentValue - 2).toString(),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                  if (_currentValue + 2 <= widget.maxValue)
                    Transform.translate(
                      offset: const Offset(0, 160),
                      child: Opacity(
                        opacity: 0.65,
                        child: Text(
                          (_currentValue + 2).toString(),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberItem(int value) {
    return SizedBox(
      height: widget.itemHeight,
      child: AnimatedBuilder(
        animation: _scrollController,
        builder: (context, child) {
          if (_scrollController.hasClients) {
            final offset = _scrollController.offset;
            final itemOffset = (value - widget.minValue) * widget.itemHeight;
            final center = offset + (widget.height - widget.itemHeight) / 2;
            final distance = (itemOffset - center).abs();

            // Hide the list's center item to avoid overlap with overlay selected number
            if (distance < widget.itemHeight / 2) {
              return const SizedBox.shrink();
            }
          }

          // Subtle baseline appearance for list items
          return Center(
            child: Opacity(
              opacity: 0.0,
              child: Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                  height: 1.0,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
