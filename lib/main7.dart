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
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212), // Dark background
      ),
      home: const FoodLogScreen(),
    );
  }
}

class FoodLogScreen extends StatefulWidget {
  const FoodLogScreen({super.key});

  @override
  State<FoodLogScreen> createState() => _FoodLogScreenState();
}

class _FoodLogScreenState extends State<FoodLogScreen> {
  // Track the active index. 0 = History, 1 = Home, 2 = Settings
  int _selectedIndex = 1; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E), // Deep black/grey background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Food Log"),
        leading: const Icon(Icons.arrow_back),
      ),
      body: const Center(
        child: Text(
          "Content goes here",
          style: TextStyle(color: Colors.grey),
        ),
      ),
      // We use a custom widget for the bottom bar
      bottomNavigationBar: _buildCustomBottomBar(),
    );
  }

  Widget _buildCustomBottomBar() {
    return Container(
      // Add padding for safe area (iPhone home indicator)
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      decoration: const BoxDecoration(
        color: Color(0xFF0E0E0E), // Matches background
        border: Border(
          top: BorderSide(color: Colors.black12), // Subtle top border
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end, // Align items to bottom
        children: [
          // 1. History Tab
          _buildNavItem(
            index: 0,
            icon: Icons.bar_chart_outlined, // Using bar chart for 'History' look
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

    return GestureDetector(
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
      onTap: () {
        print("Scan Button Tapped");
      },
      child: Container(
        height: 60,
        width: 60,
        decoration: const BoxDecoration(
          color: Colors.white, // White background
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Icon(
            Icons.qr_code_scanner_rounded, // Scan icon
            color: Color(0xFFFF5621), // Orange icon color
            size: 30,
          ),
        ),
      ),
    );
  }
}