import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/component/personalization_stepper.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/core/constants/app_colors.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/controller/onboarding_profile_provider.dart';
import 'package:diet_lenz/features/auth/view/personization/realistic_target.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

// ─── Design tokens (shared with Screen 1) ─────
const _surface = Color(0xFF2A2A2A);
const _orange = Color(0xFFFF6B00);
const _textPrimary = Colors.white;
const _textSecondary = Color(0xFF9E9E9E);

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
        home: const ProviderScope(
          child: GoalPaceScreen(targetWeightKg: 80),
        ),
      );
}

/// ─────────────────────────────────────────────
///  DATA MODEL
///
///  Think of a PaceOption like a car's drive mode
///  (Eco / Normal / Sport). Each mode maps to a
///  fixed caloric deficit and weekly loss rate.
/// ─────────────────────────────────────────────
class PaceOption {
  final String label; // "Slow" / "Optimal" / "Fast"
  final String modeLabel; // shown on the result card
  final double kgPerWeek; // negative = loss
  final String icon;

  const PaceOption({
    required this.label,
    required this.modeLabel,
    required this.kgPerWeek,
    required this.icon,
  });
}

const _paces = [
  PaceOption(
    label: 'Slow',
    modeLabel: 'Relaxed Pace',
    kgPerWeek: -0.35,
    icon: AppImages.slow,
  ),
  PaceOption(
    label: 'Optimal',
    modeLabel: 'Balanced Pace',
    kgPerWeek: -0.70,
    icon: AppImages.optimal,
  ),
  PaceOption(
    label: 'Fast',
    modeLabel: 'Aggressive Pace',
    kgPerWeek: -1.10,
    icon: AppImages.fast,
  ),
];

/// ─────────────────────────────────────────────
///  MAIN SCREEN
/// ─────────────────────────────────────────────
class GoalPaceScreen extends ConsumerStatefulWidget {
  final double targetWeightKg;

  const GoalPaceScreen({super.key, required this.targetWeightKg});

  @override
  ConsumerState<GoalPaceScreen> createState() => _GoalPaceScreenState();
}

class _GoalPaceScreenState extends ConsumerState<GoalPaceScreen> {
  int? _selectedIndex;

  PaceOption? get _pace =>
      _selectedIndex == null ? null : _paces[_selectedIndex!];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const PersonalizationStepper(
          currentStep: 10,
          width: 13,
        ),
      ),
      // bottomSheet:
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ── Title ────────────────
                  const Text('How fast do you want\nto achieve your goal?',
                      style: TextStyle(
                          fontSize: 28,
                          letterSpacing: 0,
                          color: AppColors.white,
                          fontWeight: FontWeight.w600)),

                  Column(
                    children: [
                      _PaceIconRow(selectedIndex: _selectedIndex),

                      const SizedBox(height: 16),

                      _PaceSlider(
                        selectedIndex: _selectedIndex,
                        onChanged: (i) => setState(() => _selectedIndex = i),
                      ),
                      const SizedBox(height: 16),

                      // ── Labels row ───────────
                      const _PaceLabelsRow(),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _pace == null
                        ? const _PacePromptCard()
                        : _ResultCard(pace: _pace!),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                16, 0, 16, 20 + MediaQuery.of(context).padding.bottom),
            child: CustomYafButton(
                fontSize: 16,
                weight: FontWeight.w600,
                iconPositionLeft: false,
                text: "Continue",
                isDisabled: _selectedIndex == null,
                iconWidget: SvgPicture.asset(AppImages.arrowRight),
                onPressed: () {
                  ref
                      .read(onboardingProfileProvider.notifier)
                      .updateGoalPace(_pace!.label);
                  NavigationService.push(child: const RealisticTargetScreen());
                }),
          ),
        ],
      ),
    );
  }
}

/// ─────────────────────────────────────────────
///  PACE ICON ROW
///
///  Three icons sit above the slider at fixed
///  positions (0%, 50%, 100%) and light up when
///  that pace is active. Think of traffic lights
///  — only the selected one glows.
/// ─────────────────────────────────────────────
class _PaceIconRow extends StatelessWidget {
  final int? selectedIndex;
  const _PaceIconRow({required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_paces.length, (i) {
        final active = i == selectedIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 40,
          height: 40,
          // decoration: BoxDecoration(
          //   shape: BoxShape.circle,
          //   color: active ? _orange.withOpacity(0.15) : Colors.transparent,
          // ),
          child: Opacity(
            opacity: active ? 1 : 0.45,
            child: Image.asset(
              _paces[i].icon,
              scale: 2,
            ),
          ),
        );
      }),
    );
  }
}

/// ─────────────────────────────────────────────
///  PACE SLIDER
///
///  This is a custom discrete slider with only
///  3 stops (0, 1, 2).
///
///  Analogy: think of it as a light dimmer with
///  3 notches — the thumb snaps to each notch,
///  and the filled track to the left shows how
///  far you've turned it up.
/// ─────────────────────────────────────────────
class _PaceSlider extends StatelessWidget {
  final int? selectedIndex;
  final ValueChanged<int> onChanged;

  const _PaceSlider({required this.selectedIndex, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        // Track
        trackHeight: 10,
        activeTrackColor: _orange,
        inactiveTrackColor: Colors.white,

        // Thumb — the draggable circle
        thumbColor: _orange,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
        overlayColor: _orange.withValues(alpha: 0.15),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),

        // No tick marks needed — icons serve that role
        showValueIndicator: ShowValueIndicator.never,
      ),
      child: Slider(
        padding: EdgeInsets.zero,
        value: (selectedIndex ?? 1).toDouble(),
        min: 0,
        max: 2,
        // divisions: 2 means Flutter auto-snaps to 0, 1, 2
        divisions: 2,
        onChanged: (v) => onChanged(v.round()),
      ),
    );
  }
}

/// ─────────────────────────────────────────────
///  PACE LABELS ROW
/// ─────────────────────────────────────────────
class _PaceLabelsRow extends StatelessWidget {
  const _PaceLabelsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _paces
          .map((p) => Text(
                p.label,
                style: const TextStyle(
                  color: _textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ))
          .toList(),
    );
  }
}

/// ─────────────────────────────────────────────
///  RESULT CARD
///
///  Shows the outcome of the selected pace —
///  like a receipt that updates live as you
///  change your order.
/// ─────────────────────────────────────────────
class _ResultCard extends StatelessWidget {
  final PaceOption pace;
  const _ResultCard({required this.pace});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      // AnimatedSwitcher is like a crossfade on TV —
      // when the child's key changes, it fades the old
      // one out and the new one in.
      duration: const Duration(milliseconds: 250),
      child: Container(
        key: ValueKey(pace.label), // key change triggers the animation
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            // Mode chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: _orange,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                pace.modeLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Rate
            Text(
              '${pace.kgPerWeek.toStringAsFixed(1)} kg/week',
              style: const TextStyle(
                color: _textPrimary,
                fontSize: 34,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PacePromptCard extends StatelessWidget {
  const _PacePromptCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Choose a pace to continue',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: _textSecondary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
