import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

import '../../widget/cameraScreen.dart';

class Translate extends StatefulWidget {
  const Translate({super.key});

  @override
  State<Translate> createState() => _TranslateState();
}

class _TranslateState extends State<Translate> {
  final GlobalKey<cameraScreenState> _cameraKey =
      GlobalKey<cameraScreenState>();
  bool _isRecording = false;
  String? _videoPath;
  int _recordingDuration = 0;
  Timer? _timer;
  static const int maxDuration = 3;
  bool _isProcessing = false;
  VideoPlayerController? _videoPlayerController;
  String _predictedLabel = '';
  double _progress = 1.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _videoPlayerController = null;
    _timer?.cancel();
    super.dispose();
  }

  void _toggleRecording() async {
    if (!_isRecording) {
      await _cameraKey.currentState?.startRecording();
      setState(() {
        _isRecording = true;
        _recordingDuration = 0;
        _progress = 1.0; // Reset progress saat mulai merekam
      });
      _startTimer();
    } else {
      await _stopRecording();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordingDuration++;
        _progress = 1 - (_recordingDuration / maxDuration);
        if (_recordingDuration >= maxDuration) {
          _stopRecording();
        }
      });
    });
  }

  Future<void> _stopRecording() async {
    await _cameraKey.currentState?.stopRecording();
    setState(() {
      _isRecording = false;
      _progress = 0.0;
    });
    _stopTimer();
    if (_videoPath != null) {
      await processVideo();
    }
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    _recordingDuration = 0;
  }

  Widget _buildRecordingIndicator() {
    return Column(
      mainAxisSize: MainAxisSize.min, // Menghindari ekspansi vertikal
      children: [
        SizedBox(
          height: 4,
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            // Circular Progress Indicator dengan ukuran yang lebih kecil
            SizedBox(
              width: 60, // Ukuran dikurangi
              height: 60, // Ukuran dikurangi
              child: CircularProgressIndicator(
                value: _isRecording ? _progress : 0.0,
                strokeWidth: 4, // Ketebalan garis dikurangi
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                backgroundColor: Colors.white.withOpacity(0.3),
              ),
            ),
            // Tombol Record dengan Icon yang lebih kecil
            GestureDetector(
              onTap: _toggleRecording,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _isRecording ? Colors.red : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red, width: 2),
                ),
                child: Icon(
                  _isRecording ? Icons.stop : Icons.fiber_manual_record,
                  color: _isRecording ? Colors.white : Colors.red,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> processVideo() async {
    if (_videoPath == null) {
      print('No video path found');
      return;
    }

    setState(() {
      _isProcessing = true;
      _predictedLabel = '';
    });

    final videoFile = File(_videoPath!);
    if (!videoFile.existsSync()) {
      print('Video file not found');
      setState(() {
        _isProcessing = false;
      });
      return;
    }

    print('Processing video: ${videoFile.path}');
    final videoSizeInBytes = await videoFile.length();
    final videoSizeInMB = videoSizeInBytes / (1024 * 1024);
    print("Video file size: ${videoSizeInMB.toStringAsFixed(2)} MB");

    // Inisialisasi VideoPlayerController (Opsional, jika Anda ingin memutar video)
    _videoPlayerController = VideoPlayerController.file(videoFile);
    await _videoPlayerController!.initialize();
    await _videoPlayerController!.dispose();
    _videoPlayerController = null;

    try {
      // Kirim video ke server
      final uri = Uri.parse(
          'https://4af5-2405-2c40-3-0-142a-827e-c132-a327.ngrok-free.app/process_video'); // Ganti <SERVER_IP> dengan alamat server Anda
      var request = http.MultipartRequest('POST', uri);
      request.files
          .add(await http.MultipartFile.fromPath('video', videoFile.path));

      print('Uploading video...');
      var streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        var response = await http.Response.fromStream(streamedResponse);
        var jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        if (jsonResponse['status'] == 'success') {
          setState(() {
            _predictedLabel = jsonResponse['predicted_label'] ?? '';
          });
          print('Processing completed. Landmarks received.');
          print('Predicted Label: $_predictedLabel');
        } else {
          print('Error from server: ${jsonResponse['error']}');
        }
      } else {
        print(
            'Server responded with status code: ${streamedResponse.statusCode}');
        var response = await http.Response.fromStream(streamedResponse);
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error uploading video: $e');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Widget _buildPredictiondisplay() {
    if (_isProcessing) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text('Processing video...'),
          ],
        ),
      );
    }

    if (_predictedLabel.isEmpty) {
      return const Center(
        child: Text('Model prediction failed'),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            '$_predictedLabel',
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5B8BDF),
      appBar: null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 15,
            ),
            Column(
              children: [
                const Text(
                  "Menerjemahkan..",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 27,
                    fontFamily: 'Ubuntu',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  height: 404,
                  width: 384 * 3 / 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white),
                    color: Colors.white,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: cameraScreen(
                      key: _cameraKey,
                      onVideoRecorded: (path) {
                        setState(() {
                          _videoPath = path;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                _buildRecordingIndicator(),
                const Text(
                  "Hasil Terjemahan:",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 27,
                    fontFamily: 'Ubuntu',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height:
                      200, // Disesuaikan untuk menampilkan lebih banyak data
                  width: 384,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: _videoPath != null
                        ? _buildPredictiondisplay()
                        : const Center(child: Text('No video processed')),
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Kembali",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Ubuntu',
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
