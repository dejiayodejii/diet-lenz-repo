import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/features/subscription/controller/subscription_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Screen that presents the RevenueCat-hosted paywall.
///
/// Usage:
/// ```dart
/// NavigationService.push(child: const PaywallScreen());
/// ```
///
/// Or use the ViewModel directly to present it as a modal:
/// ```dart
/// ref.read(subscriptionViewModelProvider.notifier).presentPaywall();
/// ```
class PaywallScreen extends ConsumerStatefulWidget {
  /// If true, the paywall is only shown when the user is NOT premium.
  /// If already premium, the screen pops immediately.
  final bool onlyIfNeeded;

  const PaywallScreen({super.key, this.onlyIfNeeded = false});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showPaywall());
  }

  Future<void> _showPaywall() async {
    final vm = ref.read(subscriptionViewModelProvider.notifier);

    // If onlyIfNeeded and already premium, just pop
    if (widget.onlyIfNeeded) {
      final isPremium = await vm.checkPremiumStatus();
      if (isPremium && mounted) {
        Navigator.of(context).pop(true);
        return;
      }
    }

    setState(() => _loading = false);

    // Present the RevenueCat paywall modal
    final purchased = widget.onlyIfNeeded
        ? await vm.presentPaywallIfNeeded()
        : await vm.presentPaywall();

    if (mounted) {
      Navigator.of(context).pop(purchased);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ),
      backgroundColor: Colors.black,
      body: _loading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Loading...',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontFamily: AppFonts.lato,
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
