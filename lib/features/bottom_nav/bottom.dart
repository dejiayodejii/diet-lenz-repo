import 'dart:io';

import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/features/home/views/home.dart';
import 'package:diet_lenz/features/home/views/progress.dart';
import 'package:diet_lenz/features/settings/views/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider to track the current tab index
final currentTabProvider = StateProvider<int>((ref) => 0);

class BottomNav extends ConsumerStatefulWidget {
  const BottomNav({super.key, this.index = 0, this.fromDeepLink = false});
  final int index;
  final bool fromDeepLink;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BottomNavState();
}

class _BottomNavState extends ConsumerState<BottomNav> {
  late final List<Widget> _screens;
  int currentIndex = 0;

  @override
  void initState() {
    currentIndex = widget.index;
    _screens = [
      HomeScreen(),
      const ProgressScreen(),

      const SetttingsScreen(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = keyboardHeight > 0;

    return Scaffold(
      body: SafeArea(child: _screens[currentIndex]),
      resizeToAvoidBottomInset: false, // Set to false for both platforms
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.translationValues(
          0.0,
          // Hide bottom nav on iOS when keyboard is up and we're on exchange screen
          Platform.isIOS && isKeyboardVisible && currentIndex == 2
              ? 0.0 // Move it down to hide it
              : 0.0,
          0.0,
        ),
        child: BottomNavigationBar(
          enableFeedback: false,
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: AppColors.white,
          // backgroundColor: AppColors.surfaceColor,
          currentIndex: currentIndex,
          elevation: 2,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.credit_card_rounded),
            //   label: 'Cards',
            // ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.swap_horiz_outlined),
            //   label: 'Rates',
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
             BottomNavigationBarItem(
              icon: Icon(Icons.swap_horiz_outlined),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
