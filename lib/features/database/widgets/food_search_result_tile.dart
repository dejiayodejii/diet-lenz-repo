import 'dart:convert';
import 'dart:typed_data';

import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/features/camera/analyse_result.dart';
import 'package:flutter/material.dart';
import 'package:openapi/api.dart';

class FoodSearchResultTile extends StatelessWidget {
  const FoodSearchResultTile({
    super.key,
    required this.food,
    this.fromDatabaseSearch = false,
    this.onTap,
  });

  final FoodAnalysisDto food;
  final bool fromDatabaseSearch;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final macros = food.totalMacros;
    final calories = macros?.calories;

    return InkWell(
      onTap: onTap ??
          () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => AnalyseResultDetail(
                  food,
                  trackInDatabaseHistory: fromDatabaseSearch,
                ),
              ),
            );
          },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FoodThumbnail(imageBase64: food.imageBase64),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.foodName?.trim().isNotEmpty == true
                        ? food.foodName!.trim()
                        : 'Unknown food',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (food.description?.trim().isNotEmpty == true) ...[
                    const SizedBox(height: 6),
                    Text(
                      food.description!.trim(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      // spacing: 8,
                      // runSpacing: 8,
                      children: [
                        if (calories != null)
                          _MacroChip(
                              label: '${calories.toStringAsFixed(0)} cal'),
                        _MacroChip(
                          label:
                              'Protein ${_formatMacro(macros?.protein?.value, macros?.protein?.unit)}',
                        ),
                        _MacroChip(
                          label:
                              'Carbs ${_formatMacro(macros?.carbs?.value, macros?.carbs?.unit)}',
                        ),
                        _MacroChip(
                          label:
                              'Fat ${_formatMacro(macros?.fat?.value, macros?.fat?.unit)}',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textGrey,
            ),
          ],
        ),
      ),
    );
  }

  String _formatMacro(double? value, String? unit) {
    return '${(value ?? 0).toStringAsFixed(1)}${unit ?? 'g'}';
  }
}

class _FoodThumbnail extends StatelessWidget {
  const _FoodThumbnail({required this.imageBase64});

  final String? imageBase64;

  @override
  Widget build(BuildContext context) {
    final imageBytes = _decodeImage();

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 64,
        height: 64,
        color: AppColors.surfaceGrey,
        child: imageBytes == null
            ? const Icon(
                Icons.restaurant_rounded,
                color: AppColors.primaryColor,
                size: 28,
              )
            : Image.memory(
                imageBytes,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.restaurant_rounded,
                  color: AppColors.primaryColor,
                  size: 28,
                ),
              ),
      ),
    );
  }

  Uint8List? _decodeImage() {
    final source = imageBase64?.trim();
    if (source == null || source.isEmpty) return null;

    try {
      final cleanedSource = source.contains(',')
          ? source.substring(source.indexOf(',') + 1)
          : source;
      return base64Decode(cleanedSource);
    } catch (_) {
      return null;
    }
  }
}

class _MacroChip extends StatelessWidget {
  const _MacroChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.textGrey,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
