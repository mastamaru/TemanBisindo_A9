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
  List<CameraDescription> _cameras = [];
  int _currentCameraIndex = 0;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // Perbarui metode _initializeCamera untuk menggunakan _currentCameraIndex
  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        throw Exception('No cameras available');
      }

      _controller = CameraController(
        _cameras[_currentCameraIndex],
        ResolutionPreset.medium,
        fps: 30,
        enableAudio: false,
      );

      _initializeControllerFuture = _controller!.initialize();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

// Fungsi untuk membalik kamera
  Future<void> flipCamera() async {
    if (_cameras.length < 2) {
      print('Not enough cameras to flip');
      return;
    }

    // Tentukan indeks kamera berikutnya
    int newCameraIndex = (_currentCameraIndex + 1) % _cameras.length;

    // Hentikan dan dispose controller saat ini
    if (_controller != null) {
      await _controller!.dispose();
    }

    // Perbarui indeks kamera saat ini
    setState(() {
      _currentCameraIndex = newCameraIndex;
    });

    // Inisialisasi ulang controller dengan kamera baru
    _controller = CameraController(
      _cameras[_currentCameraIndex],
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
