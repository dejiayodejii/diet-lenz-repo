import 'dart:ui';
import 'package:diet_lenz/core/constants/app_colors.dart';
import 'package:diet_lenz/core/widgets/animated_logo.dart';
import 'package:flutter/material.dart';

class BlurryModalProgressHUD extends StatelessWidget {
  final bool? inAsyncCall;
  final double opacity;
  final Color color;
  final double blurEffectIntensity;
  final Widget? progressIndicator;
  final Offset? offset;
  final bool dismissible;
  final Widget? child;

  const BlurryModalProgressHUD({
    super.key,
    required this.inAsyncCall,
    this.opacity = 0.1,
    this.color = AppColors.primary,
    this.blurEffectIntensity = 1.0,
    this.progressIndicator,
    // const CircularProgressIndicator(color: AppColor.primaryColor),
    this.offset,
    this.dismissible = false,
    required this.child,
  })  : assert(child != null),
        assert(inAsyncCall != null),
        assert(child is Widget);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    widgetList.add(child!);
    if (inAsyncCall == true) {
      Widget layOutProgressIndicator;
      if (offset == null) {
        layOutProgressIndicator = Center(child: const LogoLoader());
      } else {
        layOutProgressIndicator = Positioned(
            left: offset!.dx, top: offset!.dy, child: const LogoLoader());
      }
      final modal = [
        BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: blurEffectIntensity, sigmaY: blurEffectIntensity),
          child: Opacity(
            opacity: opacity,
            child: ModalBarrier(dismissible: dismissible, color: color),
          ),
        ),
        layOutProgressIndicator,
      ];
      widgetList += modal;
    }
    return Stack(
      alignment: Alignment
          .bottomCenter, //causing slight problems **can restore anytime
      children: widgetList,
    );
  }
}

class LogoLoader extends StatelessWidget {
  const LogoLoader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      width: 72,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: AppColors.white,
        boxShadow: const [
          BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 3)
        ],
      ),
      child: const CircularProgressIndicator(
        color: AppColors.primary,
        // backgroundColor: AppColors.white
        ),
    );
  }
}
