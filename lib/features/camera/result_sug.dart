import 'dart:io';
import 'package:diet_lenz/api_client/lib/api.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/features/camera/suggest_detail.dart';
import 'package:flutter/material.dart';

// --- Screen 1: Result Screen ---

class SuggestResultScreen extends StatelessWidget {
  final File? imageFile;
  final List<SuggestedFoodAnalysis> suggestions;

  const SuggestResultScreen({
    super.key,
    this.imageFile,
    this.suggestions = const [],
  });

  @override
  Widget build(BuildContext context) {
    // Get the first suggestion to display in the bottom card snippet
    final firstSuggestion = suggestions.isNotEmpty ? suggestions.first : null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false, // Hide default back button
      ),
      body: Stack(
        fit: StackFit.expand, // Ensures the stack fills the screen
        children: [
          // Background Image
          imageFile != null
              ? Image.file(
                  imageFile!,
                  fit: BoxFit.cover,
                )
              : Image.network(
                  'https://images.unsplash.com/photo-1490645935967-10de6ba17061?q=80&w=1000&auto=format&fit=crop',
                  fit: BoxFit.cover,
                ),
          // Top Bar
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(22),
                      bottomRight: Radius.circular(22),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Result",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.black54,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Bottom Navigation Card
          Positioned(
            bottom: 30 + MediaQuery.of(context).padding.bottom, // Add padding for safe area
            left: 20,
            right: 20,
            child: GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MealOptionsScreen(
                            suggestions: suggestions,
                            imageFile: imageFile,
                          ))),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    // ClipRRect(
                    //   borderRadius: BorderRadius.circular(8),
                    //   child: firstSuggestion?.suggestedImage != null
                    //       ? Image.network(firstSuggestion!.suggestedImage!,
                    //           width: 60,
                    //           height: 60,
                    //           fit: BoxFit.cover,
                    //           errorBuilder: (ctx, err, st) => Image.asset(
                    //                 AppImages.salad,
                    //                 scale: 2,
                    //                 height: 60,
                    //                 width: 60,
                    //               ))
                    //       : Image.network(
                    //           'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=200&auto=format&fit=crop',
                    //           width: 60,
                    //           height: 60,
                    //           fit: BoxFit.cover,
                    //         ),
                    // ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        firstSuggestion?.foodName ?? "Meal Optionsoo",
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.orange),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Screen 2: Meal Options ---

class MealOptionsScreen extends StatelessWidget {
  final List<SuggestedFoodAnalysis> suggestions;
  final File? imageFile;

  const MealOptionsScreen({
    super.key,
    required this.imageFile,
    this.suggestions = const [],
  });

  @override
  Widget build(BuildContext context) {
    // If no suggestions, use placeholder image
    final headerImage = Image.file(
      imageFile!,
      fit: BoxFit.cover,
      height: 250,
      width: double.infinity,
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Collapsible Image Header
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: Colors.black,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black45,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,
                      size: 16, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: headerImage,
            ),
          ),
          // Content Sheet
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Meal Options",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 20),
                  if (suggestions.isEmpty)
                    const Text("No suggestions available.",
                        style: TextStyle(color: Colors.grey)),
                  ...suggestions.map((suggestion) => MealPlanCard(
                        imageFile: headerImage,
                        title: suggestion.foodName ?? "Unknown Meal",
                        kcal: suggestion.totalMacros?.calories
                                ?.toStringAsFixed(0) ??
                            "0",
                        protein:
                            "${suggestion.totalMacros?.protein?.value?.toStringAsFixed(0) ?? "0"}g",
                        carbs:
                            "${suggestion.totalMacros?.carbs?.value?.toStringAsFixed(0) ?? "0"}g",
                        fat:
                            "${suggestion.totalMacros?.fat?.value?.toStringAsFixed(0) ?? "0"}g",
                        imageUrl: "",
                        suggestion: suggestion,
                      )),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Reusable Meal Card ---

class MealPlanCard extends StatelessWidget {
  final String title;
  final String kcal;
  final String protein;
  final String carbs;
  final String fat;
  final String imageUrl;
  final Widget? imageFile;
  final SuggestedFoodAnalysis suggestion;

  const MealPlanCard({
    super.key,
    required this.title,
    required this.kcal,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.imageUrl,
    required this.suggestion,
    this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SuggestMealDetailScreen(
                suggestion: suggestion, headerImage: imageFile),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15.0, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: imageFile ??
                  Image.network(
                    imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, st) => Image.asset(
                      AppImages.chicken,
                      scale: 2,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
            ),
            const SizedBox(height: 12),
            Text(title,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildMacroLabel("$kcal kcal"),
                _buildDivider(),
                _buildMacroLabel("Protein: $protein"),
                _buildDivider(),
                _buildMacroLabel("Carbs: $carbs"),
                _buildDivider(),
                _buildMacroLabel("Fat: $fat"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroLabel(String text) {
    return Text(text, style: const TextStyle(color: Colors.grey, fontSize: 13));
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Text("|", style: TextStyle(color: Colors.grey)),
    );
  }
}

// --- Suggest Meal Detail Screen ---

// --- Edit Ingredient Screen ---
