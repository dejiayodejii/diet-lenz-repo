import 'package:cached_network_image/cached_network_image.dart';
import 'package:diet_lenz/core/constants/app_assets.dart';
import 'package:diet_lenz/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class ImageBuilder extends ConsumerStatefulWidget {
  const ImageBuilder(
      {super.key, this.size = 50, required this.url, this.asset});
  final String? url;
  final String? asset;

  final double size;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ImageBuilderState();
}

class _ImageBuilderState extends ConsumerState<ImageBuilder> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return widget.url != null
        ? CachedNetworkImage(
            imageUrl: widget.url!,
            scale: 2,
            imageBuilder: (context, imageProvider) => Container(
              height: widget.size,
              width: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) => Container(
              height: widget.size,
              width: widget.size,
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.5)),
              child: Center(
                  child: SvgPicture.asset(
                AppImages.logoV,
                color: Colors.white,
              )),
            ),
            errorWidget: (context, url, error) =>
                Center(child: SvgPicture.asset(AppImages.placeL)),
          )
        : Container(
            height: widget.size,
            width: widget.size,
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
                child: SvgPicture.asset(widget.asset ?? AppImages.logoSvg,
                    color: widget.asset == null ? null : Colors.white)));
  }
}
