// import 'dart:io';

// import 'package:camerawesome/camerawesome_plugin.dart';
// import 'package:flutter/material.dart';
// import 'package:image/image.dart' as img;

// class CamerAwesomeTestScreen extends StatefulWidget {
//   const CamerAwesomeTestScreen({super.key});

//   @override
//   State<CamerAwesomeTestScreen> createState() => _CamerAwesomeTestScreenState();
// }

// class _CamerAwesomeTestScreenState extends State<CamerAwesomeTestScreen> {
//   File? _lastCapture;
//   String? _captureDetails;
//   String? _captureError;

//   Future<SingleCaptureRequest> _buildCapturePath(
//     List<Sensor> sensors,
//   ) async {
//     final directory = await Directory(
//       '${Directory.systemTemp.path}/diet_lenz_camerawesome',
//     ).create(recursive: true);
//     final path =
//         '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
//     return SingleCaptureRequest(path, sensors.first);
//   }

//   void _handleCapture(MediaCapture capture) {
//     if (capture.status == MediaCaptureStatus.failure) {
//       if (!mounted) return;
//       setState(() {
//         _captureError = capture.exception?.toString() ?? 'Capture failed';
//       });
//       return;
//     }

//     if (capture.status != MediaCaptureStatus.success || !capture.isPicture) {
//       return;
//     }

//     capture.captureRequest.when(
//       single: (request) {
//         final file = request.file;
//         if (file != null) _inspectCapture(File(file.path));
//       },
//       multiple: (request) {
//         final file = request.fileBySensor.values.firstOrNull;
//         if (file != null) _inspectCapture(File(file.path));
//       },
//     );
//   }

//   Future<void> _inspectCapture(File file) async {
//     final bytes = await file.readAsBytes();
//     final decoded = img.decodeImage(bytes);
//     if (!mounted) return;

//     final sizeMb = bytes.length / (1024 * 1024);
//     setState(() {
//       _lastCapture = file;
//       _captureError = null;
//       _captureDetails = decoded == null
//           ? '${sizeMb.toStringAsFixed(2)} MB'
//           : '${decoded.width} × ${decoded.height}  •  '
//               '${sizeMb.toStringAsFixed(2)} MB';
//     });
//   }

//   void _openCapture(MediaCapture capture) {
//     capture.captureRequest.when(
//       single: (request) {
//         final file = request.file;
//         if (file != null) _showCapture(File(file.path));
//       },
//       multiple: (request) {
//         final file = request.fileBySensor.values.firstOrNull;
//         if (file != null) _showCapture(File(file.path));
//       },
//     );
//   }

//   Future<void> _showCapture(File file) async {
//     await showDialog<void>(
//       context: context,
//       barrierColor: Colors.black,
//       builder: (dialogContext) {
//         return Dialog.fullscreen(
//           backgroundColor: Colors.black,
//           child: Stack(
//             children: [
//               Positioned.fill(
//                 child: InteractiveViewer(
//                   minScale: 1,
//                   maxScale: 5,
//                   child: Image.file(file, fit: BoxFit.contain),
//                 ),
//               ),
//               SafeArea(
//                 child: IconButton(
//                   onPressed: () => Navigator.pop(dialogContext),
//                   icon: const Icon(Icons.close_rounded, color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: CameraAwesomeBuilder.awesome(
//               saveConfig: SaveConfig.photo(pathBuilder: _buildCapturePath),
//               sensorConfig: SensorConfig.single(
//                 sensor: Sensor.position(SensorPosition.back),
//                 flashMode: FlashMode.auto,
//                 aspectRatio: CameraAspectRatios.ratio_4_3,
//                 zoom: 0,
//               ),
//               previewFit: CameraPreviewFit.cover,
//               enablePhysicalButton: true,
//               availableFilters: const [],
//               topActionsBuilder: (_) => const SizedBox.shrink(),
//               onMediaCaptureEvent: _handleCapture,
//               onMediaTap: _openCapture,
//             ),
//           ),
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
//               child: Row(
//                 children: [
//                   _TopAction(
//                     tooltip: 'Back',
//                     icon: Icons.arrow_back_ios_new_rounded,
//                     onPressed: () => Navigator.maybePop(context),
//                   ),
//                   const Expanded(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           'CamerAwesome Test',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 17,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                         SizedBox(height: 2),
//                         Text(
//                           'Original JPEG • Rear camera • 4:3',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             color: Colors.white70,
//                             fontSize: 11,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 48),
//                 ],
//               ),
//             ),
//           ),
//           if (_captureDetails != null || _captureError != null)
//             Positioned(
//               top: MediaQuery.paddingOf(context).top + 72,
//               left: 20,
//               right: 20,
//               child: GestureDetector(
//                 onTap: _lastCapture == null
//                     ? null
//                     : () => _showCapture(_lastCapture!),
//                 child: Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withValues(alpha: 0.72),
//                     borderRadius: BorderRadius.circular(14),
//                     border: Border.all(color: Colors.white24),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(
//                         _captureError == null
//                             ? Icons.check_circle_outline_rounded
//                             : Icons.error_outline_rounded,
//                         color: _captureError == null
//                             ? const Color(0xFF77DD77)
//                             : Colors.redAccent,
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Text(
//                           _captureError ?? 'Captured: $_captureDetails',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 13,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                       if (_lastCapture != null)
//                         const Icon(
//                           Icons.zoom_in_rounded,
//                           color: Colors.white70,
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// class _TopAction extends StatelessWidget {
//   const _TopAction({
//     required this.tooltip,
//     required this.icon,
//     required this.onPressed,
//   });

//   final String tooltip;
//   final IconData icon;
//   final VoidCallback onPressed;

//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       onPressed: onPressed,
//       tooltip: tooltip,
//       style: IconButton.styleFrom(
//         backgroundColor: Colors.black.withValues(alpha: 0.55),
//         foregroundColor: Colors.white,
//       ),
//       icon: Icon(icon, size: 20),
//     );
//   }
// }
