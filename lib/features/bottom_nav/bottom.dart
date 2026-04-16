import 'dart:io';

import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/features/home/views/home.dart';
import 'package:diet_lenz/features/home/views/progress.dart';
import 'package:diet_lenz/features/settings/views/settings.dart';
import 'package:diet_lenz/features/camera/camera_screen.dart';
import 'package:diet_lenz/features/subscription/controller/subscription_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider to track the current tab index
final currentTabProvider = StateProvider<int>((ref) => 0);

class BottomNavScreen extends ConsumerStatefulWidget {
  const BottomNavScreen({super.key, this.index = 0, this.fromDeepLink = false});
  final int index;
  final bool fromDeepLink;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BottomNavState();
}

class _BottomNavState extends ConsumerState<BottomNavScreen> {
  late final List<Widget> _screens;
  int currentIndex = 0;

  int _selectedIndex = 1;

  @override
  void initState() {
    currentIndex = widget.index;
    _screens = [
      const ProgressScreen(),
      const HomeScreen(),
      const SetttingsScreen(),
      const AICameraScreen()
    ];
    super.initState();
    // Show paywall once if user is not premium when they land on the home tab
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _checkPremiumOnLaunch());
  }

  Future<void> _checkPremiumOnLaunch() async {
    final isPremium = await ref
        .read(subscriptionViewModelProvider.notifier)
        .checkPremiumStatus();
    if (!isPremium && mounted) {
      await ref.read(subscriptionViewModelProvider.notifier).presentPaywall();
    }
  }

  Future<void> _navigateToScan() async {
    final isPremium = ref.read(subscriptionViewModelProvider).isPremium;
    if (!isPremium ) {
      await ref.read(subscriptionViewModelProvider.notifier).presentPaywall();
      return;
    }
    setState(() => _selectedIndex = 3);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = keyboardHeight > 0;

    return Scaffold(
        body: SafeArea(child: _screens[_selectedIndex]),
        resizeToAvoidBottomInset: false, // Set to false for both platforms
        bottomNavigationBar: _buildCustomBottomBar());
  }

  Widget _buildCustomBottomBar() {
    return Container(
      // Add padding for safe area (iPhone home indicator)
      decoration: const BoxDecoration(
        color: Color(0xFF0E0E0E), // Matches background
        border: Border(
          top: BorderSide(color: Colors.black12), // Subtle top border
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end, // Align items to bottom
            children: [
              // 1. History Tab
              _buildNavItem(
                index: 0,
                icon: Icons
                    .bar_chart_outlined, // Using bar chart for 'History' look
                label: "History",
              ),

              // 2. Home Tab (Active)
              _buildNavItem(
                index: 1,
                icon: Icons.home_outlined,
                label: "Home",
              ),

              // 3. Settings Tab
              _buildNavItem(
                index: 2,
                icon: Icons.settings_outlined,
                label: "Settings",
              ),

              // 4. The Custom Scan Button
              _buildScanButton(),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for standard text/icon tabs
  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bool isSelected = _selectedIndex == index;
    final Color color = isSelected ? const Color(0xFFFF5621) : Colors.grey;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for the unique Scan button
  Widget _buildScanButton() {
    return GestureDetector(
      onTap: _navigateToScan,
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: _selectedIndex == 3
              ? AppColors.primaryColor
              : Colors.white, // White background
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            Icons.qr_code_scanner_rounded, // Scan icon
            color: _selectedIndex == 3
                ? Colors.white
                : AppColors.primaryColor, // Orange icon color
            size: 30,
          ),
        ),
      ),
    );
  }
}
