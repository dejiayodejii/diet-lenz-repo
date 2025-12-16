import 'dart:io';
import 'dart:typed_data';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/core/constants/app_assets.dart';
import 'package:diet_lenz/core/constants/app_colors.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/core/services/toast_service.dart';
import 'package:diet_lenz/core/utils/loader.dart';
import 'package:diet_lenz/features/camera/analyse_result.dart';
import 'package:diet_lenz/features/recipe/controller/recipe_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http_parser;
import 'package:image/image.dart' as img;

class AICameraScreen extends ConsumerStatefulWidget {
  final CameraDescription? camera;
  const AICameraScreen({Key? key, this.camera}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AICameraScreenState();
}

class _AICameraScreenState extends ConsumerState<AICameraScreen>
    with SingleTickerProviderStateMixin {
  // --- CONFIGURATION ---
  // Set this to TRUE to use the real camera (requires physical device)
  final bool useCamera = false;

  // Set this to TRUE to use test image from assets instead of camera
  final bool useTestImage = true; // Change to true for testing with assets
  final String testImagePath = AppImages.salad; // Path to your test image

  CameraController? _controller;
  late AnimationController _scannerController;
  late Animation<double> _scannerAnimation;

  // Menu Items
  final List<String> modes = [
    "Food Scan",
    "Recipe",
    "Barcode",
    "Label",
    "Upload"
  ];
  int selectedModeIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeScanner();
  }

  void _initializeScanner() {
    _scannerController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scannerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scannerController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initializeCamera() async {
    if (useCamera) {
      final cameras = await availableCameras();
      final camera = widget.camera ?? cameras.first;
      _controller = CameraController(camera, ResolutionPreset.medium);
      await _controller!.initialize();
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  /// Compress image to reduce file size
  Future<Uint8List> _compressImage(Uint8List imageBytes) async {
    // Decode the image
    img.Image? image = img.decodeImage(imageBytes);

    if (image == null) {
      return imageBytes; // Return original if decoding fails
    }

    // Resize if image is too large (max 1024px on longest side)
    if (image.width > 1024 || image.height > 1024) {
      image = img.copyResize(
        image,
        width: image.width > image.height ? 1024 : null,
        height: image.height > image.width ? 1024 : null,
      );
    }

    // Compress as JPEG with quality 85
    final compressedBytes =
        Uint8List.fromList(img.encodeJpg(image, quality: 85));

    print(
        '📊 Image compression: ${imageBytes.length} bytes → ${compressedBytes.length} bytes');

    return compressedBytes;
  }

  /// Capture image from camera or use test image
  Future<void> _captureAndAnalyze() async {
    final controller = ref.read(recipeViewModelProvider.notifier);

    try {
      http.MultipartFile imageFile;
      Uint8List imageBytes;

      if (useTestImage) {
        // Load image from assets for testing
        final ByteData data = await rootBundle.load(testImagePath);
        imageBytes = data.buffer.asUint8List();

        // Compress the image
        final compressedBytes = await _compressImage(imageBytes);

        imageFile = http.MultipartFile.fromBytes(
          'image',
          compressedBytes,
          filename: 'test_image.jpg',
          contentType: http_parser.MediaType('image', 'jpeg'),
        );
      } else if (_controller != null && _controller!.value.isInitialized) {
        // Capture from camera
        final XFile image = await _controller!.takePicture();
        final File file = File(image.path);
        imageBytes = await file.readAsBytes();

        // Compress the image
        final compressedBytes = await _compressImage(imageBytes);

        imageFile = http.MultipartFile.fromBytes(
          'image',
          compressedBytes,
          filename: 'camera_capture.jpg',
          contentType: http_parser.MediaType('image', 'jpeg'),
        );
      } else {
        // Show error if camera not ready
        ref.read(toastProvider).showError(
              'Camera not ready',
            );
       
        return;
      }

      // Call the API to analyze the recipe
      final success = await controller.analyzeRecipe(imageFile);

      if (success && mounted) {
        final state = ref.read(recipeViewModelProvider);
        if (state.analyzedRecipe != null) {
          // Navigate to result screen
          NavigationService.push(
            child: AnalyseResultDetail(state.analyzedRecipe!),
          );
        }
      } else if (mounted) {
        // Show error message
        final state = ref.read(recipeViewModelProvider);
        ref.read(toastProvider).showError(
              'Failed to analyze recipe',
            );
        
      }
    } catch (e) {
      if (mounted) {
        ref.read(toastProvider).showError(
              'Error: ${e.toString()}',
            );

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recipeViewModelProvider);

    return BlurryModalProgressHUD(
      inAsyncCall: state.isLoading,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            // CAMERA AND SCANNER AREA (takes remaining space)
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Dimensions for the scan box
                  final size = MediaQuery.of(context).size;
                  final double scanBoxSize = size.width * 0.85;
                  final double scanBoxTop = constraints.maxHeight * 0.2;

                  return Stack(
                    children: [
                      // 1. CAMERA FEED OR PLACEHOLDER
                      Positioned.fill(
                        child: _buildCameraView(),
                      ),

                      // 2. DARK OVERLAY WITH CUTOUT + CORNERS
                      Positioned.fill(
                        child: CustomPaint(
                          painter: ScannerOverlayPainter(
                            scanBoxRect: Rect.fromLTWH(
                              (size.width - scanBoxSize) / 2,
                              scanBoxTop,
                              scanBoxSize,
                              scanBoxSize,
                            ),
                          ),
                          child: Container(),
                        ),
                      ),

                      // 3. SCANNING LINE ANIMATION
                      Positioned(
                        top: scanBoxTop,
                        left: (size.width - scanBoxSize) / 2,
                        width: scanBoxSize,
                        height: scanBoxSize,
                        child: AnimatedBuilder(
                          animation: _scannerAnimation,
                          builder: (context, child) {
                            return Stack(
                              children: [
                                Positioned(
                                  top: _scannerAnimation.value *
                                      (scanBoxSize - 2),
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 2,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.white.withOpacity(0),
                                            Colors.white,
                                            Colors.white.withOpacity(0),
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.white.withOpacity(0.5),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                          )
                                        ]),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                      // 4. TOP BAR
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildCircleButton(
                                  Icons.arrow_back_ios_new, () {}),
                              const Text(
                                "AI Camera",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              // Invisible icon to balance the row
                              const SizedBox(width: 40),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // 5. BOTTOM CONTROLS (fixed at bottom)
            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildCameraView() {
    if (useCamera && _controller != null && _controller!.value.isInitialized) {
      return CameraPreview(_controller!);
    } else {
      // Placeholder if camera is off or not ready
      return Image.network(
        'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?q=80&w=1000&auto=format&fit=crop',
        fit: BoxFit.cover,
      );
    }
  }

  Widget _buildCircleButton(IconData icon, VoidCallback onTap) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withOpacity(0.5),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 18),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.only(bottom: 40, top: 20),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(18, 18, 18, 1),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        // gradient: LinearGradient(
        //   begin: Alignment.bottomCenter,
        //   end: Alignment.topCenter,
        //   colors: [Colors.black, Colors.transparent],
        // ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // SHUTTER BUTTON
          GestureDetector(
            onTap: _captureAndAnalyze,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade400, width: 4),
              ),
            ),
          ),
          const SizedBox(height: 30),

          // MODE SELECTOR
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 74,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(70),
              border: Border.all(color: Colors.grey.shade800, width: 0.5),
              color: Color.fromRGBO(4, 4, 15, 0.6),
            ),
            child: Center(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: modes.length,
                itemBuilder: (context, index) {
                  final isSelected = index == selectedModeIndex;
                  return GestureDetector(
                    onTap: () => setState(() => selectedModeIndex = index),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            modes[index],
                            style: TextStyle(
                              color:
                                  isSelected ? AppColors.primary : Colors.white,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- CUSTOM PAINTER FOR OVERLAY ---

class ScannerOverlayPainter extends CustomPainter {
  final Rect scanBoxRect;
  final double cornerLength = 30.0;
  final double cornerWidth = 5.0;

  ScannerOverlayPainter({required this.scanBoxRect});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    // 1. Draw the darkened background with a hole (using Path operations)
    final Path backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final Path cutoutPath = Path()
      ..addRRect(
          RRect.fromRectAndRadius(scanBoxRect, const Radius.circular(20)));

    // Combine to create the hole
    final Path visiblePath = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    canvas.drawPath(visiblePath, backgroundPaint);

    // 2. Draw the White Corners
    final Paint cornerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = cornerWidth
      ..strokeCap = StrokeCap.round;

    final double r = 20; // Corner radius matching the cutout

    // Top Left
    final Path tl = Path();
    tl.moveTo(scanBoxRect.left, scanBoxRect.top + cornerLength);
    tl.lineTo(scanBoxRect.left, scanBoxRect.top + r);
    tl.arcToPoint(Offset(scanBoxRect.left + r, scanBoxRect.top),
        radius: Radius.circular(r));
    tl.lineTo(scanBoxRect.left + cornerLength, scanBoxRect.top);
    canvas.drawPath(tl, cornerPaint);

    // Top Right
    final Path tr = Path();
    tr.moveTo(scanBoxRect.right - cornerLength, scanBoxRect.top);
    tr.lineTo(scanBoxRect.right - r, scanBoxRect.top);
    tr.arcToPoint(Offset(scanBoxRect.right, scanBoxRect.top + r),
        radius: Radius.circular(r));
    tr.lineTo(scanBoxRect.right, scanBoxRect.top + cornerLength);
    canvas.drawPath(tr, cornerPaint);

    // Bottom Right
    final Path br = Path();
    br.moveTo(scanBoxRect.right, scanBoxRect.bottom - cornerLength);
    br.lineTo(scanBoxRect.right, scanBoxRect.bottom - r);
    br.arcToPoint(Offset(scanBoxRect.right - r, scanBoxRect.bottom),
        radius: Radius.circular(r));
    br.lineTo(scanBoxRect.right - cornerLength, scanBoxRect.bottom);
    canvas.drawPath(br, cornerPaint);

    // Bottom Left
    final Path bl = Path();
    bl.moveTo(scanBoxRect.left + cornerLength, scanBoxRect.bottom);
    bl.lineTo(scanBoxRect.left + r, scanBoxRect.bottom);
    bl.arcToPoint(Offset(scanBoxRect.left, scanBoxRect.bottom - r),
        radius: Radius.circular(r));
    bl.lineTo(scanBoxRect.left, scanBoxRect.bottom - cornerLength);
    canvas.drawPath(bl, cornerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
