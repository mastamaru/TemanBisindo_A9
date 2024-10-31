import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class cameraScreen extends StatefulWidget {
  final Function(String)? onVideoRecorded;

  const cameraScreen({Key? key, this.onVideoRecorded}) : super(key: key);

  @override
  State<cameraScreen> createState() => cameraScreenState();
}

class cameraScreenState extends State<cameraScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.last;

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

  Future<void> startRecording() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    if (_isRecording) {
      return;
    }

    try {
      // Dapatkan direktori temporary untuk menyimpan video
      final Directory tempDir = await getTemporaryDirectory();
      final String tempPath = tempDir.path;

      await _controller!.startVideoRecording();

      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      print('Error starting video recording: $e');
    }
  }

  Future<void> stopRecording() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    if (!_isRecording) {
      return;
    }

    try {
      final XFile video = await _controller!.stopVideoRecording();
      setState(() {
        _isRecording = false;
      });

      // Panggil callback dengan path video
      if (widget.onVideoRecorded != null) {
        print('Video recorded at: ${video.path}');
        widget.onVideoRecorded!(video.path);
      }
    } catch (e) {
      print('Error stopping video recording: $e');
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
            aspectRatio: 3 / 4,
            child: CameraPreview(_controller!),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
