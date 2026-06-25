import 'package:diet_lenz/component/snapping_calendar_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const WeddingDatePickerScreen(),
    );
  }
}

const _kOrange = Color(0xFFE8622A);
const _kBackground = Color(0xFF1A1A1A);

class WeddingDatePickerScreen extends StatefulWidget {
  const WeddingDatePickerScreen({super.key});

  @override
  State<WeddingDatePickerScreen> createState() =>
      _WeddingDatePickerScreenState();
}

class _WeddingDatePickerScreenState extends State<WeddingDatePickerScreen> {
  DateTime _selectedDate = DateTime(2026, 8, 4);

  void _onContinue() {
    final d = _selectedDate;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _kOrange,
        content: Text(
          'Wedding date set: ${SnappingCalendarPicker.monthNames[d.month - 1]} ${d.day}, ${d.year}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  _BackButton(),
                  const SizedBox(width: 16),
                  const _ProgressBar(progress: 7 / 14),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'When is your\nwedding?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SnappingCalendarPicker(
                initialDate: _selectedDate,
                startYear: 2024,
                yearCount: 10,
                onDateChanged: (date) => _selectedDate = date,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _ContinueButton(onTap: _onContinue),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.maybePop(context),
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: Color(0xFF2C2C2C),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.chevron_left, color: Colors.white, size: 22),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progress});
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          const dotSize = 8.0;
          const dotCount = 14;
          const spacing = 4.0;
          final filled = (dotCount * progress).round();
          return Row(
            children: List.generate(dotCount, (i) {
              return Container(
                margin: const EdgeInsets.only(right: spacing),
                width: dotSize,
                height: dotSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i < filled ? _kOrange : const Color(0xFF3A3A3A),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: _kOrange,
          borderRadius: BorderRadius.circular(28),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Continue',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}
