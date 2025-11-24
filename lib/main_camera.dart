import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Fetch cameras if you are running on a real device
  final cameras = await availableCameras();
  runApp(MyApp(camera: cameras.isNotEmpty ? cameras.first : null));
}

class MyApp extends StatelessWidget {
  final CameraDescription? camera;
  const MyApp({Key? key, this.camera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: AICameraScreen(camera: camera),
    );
  }
}

class AICameraScreen extends StatefulWidget {
  final CameraDescription? camera;
  const AICameraScreen({Key? key, this.camera}) : super(key: key);

  @override
  State<AICameraScreen> createState() => _AICameraScreenState();
}

class _AICameraScreenState extends State<AICameraScreen>
    with SingleTickerProviderStateMixin {
  
  // --- CONFIGURATION ---
  // Set this to TRUE to use the real camera (requires physical device)
  final bool useCamera = false; 
  
  CameraController? _controller;
  late AnimationController _scannerController;
  late Animation<double> _scannerAnimation;
  
  // Menu Items
  final List<String> modes = ["Food Scan", "Recipe", "Barcode", "Label", "Upload"];
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
    if (useCamera && widget.camera != null) {
      _controller = CameraController(widget.camera!, ResolutionPreset.high);
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

  @override
  Widget build(BuildContext context) {
    // Dimensions for the scan box
    final size = MediaQuery.of(context).size;
    final double scanBoxSize = size.width * 0.85;
    final double scanBoxTop = size.height * 0.2;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. CAMERA FEED OR PLACEHOLDER
          Positioned.fill(
            child: _buildCameraView(),
          ),

          // 2. DARK OVERLAY WITH CUTOUT + CORNERS
          CustomPaint(
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
                      top: _scannerAnimation.value * (scanBoxSize - 2),
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
                              color: Colors.white.withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            )
                          ]
                        ),
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCircleButton(Icons.arrow_back_ios_new, () {}),
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

          // 5. BOTTOM CONTROLS
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomControls(),
          ),
        ],
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
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black, Colors.transparent],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // SHUTTER BUTTON
          GestureDetector(
            onTap: () {
               print("Shutter Pressed");
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
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: modes.length,
              itemBuilder: (context, index) {
                final isSelected = index == selectedModeIndex;
                return GestureDetector(
                  onTap: () => setState(() => selectedModeIndex = index),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        Text(
                          modes[index],
                          style: TextStyle(
                            color: isSelected ? const Color(0xFFE86A33) : Colors.grey,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                        if (isSelected) ...[
                          const SizedBox(height: 4),
                          Container(width: 4, height: 4, decoration: const BoxDecoration(color: Color(0xFFE86A33), shape: BoxShape.circle))
                        ]
                      ],
                    ),
                  ),
                );
              },
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
      ..addRRect(RRect.fromRectAndRadius(scanBoxRect, const Radius.circular(20)));

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
    tl.arcToPoint(Offset(scanBoxRect.left + r, scanBoxRect.top), radius: Radius.circular(r));
    tl.lineTo(scanBoxRect.left + cornerLength, scanBoxRect.top);
    canvas.drawPath(tl, cornerPaint);

    // Top Right
    final Path tr = Path();
    tr.moveTo(scanBoxRect.right - cornerLength, scanBoxRect.top);
    tr.lineTo(scanBoxRect.right - r, scanBoxRect.top);
    tr.arcToPoint(Offset(scanBoxRect.right, scanBoxRect.top + r), radius: Radius.circular(r));
    tr.lineTo(scanBoxRect.right, scanBoxRect.top + cornerLength);
    canvas.drawPath(tr, cornerPaint);

    // Bottom Right
    final Path br = Path();
    br.moveTo(scanBoxRect.right, scanBoxRect.bottom - cornerLength);
    br.lineTo(scanBoxRect.right, scanBoxRect.bottom - r);
    br.arcToPoint(Offset(scanBoxRect.right - r, scanBoxRect.bottom), radius: Radius.circular(r));
    br.lineTo(scanBoxRect.right - cornerLength, scanBoxRect.bottom);
    canvas.drawPath(br, cornerPaint);

    // Bottom Left
    final Path bl = Path();
    bl.moveTo(scanBoxRect.left + cornerLength, scanBoxRect.bottom);
    bl.lineTo(scanBoxRect.left + r, scanBoxRect.bottom);
    bl.arcToPoint(Offset(scanBoxRect.left, scanBoxRect.bottom - r), radius: Radius.circular(r));
    bl.lineTo(scanBoxRect.left, scanBoxRect.bottom - cornerLength);
    canvas.drawPath(bl, cornerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}