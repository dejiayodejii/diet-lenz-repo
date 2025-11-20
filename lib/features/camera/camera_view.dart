import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CameraView extends ConsumerStatefulWidget {
  const CameraView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CameraViewState();
}

class _CameraViewState extends ConsumerState<CameraView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera View'),
      ),
      body: const Center(
        child: Text('Camera functionality goes here'),
      ),
    );
  }
}