import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;

/// ─────────────────────────────────────────────
///  ENTRY POINT  (remove when dropping into app)
/// ─────────────────────────────────────────────
void main() => runApp(const _PreviewApp());

class _PreviewApp extends StatelessWidget {
  const _PreviewApp();
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Roboto'),
        home: const TargetWeightScreen(),
      );
}

// ─── Design tokens ────────────────────────────
const _bg = Color(0xFF1A1A1A);
const _surface = Color(0xFF2A2A2A);
const _orange = Color(0xFFFF6B00);
const _orangeDim = Color(0xFF3D2200);
const _textPrimary = Colors.white;
const _textSecondary = Color(0xFF9E9E9E);
const _pill = Color(0xFF2E2E2E);

// ─── BMI gradient stops ───────────────────────
const _bmiColors = [
  Color(0xFF3B82F6), // underweight
  Color(0xFF22C55E), // normal-low
  Color(0xFF86EFAC), // normal
  Color(0xFFFFD700), // overweight-edge
  Color(0xFFF97316), // overweight
  Color(0xFFEF4444), // obese
];

/// ─────────────────────────────────────────────
///  MAIN SCREEN
/// ─────────────────────────────────────────────
class TargetWeightScreen extends StatefulWidget {
  const TargetWeightScreen({super.key});

  @override
  State<TargetWeightScreen> createState() => _TargetWeightScreenState();
}

class _TargetWeightScreenState extends State<TargetWeightScreen> {
  bool _isKg = true;
  double _weightKg = 100;

  // Ruler range in kg
  static const double _minKg = 30;
  static const double _maxKg = 200;

  double get _displayWeight =>
      _isKg ? _weightKg : _weightKg * 2.20462;

  String get _unit => _isKg ? 'kg' : 'lbs';

  // Simple BMI assuming height = 1.72 m (placeholder)
  double get _bmi => _weightKg / (1.72 * 1.72);

  String get _bmiCategory {
    if (_bmi < 18.5) return 'Underweight';
    if (_bmi < 25) return 'Healthy Range';
    if (_bmi < 30) return 'Overweight';
    return 'Obese';
  }

  // 0..1 position along the BMI bar
  double get _bmiProgress {
    const min = 15.0, max = 40.0;
    return ((_bmi - min) / (max - min)).clamp(0.0, 1.0);
  }

  void _onWeightChanged(double kg) =>
      setState(() => _weightKg = kg.clamp(_minKg, _maxKg));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Progress bar ──────────────────
            const _StepProgressBar(totalSteps: 8, currentStep: 3),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 32),

                    // ── Title ─────────────────
                    const Text(
                      'What is your\ntarget weight?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── kg / lbs toggle ───────
                    _UnitToggle(
                      isKg: _isKg,
                      onChanged: (v) => setState(() => _isKg = v),
                    ),

                    const SizedBox(height: 36),

                    // ── Big weight number ──────
                    _WeightDisplay(
                      weight: _displayWeight,
                      unit: _unit,
                    ),

                    const SizedBox(height: 24),

                    // ── Ruler picker ──────────
                    _RulerPicker(
                      valueKg: _weightKg,
                      minKg: _minKg,
                      maxKg: _maxKg,
                      isKg: _isKg,
                      onChanged: _onWeightChanged,
                    ),

                    const SizedBox(height: 32),

                    // ── BMI bar ───────────────
                    _BmiBar(
                      bmi: _bmi,
                      progress: _bmiProgress,
                      category: _bmiCategory,
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // ── Continue button ───────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: _ContinueButton(
                onTap: () {
                  // TODO: navigate to next screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: _orange,
                      content: Text(
                        'Target: ${_displayWeight.toStringAsFixed(1)} $_unit',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ─────────────────────────────────────────────
///  STEP PROGRESS BAR
/// ─────────────────────────────────────────────
class _StepProgressBar extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  const _StepProgressBar(
      {required this.totalSteps, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Row(
        children: List.generate(totalSteps, (i) {
          final filled = i < currentStep;
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: i < totalSteps - 1 ? 4 : 0),
              height: 4,
              decoration: BoxDecoration(
                color: filled ? _orange : _surface,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// ─────────────────────────────────────────────
///  KG / LBS TOGGLE
/// ─────────────────────────────────────────────
class _UnitToggle extends StatelessWidget {
  final bool isKg;
  final ValueChanged<bool> onChanged;

  const _UnitToggle({required this.isKg, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: _pill,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToggleOption(label: 'kg', selected: isKg, onTap: () => onChanged(true)),
          _ToggleOption(label: 'lbs', selected: !isKg, onTap: () => onChanged(false)),
        ],
      ),
    );
  }
}

class _ToggleOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleOption(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 90,
        height: 44,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: selected ? _orange : Colors.transparent,
          borderRadius: BorderRadius.circular(28),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : _textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

/// ─────────────────────────────────────────────
///  LARGE WEIGHT DISPLAY
/// ─────────────────────────────────────────────
class _WeightDisplay extends StatelessWidget {
  final double weight;
  final String unit;

  const _WeightDisplay({required this.weight, required this.unit});

  @override
  Widget build(BuildContext context) {
    final whole = weight.floor();
    final frac = ((weight - whole) * 10).round();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '$whole',
          style: const TextStyle(
            color: _textPrimary,
            fontSize: 80,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),
        if (unit == 'lbs') ...[
          Text(
            '.$frac',
            style: const TextStyle(
              color: _textSecondary,
              fontSize: 44,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
        ],
        const SizedBox(width: 6),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            unit,
            style: const TextStyle(
              color: _textSecondary,
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

/// ─────────────────────────────────────────────
///  RULER PICKER
///
///  Think of this like a physical measuring tape
///  lying flat — you slide it left/right and the
///  centre notch (the white bar) is your reading.
/// ─────────────────────────────────────────────
class _RulerPicker extends StatefulWidget {
  final double valueKg;
  final double minKg;
  final double maxKg;
  final bool isKg;
  final ValueChanged<double> onChanged;

  const _RulerPicker({
    required this.valueKg,
    required this.minKg,
    required this.maxKg,
    required this.isKg,
    required this.onChanged,
  });

  @override
  State<_RulerPicker> createState() => _RulerPickerState();
}

class _RulerPickerState extends State<_RulerPicker> {
  late ScrollController _sc;
  static const double _pxPerUnit = 14.0; // pixels per kg (or lb)
  bool _scrolling = false;

  double get _convFactor => widget.isKg ? 1.0 : 2.20462;
  double get _minDisplay => widget.minKg * _convFactor;
  double get _maxDisplay => widget.maxKg * _convFactor;

  @override
  void initState() {
    super.initState();
    _sc = ScrollController(
      initialScrollOffset: _offsetForKg(widget.valueKg),
    );
    _sc.addListener(_onScroll);
  }

  double _offsetForKg(double kg) =>
      (kg * _convFactor - _minDisplay) * _pxPerUnit;

  double _kgForOffset(double offset) =>
      (offset / _pxPerUnit + _minDisplay) / _convFactor;

  void _onScroll() {
    if (_scrolling) return;
    final kg = _kgForOffset(_sc.offset);
    widget.onChanged(kg);
  }

  @override
  void didUpdateWidget(_RulerPicker old) {
    super.didUpdateWidget(old);
    // Sync scroll position when unit toggles
    if (old.isKg != widget.isKg) {
      _scrolling = true;
      _sc.jumpTo(_offsetForKg(widget.valueKg));
      _scrolling = false;
    }
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalUnits = (_maxDisplay - _minDisplay).round();
    final displayVal = widget.isKg
        ? widget.valueKg.round().toString()
        : (widget.valueKg * 2.20462).round().toString();

    return SizedBox(
      height: 90,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Scrollable ruler
          NotificationListener<ScrollNotification>(
            onNotification: (n) {
              if (n is ScrollEndNotification) {
                // snap to nearest integer
                final kg = _kgForOffset(_sc.offset);
                final snapped =
                    widget.isKg ? kg.roundToDouble() : (kg * 2.20462).round() / 2.20462;
                _sc.animateTo(
                  _offsetForKg(snapped),
                  duration: const Duration(milliseconds: 120),
                  curve: Curves.easeOut,
                );
              }
              return false;
            },
            child: ListView.builder(
              controller: _sc,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              // padding so the first/last tick can reach centre
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 2),
              itemCount: totalUnits + 1,
              itemBuilder: (_, i) => _RulerTick(
                index: i,
                value: (_minDisplay + i).round(),
                isKg: widget.isKg,
              ),
            ),
          ),

          // Centre indicator
          Container(
            width: 3,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Labels below ruler
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(_minDisplay + (widget.valueKg * _convFactor) - 2).round()}',
                  style:
                      const TextStyle(color: _textSecondary, fontSize: 12),
                ),
                Text(
                  '${(_minDisplay + (widget.valueKg * _convFactor) + 2).round()}',
                  style:
                      const TextStyle(color: _textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RulerTick extends StatelessWidget {
  final int index;
  final int value;
  final bool isKg;

  const _RulerTick(
      {required this.index, required this.value, required this.isKg});

  @override
  Widget build(BuildContext context) {
    final isMajor = value % 5 == 0;
    final isLabelled = value % 10 == 0;

    return SizedBox(
      width: 14,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: isMajor ? 2 : 1,
            height: isMajor ? 32 : 18,
            color: isMajor
                ? _textSecondary.withOpacity(0.7)
                : _textSecondary.withOpacity(0.3),
          ),
          if (isLabelled) ...[
            const SizedBox(height: 4),
            Text(
              '$value',
              style: const TextStyle(color: _textSecondary, fontSize: 10),
            ),
          ],
        ],
      ),
    );
  }
}

/// ─────────────────────────────────────────────
///  BMI BAR
/// ─────────────────────────────────────────────
class _BmiBar extends StatelessWidget {
  final double bmi;
  final double progress; // 0..1
  final String category;

  const _BmiBar(
      {required this.bmi,
      required this.progress,
      required this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Marker label above bar
        LayoutBuilder(builder: (ctx, constraints) {
          final markerX = progress * constraints.maxWidth;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              // gradient bar
              Container(
                height: 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: const LinearGradient(colors: _bmiColors),
                ),
              ),
              // Normal pill
              Positioned(
                top: -22,
                left: (markerX - 28).clamp(0, constraints.maxWidth - 56),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    category == 'Healthy Range' ? 'Normal' : category,
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _bg),
                  ),
                ),
              ),
              // marker triangle
              Positioned(
                top: 10,
                left: (markerX - 5).clamp(0, constraints.maxWidth - 10),
                child: CustomPaint(
                  size: const Size(10, 6),
                  painter: _TrianglePainter(),
                ),
              ),
            ],
          );
        }),
        const SizedBox(height: 12),
        Text(
          'Target BMI: ${bmi.toStringAsFixed(1)} · $category',
          style: const TextStyle(color: _textSecondary, fontSize: 12),
        ),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

/// ─────────────────────────────────────────────
///  CONTINUE BUTTON
/// ─────────────────────────────────────────────
class _ContinueButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ContinueButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: _orange,
          borderRadius: BorderRadius.circular(30),
        ),
        alignment: Alignment.center,
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Continue',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 10),
            Icon(Icons.arrow_forward, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}