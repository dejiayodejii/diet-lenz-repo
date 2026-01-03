import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/controller/onboarding_profile_provider.dart';
import 'package:diet_lenz/features/auth/view/personization/setup_finished.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart'; // For the Country data class
import 'package:country_flags/country_flags.dart';
import 'package:flutter_svg/svg.dart'; // For the Flag visuals

class CountrySelectionScreen extends ConsumerStatefulWidget {
  const CountrySelectionScreen({super.key,this.isFromSettings = false});
  final bool isFromSettings;

  @override
  ConsumerState<CountrySelectionScreen> createState() =>
      _CountrySelectionScreenState();
}

class _CountrySelectionScreenState
    extends ConsumerState<CountrySelectionScreen> {
  // 1. Store the full list and the filtered list
  late List<Country> _allCountries;
  List<Country> _filteredCountries = [];

  // 2. Track the selected country code
  String? _selectedCountryCode;
  String? _selectedCountry;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the list using the country_picker package's internal service
    _allCountries = CountryService().getAll();
    _filteredCountries = _allCountries;

    // Add listener for search
    _searchController.addListener(_filterCountries);
  }

  void _filterCountries() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCountries = _allCountries.where((country) {
        return country.name.toLowerCase().contains(query) ||
            country.countryCode.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark background
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // --- Title ---
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              "What country are you in?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // --- Search Bar ---
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                filled: true,
                fillColor: const Color(0xFF2C2C2E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          // Force focus out or keep it depending on UX preference
                        },
                      )
                    : null,
              ),
            ),
          ),

          // --- Country List ---
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCountries.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final country = _filteredCountries[index];
                final isSelected = _selectedCountryCode == country.countryCode;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCountryCode = country.countryCode;
                      _selectedCountry = country.name;
                    });
                  },
                  child: Container(
                    color: Colors.transparent, // Ensures tap target is full row
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        // Flag Widget from country_flags package
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: CountryFlag.fromCountryCode(
                            country.countryCode,
                            height: 24,
                            width: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          country.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        // Optional checkmark if selected
                        if (isSelected)
                          const Icon(Icons.check, color: Color(0xFFE46238)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // --- Continue Button ---
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CustomYafButton(
                iconPositionLeft: false,
                text: "Continue",
                iconWidget: SvgPicture.asset(AppImages.arrowRight),
                onPressed: () {
                  // Save selected allergies

                  ref
                      .read(onboardingProfileProvider.notifier)
                      .updateCountry(_selectedCountry ?? '');
                  NavigationService.push(child: const PlanFinishedScreen());
                }),
          ),
        ],
      ),
    );
  }
}
