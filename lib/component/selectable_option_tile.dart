import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SelectableOptionTile extends StatelessWidget {
  const SelectableOptionTile({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.subtitle,
    this.imagePath,
    this.leading,
    this.height = 56,
    this.borderRadius = 32,
  }) : assert(
          imagePath == null || leading == null,
          'Provide either imagePath or leading, not both.',
        );

  final String label;
  final String? subtitle;
  final String? imagePath;
  final Widget? leading;
  final bool isSelected;
  final VoidCallback onTap;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: isSelected,
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: isSelected
                ? const Color(0xFF393C43)
                : const Color.fromRGBO(36, 38, 43, 1),
            boxShadow: isSelected
                ? const [
                    BoxShadow(
                      color: Color.fromRGBO(129, 133, 141, 0.25),
                      spreadRadius: 4,
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: 10),
              ],
              if (imagePath != null) ...[
                Image.asset(
                  imagePath!,
                  fit: BoxFit.contain,
                  scale: 2,
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        fontFamily: AppFonts.workSans,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color.fromRGBO(255, 255, 255, 0.7),
                          fontFamily: AppFonts.workSans,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SvgPicture.asset(
                isSelected ? AppImages.selected : AppImages.unselected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
