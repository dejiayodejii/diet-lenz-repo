import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/features/subscription/controller/subscription_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Screen that presents the RevenueCat Customer Center.
///
/// The Customer Center allows users to:
/// - View their active subscription
/// - Manage billing (cancel, change plan)
/// - Request refunds
/// - Contact support
///
/// Usage:
/// ```dart
/// NavigationService.push(child: const CustomerCenterScreen());
/// ```
class CustomerCenterScreen extends ConsumerStatefulWidget {
  const CustomerCenterScreen({super.key});

  @override
  ConsumerState<CustomerCenterScreen> createState() =>
      _CustomerCenterScreenState();
}

class _CustomerCenterScreenState extends ConsumerState<CustomerCenterScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _showCustomerCenter();
  }

  Future<void> _showCustomerCenter() async {
    setState(() => _loading = false);

    final vm = ref.read(subscriptionViewModelProvider.notifier);
    await vm.presentCustomerCenter();

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
