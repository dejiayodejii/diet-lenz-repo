import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CalorieCardShimmer extends StatelessWidget {
  const CalorieCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color.fromRGBO(30, 30, 30, 1),
      highlightColor: const Color.fromRGBO(50, 50, 50, 1),
      child: Container(
        width: double.infinity,
        height: 212,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
