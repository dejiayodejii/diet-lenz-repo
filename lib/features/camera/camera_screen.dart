import 'dart:io';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/core/constants/app_colors.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/core/services/toast_service.dart';
import 'package:diet_lenz/core/utils/loader.dart';
import 'package:diet_lenz/features/auth/controller/auth_viewmodel.dart';
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

/// Bakes EXIF orientation into the pixels before an image is uploaded.
///
/// Camera JPEGs can store portrait orientation as metadata while leaving the
/// pixel data sideways. Normalizing here keeps backend decoders and returned
/// base64 images from interpreting the same capture differently.
Uint8List prepareImageForUpload(Uint8List imageBytes) {
  var image = img.decodeImage(imageBytes);
  if (image == null) return imageBytes;

  image = img.bakeOrientation(image);

  if (image.width > 2048 || image.height > 2048) {
    image = img.copyResize(
      image,
      width: image.width > image.height ? 2048 : null,
      height: image.height > image.width ? 2048 : null,
    );
  }

  final preparedBytes = Uint8List.fromList(img.encodeJpg(image, quality: 92));
  debugPrint(
    'Image preparation: ${imageBytes.length} bytes -> '
    '${preparedBytes.length} bytes (${image.width}x${image.height})',
  );
  return preparedBytes;
}

Offset normalizedCameraPoint(Offset localPosition, Size viewSize) {
  if (viewSize.width <= 0 || viewSize.height <= 0) {
    return const Offset(0.5, 0.5);
  }
  return Offset(
    (localPosition.dx / viewSize.width).clamp(0.0, 1.0),
    (localPosition.dy / viewSize.height).clamp(0.0, 1.0),
  );
}

class AICameraScreen extends ConsumerStatefulWidget {
  final CameraDescription? camera;
  const AICameraScreen({super.key, this.camera});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AICameraScreenState();
}

class _AICameraScreenState extends ConsumerState<AICameraScreen>
    with WidgetsBindingObserver {
  // --- CONFIGURATION ---
  // Set this to TRUE to use the real camera (requires physical device)
  final bool useCamera = true;

  // Set this to TRUE to use test image from assets instead of camera
  final bool useTestImage = false; // Change to true for testing with assets
  final String testImagePath = AppImages.salad; // Path to your test image

  CameraController? _controller;
  bool _isDisposed = false;
  bool _isInitializingCamera = false;
  Offset _lastFocusPoint = const Offset(0.5, 0.5);
  Offset? _focusIndicatorPosition;
  int _focusRequestId = 0;

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

  bool get _isBarcodeMode => selectedModeIndex == 2;
  bool get _isLabelMode => selectedModeIndex == 3;

  // Kept in memory and keyed by the active authentication token, so reopening
  // this screen does not repeat a guide, while a new login session starts over.
  static final Map<int, Set<int>> _dismissedGuideModesBySession = {};

  int get _guideSessionKey {
    final authResponse = ref.read(authViewModelProvider).authResponse;
    return Object.hash(authResponse?.userId, authResponse?.accessToken);
  }

  Set<int> get _dismissedGuideModesThisSession =>
      _dismissedGuideModesBySession.putIfAbsent(
        _guideSessionKey,
        () => <int>{},
      );

  bool get _shouldShowCurrentGuide =>
      selectedModeIndex < 4 &&
      !_dismissedGuideModesThisSession.contains(selectedModeIndex);

  // Selected image for preview (used in Upload mode)
  File? _selectedImageFile;
  // Captured file from camera (stored to avoid calling takePicture twice)
  File? _capturedFile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    if (!useCamera || _isDisposed || _isInitializingCamera) return;
    _isInitializingCamera = true;
    try {
      final cameras = await availableCameras();
      if (_isDisposed || !mounted) return;
      final camera = widget.camera ?? cameras.first;
      final controller = CameraController(
        camera,
        ResolutionPreset.max,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      await controller.initialize();
      await controller.lockCaptureOrientation(DeviceOrientation.portraitUp);
      await _setFocusAndExposure(
        controller,
        const Offset(0.5, 0.5),
      );
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

  Future<void> _setFocusAndExposure(
    CameraController controller,
    Offset point,
  ) async {
    try {
      await controller.setFocusMode(FocusMode.auto);
      await controller.setFocusPoint(point);
    } on CameraException catch (error) {
      debugPrint('Camera focus is unavailable: ${error.code}');
    }

    try {
      await controller.setExposureMode(ExposureMode.auto);
      await controller.setExposurePoint(point);
    } on CameraException catch (error) {
      debugPrint('Camera exposure point is unavailable: ${error.code}');
    }
  }

  Future<void> _focusBeforeCapture(CameraController controller) async {
    await _setFocusAndExposure(controller, _lastFocusPoint);
    await Future<void>.delayed(const Duration(milliseconds: 350));
  }

  Future<void> _handleTapToFocus(
    TapDownDetails details,
    Size viewSize,
  ) async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    final requestId = ++_focusRequestId;
    final point = normalizedCameraPoint(details.localPosition, viewSize);
    _lastFocusPoint = point;
    setState(() => _focusIndicatorPosition = details.localPosition);

    await _setFocusAndExposure(controller, point);
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (mounted && requestId == _focusRequestId) {
      setState(() => _focusIndicatorPosition = null);
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    _controller = null;
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
        await _focusBeforeCapture(cameraCtrl);
        final XFile image = await cameraCtrl.takePicture();
        imagePath = image.path;

        // Pause camera preview after capture.
        if (!_isDisposed && _controller == cameraCtrl) {
          try {
            await cameraCtrl.pausePreview();
          } catch (_) {}
        }
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

        imageBytes = await file.readAsBytes();

        final preparedBytes = prepareImageForUpload(imageBytes);

        imageFile = http.MultipartFile.fromBytes(
          'image',
          preparedBytes,
          filename: 'gallery_image.jpg',
          contentType: http_parser.MediaType('image', 'jpeg'),
        );
      } else if (useTestImage) {
        // Load image from assets for testing
        final ByteData data = await rootBundle.load(testImagePath);
        imageBytes = data.buffer.asUint8List();

        final preparedBytes = prepareImageForUpload(imageBytes);

        imageFile = http.MultipartFile.fromBytes(
          'image',
          preparedBytes,
          filename: 'test_image.jpg',
          contentType: http_parser.MediaType('image', 'jpeg'),
        );
      } else if (_controller != null && _controller!.value.isInitialized) {
        // Capture from camera
        final cameraCtrl = _controller!;
        await _focusBeforeCapture(cameraCtrl);
        final XFile image = await cameraCtrl.takePicture();

        setState(() {
          isLoading = true;
        });

        // Pause camera preview after capture.
        if (!_isDisposed && _controller == cameraCtrl) {
          try {
            await cameraCtrl.pausePreview();
          } catch (_) {}
        }
        final File file = File(image.path);
        _capturedFile = file; // Store for later use
        imageBytes = await file.readAsBytes();

        final preparedBytes = prepareImageForUpload(imageBytes);

        imageFile = http.MultipartFile.fromBytes(
          'image',
          preparedBytes,
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

  /// Resume the camera preview after returning from a result screen.
  Future<void> _resumeCameraAndScanner() async {
    if (_isDisposed || !mounted) return;

    // Clear the selected image preview and captured file
    setState(() {
      _selectedImageFile = null;
      _capturedFile = null;
    });

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
    final isCameraMode = selectedModeIndex < 4 && _selectedImageFile == null;
    final showGuide = isCameraMode && _shouldShowCurrentGuide;
    final showLiveCamera = isCameraMode && !showGuide;

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
                  final double scanBoxTop =
                      (constraints.maxHeight * 0.15).clamp(88.0, 120.0);

                  return Stack(
                    children: [
                      // 1. CAMERA FEED OR PLACEHOLDER
                      Positioned.fill(
                        child: isCameraMode
                            ? const ColoredBox(color: Colors.black)
                            : _buildCameraView(),
                      ),

                      if (showLiveCamera)
                        Positioned(
                          top: scanBoxTop,
                          left: (size.width - scanBoxSize) / 2,
                          width: scanBoxSize,
                          height: scanBoxSize,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: _buildCameraView(),
                          ),
                        ),

                      // 2. DARK OVERLAY WITH CUTOUT + CORNERS
                      if (showLiveCamera)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: CustomPaint(
                              painter: ScannerOverlayPainter(
                                scanBoxRect: Rect.fromLTWH(
                                  (size.width - scanBoxSize) / 2,
                                  scanBoxTop,
                                  scanBoxSize,
                                  scanBoxSize,
                                ),
                                bottomCornerColor: selectedModeIndex == 1
                                    ? const Color(0xFF19A7FF)
                                    : null,
                              ),
                              child: Container(),
                            ),
                          ),
                        ),

                      if (showGuide)
                        Positioned(
                          top: scanBoxTop,
                          left: (size.width - scanBoxSize) / 2,
                          width: scanBoxSize,
                          child: _buildAssetGuide(scanBoxSize),
                        ),

                      if (showLiveCamera)
                        Positioned(
                          top: scanBoxTop + scanBoxSize + 24,
                          left: 32,
                          right: 32,
                          child: const IgnorePointer(
                            child: Text(
                              'Tap inside the frame to focus',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),

                      // 4. TOP BAR
                      SafeArea(child: _buildTopBar()),
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

  Widget _buildTopBar() {
    final title = _isBarcodeMode
        ? 'Barcode Scanner'
        : _isLabelMode
            ? 'Label Scanner'
            : 'AI Camera';

    // if (_usesScannerGuide) {
    //   return Padding(
    //     padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
    //     child: Row(
    //       children: [
    //         GestureDetector(
    //           onTap: () => Navigator.of(context).maybePop(),
    //           child: Container(
    //             width: 50,
    //             height: 50,
    //             decoration: BoxDecoration(
    //               color: Colors.white.withValues(alpha: 0.12),
    //               shape: BoxShape.circle,
    //             ),
    //             child: const Icon(
    //               Icons.arrow_back_ios_new_rounded,
    //               color: Colors.white,
    //               size: 20,
    //             ),
    //           ),
    //         ),
    //         const SizedBox(width: 26),
    //         Flexible(
    //           child: Text(
    //             title,
    //             maxLines: 1,
    //             overflow: TextOverflow.ellipsis,
    //             style: const TextStyle(
    //               color: Colors.white,
    //               fontSize: 28,
    //               fontWeight: FontWeight.w700,
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
    // }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 40),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildAssetGuide(double frameSize) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: frameSize,
          height: frameSize,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: Image.asset(
                  _currentGuideAsset,
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                top: -12,
                right: -12,
                child: Semantics(
                  button: true,
                  label: 'Dismiss camera guide',
                  child: GestureDetector(
                    onTap: _dismissCurrentGuide,
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.82),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white38),
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          _currentGuideDescription,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            height: 1.35,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  String get _currentGuideAsset => switch (selectedModeIndex) {
        0 => AppImages.foodScanGuide,
        1 => AppImages.recipeGuide,
        2 => AppImages.barcodeGuide,
        3 => AppImages.labelGuide,
        _ => AppImages.foodScanGuide,
      };

  String get _currentGuideDescription => switch (selectedModeIndex) {
        0 => 'Point your camera at any meal to instantly get calories and '
            'macros - no searching required.',
        1 => 'Scan the ingredients you have on hand to get recipe ideas with '
            'full nutrition included.',
        2 => 'Align the barcode within the frame.',
        3 => 'Get nutrition details from any label to track your intake '
            'accurately.',
        _ => '',
      };

  void _dismissCurrentGuide() {
    setState(() {
      _dismissedGuideModesThisSession.add(selectedModeIndex);
    });
  }

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
      return LayoutBuilder(
        builder: (context, constraints) {
          final viewSize = Size(constraints.maxWidth, constraints.maxHeight);
          final focusPosition = _focusIndicatorPosition;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (details) => _handleTapToFocus(details, viewSize),
            child: Stack(
              children: [
                Positioned.fill(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller!.value.previewSize!.height,
                      height: _controller!.value.previewSize!.width,
                      child: CameraPreview(_controller!),
                    ),
                  ),
                ),
                if (focusPosition != null)
                  Positioned(
                    left: focusPosition.dx - 32,
                    top: focusPosition.dy - 32,
                    child: IgnorePointer(
                      child: Semantics(
                        label: 'Camera focus point',
                        child: Container(
                          width: 64,
                          height: 64,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.08),
                            border: Border.all(
                              color: AppColors.primary,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
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
      padding: const EdgeInsets.only(bottom: 20, top: 20),
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
          const SizedBox(height: 20),

          // MODE SELECTOR
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 64,
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
                      onTap: () => setState(() {
                        selectedModeIndex = index;
                      }),
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
  final Color? bottomCornerColor;
  final double cornerLength = 30.0;
  final double cornerWidth = 5.0;

  ScannerOverlayPainter({
    required this.scanBoxRect,
    this.bottomCornerColor,
  });

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
    final bottomCornerPaint = Paint()
      ..color = bottomCornerColor ?? Colors.white
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
    canvas.drawPath(br, bottomCornerPaint);

    // Bottom Left
    final Path bl = Path();
    bl.moveTo(scanBoxRect.left + cornerLength, scanBoxRect.bottom);
    bl.lineTo(scanBoxRect.left + r, scanBoxRect.bottom);
    bl.arcToPoint(Offset(scanBoxRect.left, scanBoxRect.bottom - r),
        radius: Radius.circular(r));
    bl.lineTo(scanBoxRect.left, scanBoxRect.bottom - cornerLength);
    canvas.drawPath(bl, bottomCornerPaint);
  }

  @override
  bool shouldRepaint(covariant ScannerOverlayPainter oldDelegate) {
    return oldDelegate.scanBoxRect != scanBoxRect ||
        oldDelegate.bottomCornerColor != bottomCornerColor;
  }
}

class RecipeGuideOutlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF19A7FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final outline = Path()
      ..moveTo(1.5, size.height / 2)
      ..lineTo(1.5, size.height - 20)
      ..quadraticBezierTo(1.5, size.height - 1.5, 20, size.height - 1.5)
      ..lineTo(size.width - 20, size.height - 1.5)
      ..quadraticBezierTo(
        size.width - 1.5,
        size.height - 1.5,
        size.width - 1.5,
        size.height - 20,
      )
      ..lineTo(size.width - 1.5, size.height / 2);
    canvas.drawPath(outline, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BarcodeGuidePainter extends CustomPainter {
  BarcodeGuidePainter({required this.showBarcodeSample});

  final bool showBarcodeSample;

  @override
  void paint(Canvas canvas, Size size) {
    if (showBarcodeSample) {
      final scrimPaint = Paint()..color = Colors.black.withValues(alpha: 0.34);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          const Radius.circular(32),
        ),
        scrimPaint,
      );

      final highlightPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.06)
        ..strokeWidth = 1;
      canvas.drawLine(
        Offset(size.width * 0.08, size.height * 0.48),
        Offset(size.width * 0.92, size.height * 0.48),
        highlightPaint,
      );

      _drawBarcode(canvas, size);
    }

    _drawFrameCorners(canvas, size);
  }

  void _drawBarcode(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black;
    final barcodeHeight = size.height * 0.25;
    final top = size.height * 0.375;
    final left = size.width * 0.22;
    final widths = <double>[5, 3, 6, 2, 8, 4, 5, 2, 7, 3, 4, 6, 3, 8, 5];
    var x = left;

    for (var i = 0; i < widths.length; i++) {
      final barWidth = widths[i];
      canvas.drawRect(
        Rect.fromLTWH(x, top, barWidth, barcodeHeight),
        paint,
      );
      x += barWidth + (i.isEven ? 7 : 4);
    }
  }

  void _drawFrameCorners(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.square;

    const radius = 28.0;
    final length = size.width * 0.26;

    void drawCorner(Path path) => canvas.drawPath(path, paint);

    final tl = Path()
      ..moveTo(0, size.height * 0.31)
      ..lineTo(0, radius)
      ..arcToPoint(
        const Offset(radius, 0),
        radius: const Radius.circular(radius),
      )
      ..lineTo(length, 0);
    drawCorner(tl);

    final tr = Path()
      ..moveTo(size.width - length, 0)
      ..lineTo(size.width - radius, 0)
      ..arcToPoint(
        Offset(size.width, radius),
        radius: const Radius.circular(radius),
      )
      ..lineTo(size.width, size.height * 0.31);
    drawCorner(tr);

    final br = Path()
      ..moveTo(size.width, size.height * 0.69)
      ..lineTo(size.width, size.height - radius)
      ..arcToPoint(
        Offset(size.width - radius, size.height),
        radius: const Radius.circular(radius),
      )
      ..lineTo(size.width - length, size.height);
    drawCorner(br);

    final bl = Path()
      ..moveTo(length, size.height)
      ..lineTo(radius, size.height)
      ..arcToPoint(
        Offset(0, size.height - radius),
        radius: const Radius.circular(radius),
      )
      ..lineTo(0, size.height * 0.69);
    drawCorner(bl);
  }

  @override
  bool shouldRepaint(covariant BarcodeGuidePainter oldDelegate) {
    return oldDelegate.showBarcodeSample != showBarcodeSample;
  }
}

class NutritionLabelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final backgroundPaint = Paint()..color = Colors.white;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(5)),
      backgroundPaint,
    );

    final titlePainter = TextPainter(
      text: const TextSpan(
        text: 'Nutrition Facts',
        style: TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.w800,
          letterSpacing: 0,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout(maxWidth: size.width - 20);
    titlePainter.paint(canvas, const Offset(10, 8));

    final thinPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1;
    final thickPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 6;

    _drawSmallText(canvas, 'Serving Size oz.', Offset(10, size.height * 0.16),
        size.width - 20);
    _drawSmallText(canvas, 'Serving Per Container',
        Offset(10, size.height * 0.21), size.width - 20);
    canvas.drawLine(
      Offset(8, size.height * 0.275),
      Offset(size.width - 8, size.height * 0.275),
      thickPaint,
    );
    _drawSmallText(canvas, 'Amount Per Serving:',
        Offset(10, size.height * 0.305), size.width - 20);
    canvas.drawLine(
      Offset(8, size.height * 0.365),
      Offset(size.width - 8, size.height * 0.365),
      thinPaint,
    );
    _drawSmallText(
        canvas, 'Calories', Offset(10, size.height * 0.39), size.width * 0.42);
    _drawSmallText(canvas, 'Calories From Fat',
        Offset(size.width * 0.43, size.height * 0.39), size.width * 0.48);
    canvas.drawLine(
      Offset(8, size.height * 0.455),
      Offset(size.width - 8, size.height * 0.455),
      thickPaint,
    );
    _drawSmallText(canvas, '% Daily value*',
        Offset(size.width * 0.64, size.height * 0.475), size.width * 0.3);

    final rows = [
      'Total Fat',
      '  Saturated Fat',
      '  Trans Fat',
      'Cholesterol',
      'Sodium',
      'Total Carbohydrate',
      '  Dietary Fiber',
      '  Sugars',
      'Protein',
    ];
    final startY = size.height * 0.535;
    final rowHeight = size.height * 0.061;

    for (var i = 0; i < rows.length; i++) {
      final y = startY + (i * rowHeight);
      _drawSmallText(canvas, rows[i], Offset(10, y), size.width * 0.62);
      if (i < rows.length - 1) {
        _drawSmallText(
            canvas, '%', Offset(size.width * 0.86, y), size.width * 0.08);
        canvas.drawLine(
          Offset(8, y + rowHeight * 0.78),
          Offset(size.width - 8, y + rowHeight * 0.78),
          thinPaint,
        );
      }
    }

    canvas.drawLine(
      Offset(8, size.height - 8),
      Offset(size.width - 8, size.height - 8),
      thickPaint,
    );
  }

  void _drawSmallText(
    Canvas canvas,
    String text,
    Offset offset,
    double maxWidth,
  ) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 9.5,
          height: 1,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout(maxWidth: maxWidth);
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
