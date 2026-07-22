import 'package:openapi/api.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/core/constants/app_colors.dart';
import 'package:diet_lenz/core/utils/functions.dart';
import 'package:flutter/material.dart';

class EditIngredientScreen extends StatefulWidget {
  final SuggestedFoodAnalysis suggestion;

  const EditIngredientScreen({
    super.key,
    required this.suggestion,
  });

  @override
  State<EditIngredientScreen> createState() => _EditIngredientScreenState();
}

class _EditIngredientScreenState extends State<EditIngredientScreen> {
  late List<IngredientDto> ingredients;

  @override
  void initState() {
    super.initState();
    // Create a mutable copy of the ingredients list
    ingredients = List.from(widget.suggestion.ingredients);
  }

  void _showAddIngredientDialog() {
    final nameController = TextEditingController();
    final caloriesController = TextEditingController();
    final proteinController = TextEditingController();
    final carbsController = TextEditingController();
    final fatController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Add Ingredient',
          style: TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Ingredient Name',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF6B35)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: caloriesController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Calories',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: proteinController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Protein (g)',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF6B35)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: carbsController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Carbs (g)',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF6B35)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: fatController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Fat (g)',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF6B35)),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                final newIngredient = IngredientDto(
                  name: nameController.text,
                  macros: MacroNutrientsDto(
                    calories: double.tryParse(caloriesController.text) ?? 0.0,
                    protein: QuantityDto(
                      value: double.tryParse(proteinController.text) ?? 0.0,
                      unit: 'g',
                    ),
                    carbs: QuantityDto(
                      value: double.tryParse(carbsController.text) ?? 0.0,
                      unit: 'g',
                    ),
                    fat: QuantityDto(
                      value: double.tryParse(fatController.text) ?? 0.0,
                      unit: 'g',
                    ),
                  ),
                );

                setState(() {
                  ingredients.add(newIngredient);
                });

                Navigator.pop(context);
              }
            },
            child: const Text(
              'Add',
              style: TextStyle(color: Color(0xFFFF6B35)),
            ),
          ),
        ],
      ),
    );
  }

  void _removeIngredient(int index) {
    setState(() {
      ingredients.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Image Header (Small)
                Stack(
                  children: [
                    // widget.suggestion.suggestedImage != null
                    //     ? Image.network(
                    //         widget.suggestion.suggestedImage!,
                    //         height: 200,
                    //         width: double.infinity,
                    //         fit: BoxFit.cover,
                    //         errorBuilder: (ctx, err, st) => Image.asset(
                    //           AppImages.salad,
                    //           scale: 2,
                    //           height: 200,
                    //           width: double.infinity,
                    //           fit: BoxFit.cover,
                    //         ),
                    //       )
                    //     : 
                        Image.asset(
                            AppImages.salad,
                            scale: 2,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                    SafeArea(
                      child: IconButton(
                        icon: const CircleAvatar(
                          backgroundColor: Colors.black45,
                          child: Icon(Icons.arrow_back_ios_new,
                              color: Colors.white, size: 18),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Ingredients",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ...ingredients.asMap().entries.map(
                            (entry) => _buildEditableIngredientCard(
                              entry.value,
                              entry.key,
                            ),
                          ),
                      _buildAddIngredientCard(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: SizedBox(
              height: 55,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Return the updated ingredients list
                  Navigator.pop(context, ingredients);
                },
                child: const Text(
                  "Update",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableIngredientCard(IngredientDto ingredient, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ingredient.name?.capitalize ?? "Unknown Ingredient",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    _buildMacroInfo(
                        "${ingredient.macros?.calories?.toStringAsFixed(0) ?? "0"} cal"),
                    _buildMacroInfo(
                        "P: ${ingredient.macros?.protein?.value?.toStringAsFixed(0) ?? "0"}g"),
                    _buildMacroInfo(
                        "C: ${ingredient.macros?.carbs?.value?.toStringAsFixed(0) ?? "0"}g"),
                    _buildMacroInfo(
                        "F: ${ingredient.macros?.fat?.value?.toStringAsFixed(0) ?? "0"}g"),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => _removeIngredient(index),
          ),
        ],
      ),
    );
  }

  Widget _buildAddIngredientCard() {
    return GestureDetector(
      onTap: _showAddIngredientDialog,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFFF6B35).withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.add_circle_outline,
                  color: const Color(0xFFFF6B35).withOpacity(0.7),
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  "Add Ingredient",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMacroInfo("__ cal"),
                _buildMacroInfo("Protein: __g"),
                _buildMacroInfo("Carbs: __g"),
                _buildMacroInfo("Fat: __g"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroInfo(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey, fontSize: 12),
    );
  }
}
