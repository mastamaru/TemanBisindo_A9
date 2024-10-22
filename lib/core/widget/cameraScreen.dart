import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class cameraScreen extends StatefulWidget {
  const cameraScreen({Key? key}) : super(key: key);

  @override
  State<cameraScreen> createState() => _cameraScreenState();
}

class _cameraScreenState extends State<cameraScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
      fps: 30,
      enableAudio: false,
    );

    _initializeControllerFuture = _controller!.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
              aspectRatio: 3 / 4, child: CameraPreview(_controller!));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
