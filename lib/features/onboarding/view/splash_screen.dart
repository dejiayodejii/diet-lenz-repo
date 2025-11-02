import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/view/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
     super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 3), () {
        NavigationService.push(child:   const LoginScreen());
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(AppImages.dietLenzLogo),
      ),
    );
  }
}
