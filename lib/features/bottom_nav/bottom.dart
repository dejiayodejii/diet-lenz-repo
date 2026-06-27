import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/features/database/database.dart';
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
  const BottomNavScreen({super.key, this.index = 1, this.fromDeepLink = false});
  final int index;
  final bool fromDeepLink;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BottomNavState();
}

class _BottomNavState extends ConsumerState<BottomNavScreen> {
  late final List<Widget> _screens;

  int _selectedIndex = 1;
  bool _isActionMenuOpen = false;

  @override
  void initState() {
    _screens = [
      const ProgressScreen(),
      const HomeScreen(),
      const SetttingsScreen(),
      const AICameraScreen()
    ];
    _selectedIndex = widget.index.clamp(0, _screens.length - 1);
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
    // final isPremium = ref.read(subscriptionViewModelProvider).isPremium;
    // if (!isPremium ) {
    //   await ref.read(subscriptionViewModelProvider.notifier).presentPaywall();
    //   return;
    // }
    setState(() {
      _selectedIndex = 3;
      _isActionMenuOpen = false;
    });
  }

  void _toggleActionMenu() {
    setState(() => _isActionMenuOpen = !_isActionMenuOpen);
  }

  void _closeActionMenu() {
    if (!_isActionMenuOpen) return;
    setState(() => _isActionMenuOpen = false);
  }

  void _navigateToFoodDatabase() {
    _closeActionMenu();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const DatabaseSearchScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(child: _screens[_selectedIndex]),
          if (_isActionMenuOpen) ...[
            Positioned.fill(
              child: GestureDetector(
                onTap: _closeActionMenu,
                behavior: HitTestBehavior.opaque,
                child: Container(color: Colors.black.withValues(alpha: 0.45)),
              ),
            ),
            Positioned(
              right: 28,
              bottom: 18,
              child: _buildActionMenu(),
            ),
          ],
        ],
      ),
      resizeToAvoidBottomInset: false, // Set to false for both platforms
      bottomNavigationBar: _buildCustomBottomBar(),
    );
  }

  Widget _buildActionMenu() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildActionMenuItem(
          label: 'Scan Food',
          icon: Icons.qr_code_scanner_rounded,
          onTap: _navigateToScan,
        ),
        const SizedBox(height: 30),
        _buildActionMenuItem(
          label: 'Food Database',
          icon: Icons.search_rounded,
          onTap: _navigateToFoodDatabase,
        ),
      ],
    );
  }

  Widget _buildActionMenuItem({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 18),
          Container(
            height: 76,
            width: 76,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.primaryColor,
              size: 38,
            ),
          ),
        ],
      ),
    );
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
          _isActionMenuOpen = false;
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
      onTap: _toggleActionMenu,
      child: Container(
        height: 72,
        width: 72,
        decoration: const BoxDecoration(
          color: AppColors.primaryColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _isActionMenuOpen ? Icons.close_rounded : Icons.add_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}
