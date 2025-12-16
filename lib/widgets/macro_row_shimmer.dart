import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MacroRowShimmer extends StatelessWidget {
  const MacroRowShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color.fromRGBO(30, 30, 30, 1),
      highlightColor: const Color.fromRGBO(50, 50, 50, 1),
      child: Row(
        children: List.generate(
          3,
          (index) => Expanded(
            child: Container(
              height: 81,
              margin: EdgeInsets.only(
                right: index < 2 ? 15 : 0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
