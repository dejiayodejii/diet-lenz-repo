// import 'dart:math';
// import 'package:diet_lenz/core/constants/app_assets.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// class AnimatedLogo extends StatefulWidget {
//   final double size;
//   final String asset;

//   const AnimatedLogo({Key? key, this.size = 52, this.asset = AppImages.logoV})
//       : super(key: key);

//   @override
//   State<AnimatedLogo> createState() => _AnimatedLogoState();
// }

// class _AnimatedLogoState extends State<AnimatedLogo>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 3),
//     )..repeat(reverse: true);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: widget.size,
//       height: widget.size,
//       child: AnimatedBuilder(
//         animation: _controller,
//         builder: (context, child) {
//           final double scale = 0.9 + (_controller.value * 0.2); // 0.9 -> 1.1
//           final double rotation = _controller.value * 4 * pi;
//           return Transform.rotate(
//             angle: rotation,
//             child: Transform.scale(
//               scale: scale,
//               child: child,
//             ),
//           );
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(5.0),
//           child: SvgPicture.asset(
//             widget.asset,
//             color: Colors.white,
//             fit: BoxFit.cover,
//           ),
//         ),
//       ),
//     );
//   }
// }
