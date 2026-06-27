import 'package:cached_network_image/cached_network_image.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/features/auth/controller/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider).authResponse;
    final userName = authState?.firstName ?? "John Doe";
    final profilePhoto = authState?.profilePhoto;

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(60),
          child: profilePhoto != null
              ? CachedNetworkImage(
                  imageUrl: profilePhoto,
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Container(
                    height: 50,
                    width: 50,
                    color: AppColors.primaryColor.withValues(alpha: 0.2),
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: AppColors.primaryColor,
                    ),
                  ),
                )
              : Container(
                  height: 50,
                  width: 50,
                  color: AppColors.primaryColor.withValues(alpha: 0.2),
                  child: const Icon(
                    Icons.person,
                    size: 30,
                    color: AppColors.primaryColor,
                  ),
                ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "WELCOME,",
                style: TextStyle(
                  fontFamily: AppFonts.lato,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textLightGrey,
                ),
              ),
              Text(
                userName,
                style: const TextStyle(
                  fontFamily: AppFonts.lato,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}
