import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/widgets/calorie_badge.dart';
import 'package:diet_lenz/widgets/macro_progress_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FoodLogDetail extends ConsumerStatefulWidget {
  const FoodLogDetail({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FoodLogDetailState();
}

class _FoodLogDetailState extends ConsumerState<FoodLogDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //
              Image.asset(
                AppImages.chicken,
                scale: 2,
              ),
              const SizedBox(height: 20),
              const Text(
                "Grilled Chicken ",
                style: TextStyle(
                  fontFamily: AppFonts.lato,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  CalorieBadge(
                    text: '250 cal',
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  CalorieBadge(
                    text: ' 400g ',
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  CalorieBadge(
                    text: '2 Plate',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in  ",
                style: TextStyle(
                  fontFamily: AppFonts.lato,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),
              const MacroProgressItem(
                label: 'Protein',
                currentValue: '10g',
                targetValue: '12g',
                progress: 0.6,
              ),

              const SizedBox(height: 20),
              const MacroProgressItem(
                label: 'Carbs',
                currentValue: '10g',
                targetValue: '12g',
                progress: 0.5,
              ),

              const SizedBox(height: 20),
              const MacroProgressItem(
                label: 'Fat',
                currentValue: '10g',
                targetValue: '12g',
                progress: 0.4,
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
