import 'dart:io';
import 'dart:typed_data';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/core/constants/app_assets.dart';
import 'package:diet_lenz/core/constants/app_colors.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/core/services/toast_service.dart';
import 'package:diet_lenz/core/utils/loader.dart';
import 'package:diet_lenz/features/camera/analyse_result.dart';
import 'package:diet_lenz/features/camera/result_sug.dart'; // Import SuggestResultScreen
import 'package:diet_lenz/features/recipe/controller/recipe_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http_parser;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:path_provider/path_provider.dart'; // Add path_provider

class AICameraScreen extends ConsumerStatefulWidget {
  final CameraDescription? camera;
  const AICameraScreen({Key? key, this.camera}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AICameraScreenState();
}

class _AICameraScreenState extends ConsumerState<AICameraScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  // --- CONFIGURATION ---
  // Set this to TRUE to use the real camera (requires physical device)
  final bool useCamera = true;

  // Set this to TRUE to use test image from assets instead of camera
  final bool useTestImage = false; // Change to true for testing with assets
  final String testImagePath = AppImages.salad; // Path to your test image

  CameraController? _controller;
  late AnimationController _scannerController;
  late Animation<double> _scannerAnimation;
  bool _isDisposed = false;
  bool _isInitializingCamera = false;

  // Menu Items
  final List<String> modes = [
    "Food Scan",
    "Recipe",
    "Barcode",
    "Label",
    "Upload",
    // Added Suggest mode
  ];
  int selectedModeIndex = 0;

  // Selected image for preview (used in Upload mode)
  File? _selectedImageFile;
  // Captured file from camera (stored to avoid calling takePicture twice)
  File? _capturedFile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
    if (!useCamera || _isDisposed || _isInitializingCamera) return;
    _isInitializingCamera = true;
    try {
      final cameras = await availableCameras();
      if (_isDisposed || !mounted) return;
      final camera = widget.camera ?? cameras.first;
      final controller = CameraController(camera, ResolutionPreset.ultraHigh,
          enableAudio: false);
      await controller.initialize();
      if (_isDisposed || !mounted) {
        controller.dispose();
        return;
      }
      _controller = controller;
      setState(() {});
    } catch (e) {
      debugPrint('Camera init error: $e');
    } finally {
      _isInitializingCamera = false;
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    _controller = null;
    _scannerController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_isDisposed) return;

    if (state == AppLifecycleState.inactive) {
      // Free up memory when camera not active
      final controller = _controller;
      _controller = null;
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // Re-initialize the camera with a new controller
      if (_controller == null) {
        _initializeCamera();
      }
    }
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

  /// Scan image for barcodes and return the first barcode value found
  Future<String?> _scanBarcodeFromImage(String imagePath) async {
    final controller = MobileScannerController();
    try {
      final BarcodeCapture? result = await controller.analyzeImage(imagePath);
      if (result != null && result.barcodes.isNotEmpty) {
        final value = result.barcodes.first.rawValue;
        print('Barcode: $value');
        return value;
      }
      print('No barcode found in image');
      return null;
    } finally {
      await controller.dispose();
    }
  }

  /// Handle barcode mode capture and analysis
  Future<void> _captureAndAnalyzeBarcode() async {
    final recipeController = ref.read(recipeViewModelProvider.notifier);

    try {
      String? barcode;
      String? imagePath;

      final cameraCtrl = _controller;
      if (cameraCtrl != null && cameraCtrl.value.isInitialized) {
        // Capture from camera
        final XFile image = await cameraCtrl.takePicture();
        imagePath = image.path;

        // Pause camera preview and scanner animation after capture
        if (!_isDisposed && _controller == cameraCtrl) {
          try {
            await cameraCtrl.pausePreview();
          } catch (_) {}
        }
        _scannerController.stop();

        // Scan for barcode
        barcode = await _scanBarcodeFromImage(imagePath);
      } else {
        ref.read(toastProvider).showError('Camera not ready');
        return;
      }

      if (barcode == null || barcode.isEmpty) {
        // No barcode found
        _resumeCameraAndScanner();
        ref
            .read(toastProvider)
            .showError('No barcode found in image. Please try again.');
        return;
      }

      print('📊 Barcode detected: $barcode');

      // Call the API to analyze the barcode
      final success = await recipeController.analyzeByBarcode(barcode);

      if (success && mounted) {
        final state = ref.read(recipeViewModelProvider);
        if (state.analyzedRecipe != null) {
          // Navigate to result screen and wait for it to be popped
          await NavigationService.push(
            child: AnalyseResultDetail(state.analyzedRecipe!),
          );

          // Resume camera and scanner when user comes back
          if (mounted) {
            _resumeCameraAndScanner();
          }
        }
      } else if (mounted) {
        // Resume camera and scanner on failure
        _resumeCameraAndScanner();

        ref.read(toastProvider).showError('Failed to analyze barcode');
      }
    } catch (e) {
      print(e.toString());
      if (mounted) {
        _resumeCameraAndScanner();
        ref.read(toastProvider).showError('Error: ${e.toString()}');
      }
    }
  }

  bool isLoading = false;

  /// Capture image from camera or use test image
  Future<void> _captureAndAnalyze() async {
    final controller = ref.read(recipeViewModelProvider.notifier);

    try {
      http.MultipartFile imageFile;
      Uint8List imageBytes;

      // Check if "Upload" mode is selected (index 4)
      if (selectedModeIndex == 4) {
        // Open gallery to pick an image
        final ImagePicker picker = ImagePicker();
        final XFile? pickedImage = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 85,
        );

        if (pickedImage == null) {
          // User cancelled the picker
          return;
        }

        final File file = File(pickedImage.path);

        // Set the selected image for preview
        setState(() {
          _selectedImageFile = file;
        });

        // Pause scanner animation
        _scannerController.stop();

        imageBytes = await file.readAsBytes();

        // Compress the image
        final compressedBytes = await _compressImage(imageBytes);
        // final compressedBytes = imageBytes;

        imageFile = http.MultipartFile.fromBytes(
          'image',
          compressedBytes,
          filename: 'gallery_image.jpg',
          contentType: http_parser.MediaType('image', 'jpeg'),
        );
      } else if (useTestImage) {
        // Load image from assets for testing
        final ByteData data = await rootBundle.load(testImagePath);
        imageBytes = data.buffer.asUint8List();

        // Compress the image
        // final compressedBytes = await _compressImage(imageBytes);
        final compressedBytes = imageBytes;

        imageFile = http.MultipartFile.fromBytes(
          'image',
          compressedBytes,
          filename: 'test_image.jpg',
          contentType: http_parser.MediaType('image', 'jpeg'),
        );

        // Pause scanner animation for test image mode
        _scannerController.stop();
      } else if (_controller != null && _controller!.value.isInitialized) {
        // Capture from camera
        final cameraCtrl = _controller!;
        final XFile image = await cameraCtrl.takePicture();

        setState(() {
          isLoading = true;
        });

        // Pause camera preview and scanner animation after capture
        if (!_isDisposed && _controller == cameraCtrl) {
          try {
            await cameraCtrl.pausePreview();
          } catch (_) {}
        }
        _scannerController.stop();

        final File file = File(image.path);
        _capturedFile = file; // Store for later use
        imageBytes = await file.readAsBytes();

        // Compress the image
        // final compressedBytes = await _compressImage(imageBytes);
        final compressedBytes = imageBytes;

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

      // Call the appropriate API based on the selected mode
      bool success = false;
      File? capturedImageFile;

      // Store the File object for navigation
      if (selectedModeIndex == 4) {
        capturedImageFile = _selectedImageFile;
      } else if (!useTestImage && _capturedFile != null) {
        // Use the file from the first capture (don't call takePicture again)
        capturedImageFile = _capturedFile;
      } else if (useTestImage) {
        // For test image, write bytes to temp file
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/test_image.jpg');
        await tempFile.writeAsBytes(imageBytes);
        capturedImageFile = tempFile;
      }

      if (selectedModeIndex == 1) {
        // Suggest Mode
        success = await controller.suggestAndAnalyze(imageFile);

        if (success && mounted) {
          final state = ref.read(recipeViewModelProvider);
          if (state.suggestedRecipes != null &&
              state.suggestedRecipes!.isNotEmpty) {
            // Navigate to SuggestResultScreen
            await NavigationService.push(
              child: SuggestResultScreen(
                imageFile: capturedImageFile,
                suggestions: state.suggestedRecipes!,
              ),
            );

            // Resume camera and scanner when user comes back
            if (mounted) {
              _resumeCameraAndScanner();
            }
          }
        } else if (mounted) {
          _resumeCameraAndScanner();
          ref.read(toastProvider).showError('Failed to get suggestions');
        }
      } else if (selectedModeIndex == 3) {
        // Label Mode
        success = await controller.analyzeNutritionLabel(imageFile);

        if (success && mounted) {
          final state = ref.read(recipeViewModelProvider);
          if (state.analyzedRecipe != null) {
            await NavigationService.push(
              child: AnalyseResultDetail(state.analyzedRecipe!),
            );
            if (mounted) {
              _resumeCameraAndScanner();
            }
          }
        } else if (mounted) {
          _resumeCameraAndScanner();
          ref.read(toastProvider).showError('Failed to analyze label');
        }
      } else {
        // Food Scan, Recipe, Upload
        print("image file is $imageFile");
        success = await controller.analyzeRecipe(imageFile);

        if (success && mounted) {
          final state = ref.read(recipeViewModelProvider);
          if (state.analyzedRecipe != null) {
            await NavigationService.push(
              child: AnalyseResultDetail(state.analyzedRecipe!),
            );
            if (mounted) {
              _resumeCameraAndScanner();
            }
          }
        } else if (mounted) {
          _resumeCameraAndScanner();
          ref.read(toastProvider).showError('Failed to analyze recipe');
        }
      }
    } catch (e) {
      if (mounted) {
        // Resume camera and scanner on exception
        _resumeCameraAndScanner();

        ref.read(toastProvider).showError(
              'Error: ${e.toString()}',
            );
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Resume camera preview and scanner animation
  Future<void> _resumeCameraAndScanner() async {
    if (_isDisposed || !mounted) return;

    // Clear the selected image preview and captured file
    setState(() {
      _selectedImageFile = null;
      _capturedFile = null;
    });

    // Resume scanner animation
    if (!_isDisposed) {
      _scannerController.repeat(reverse: true);
    }

    // Completely re-initialize camera to ensure preview works fresh
    final oldController = _controller;
    _controller = null;
    if (mounted) setState(() {});

    try {
      await oldController?.dispose();
    } catch (_) {
      // Ignore errors during dispose
    }

    // Re-initialize
    if (!_isDisposed && mounted) {
      await _initializeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recipeViewModelProvider);

    return BlurryModalProgressHUD(
      inAsyncCall: state.isLoading || isLoading,
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

                      // 2. DARK OVERLAY WITH CUTOUT + CORNERS (hide in upload mode or when image selected)
                      if (selectedModeIndex != 4 && _selectedImageFile == null)
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

                      // 3. SCANNING LINE ANIMATION (hide in upload mode or when image selected)
                      if (selectedModeIndex != 4 && _selectedImageFile == null)
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
                      const SafeArea(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // _buildCircleButton(
                              //     Icons.arrow_back_ios_new, () {}),
                              SizedBox(width: 40),
                              Text(
                                "AI Camera",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              // Invisible icon to balance the row
                              SizedBox(width: 40),
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
    // Show selected image preview (when image is picked from gallery)
    if (_selectedImageFile != null) {
      return Image.file(
        _selectedImageFile!,
        fit: BoxFit.cover,
      );
    }

    // Show upload placeholder when Upload mode is selected
    if (selectedModeIndex == 4) {
      return _buildUploadPlaceholder();
    }

    // Show camera preview
    if (useCamera && _controller != null && _controller!.value.isInitialized) {
      return FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _controller!.value.previewSize!.height,
          height: _controller!.value.previewSize!.width,
          child: CameraPreview(_controller!),
        ),
      );
    } else {
      // Placeholder if camera is off or not ready
      return Image.network(
        'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?q=80&w=1000&auto=format&fit=crop',
        fit: BoxFit.cover,
      );
    }
  }

  /// Build the upload placeholder UI
  Widget _buildUploadPlaceholder() {
    return Container(
      color: const Color(0xFF1A1A1A),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.photo_library_outlined,
                size: 50,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Upload from Gallery",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Tap the button below to select\nan image from your gallery",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            Icon(
              Icons.arrow_downward_rounded,
              color: AppColors.primary.withOpacity(0.7),
              size: 30,
            ),
          ],
        ),
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
            onTap: () {
              if (selectedModeIndex == 2) {
                // Barcode Mode
                _captureAndAnalyzeBarcode();
              } else {
                // Other Modes (Food Scan, Recipe, Label, Upload)
                _captureAndAnalyze();
              }
            },
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
              color: const Color.fromRGBO(4, 4, 15, 0.6),
            ),
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: modes.asMap().entries.map((entry) {
                    int index = entry.key;
                    String mode = entry.value;
                    final isSelected = index == selectedModeIndex;
                    return GestureDetector(
                      onTap: () => setState(() => selectedModeIndex = index),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              mode,
                              style: TextStyle(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.white,
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
                  }).toList(),
                ),
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
