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
  static const int maxDuration = 10;
  List<Map<String, dynamic>> _landmarks = [];
  bool _isProcessing = false;
  VideoPlayerController? _videoPlayerController;

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

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_recordingDuration < maxDuration) {
          _recordingDuration++;
        } else {
          _stopRecording();
        }
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    _recordingDuration = 0;
  }

  Future<void> _stopRecording() async {
    await _cameraKey.currentState?.stopRecording();
    setState(() {
      _isRecording = false;
    });
    _stopTimer();
  }

  void _toggleRecording() async {
    if (!_isRecording) {
      await _cameraKey.currentState?.startRecording();
      setState(() {
        _isRecording = true;
        _recordingDuration = 0;
      });
      _startTimer();
    } else {
      await _stopRecording();
      if (_videoPath != null) {
        await processVideo();
      }
    }
  }

  String _formatDuration() {
    final remaining = maxDuration - _recordingDuration;
    return '${remaining.toString().padLeft(2, '0')}s';
  }

  Widget _buildRecordingIndicator() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Tombol Record dengan Progress Indicator
            SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(
                value: _recordingDuration / maxDuration,
                color: Colors.red,
                backgroundColor: Colors.white,
                strokeWidth: 4,
              ),
            ),
            FloatingActionButton(
              onPressed: _toggleRecording,
              child: Icon(
                _isRecording ? Icons.stop : Icons.fiber_manual_record,
                size: 30,
              ),
              backgroundColor: _isRecording ? Colors.red : Colors.white,
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
      _landmarks.clear();
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
          'https://dc2a-2001-448a-404a-1461-d1d3-4c9c-348d-c8b8.ngrok-free.app/process_video'); // Ganti <SERVER_IP> dengan alamat server Anda
      var request = http.MultipartRequest('POST', uri);
      request.files
          .add(await http.MultipartFile.fromPath('video', videoFile.path));

      print('Uploading video...');
      var streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        var response = await http.Response.fromStream(streamedResponse);
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          setState(() {
            _landmarks =
                List<Map<String, dynamic>>.from(jsonResponse['results']);
          });
          print('Processing completed. Landmarks received.');
        } else {
          print('Error from server: ${jsonResponse['error']}');
        }
      } else {
        print(
            'Server responded with status code: ${streamedResponse.statusCode}');
      }
    } catch (e) {
      print('Error uploading video: $e');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Widget _buildLandmarksDisplay() {
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

    if (_landmarks.isEmpty) {
      return const Center(
        child: Text('No landmarks detected'),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          for (var frame in _landmarks.cast<Map<String, dynamic>>())
            Card(
              margin: const EdgeInsets.all(4),
              child: ExpansionTile(
                title: Text('Frame ${frame['frame_index'] + 1}'),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (frame['landmarks']['left_hand'] != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Left Hand:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              for (var i = 0;
                                  i < frame['landmarks']['left_hand'].length;
                                  i += 3)
                                Text(
                                  'Landmark ${i ~/ 3}: (${frame['landmarks']['left_hand'][i].toStringAsFixed(2)}, '
                                  '${frame['landmarks']['left_hand'][i + 1].toStringAsFixed(2)}, '
                                  '${frame['landmarks']['left_hand'][i + 2].toStringAsFixed(2)})',
                                  style: const TextStyle(fontSize: 12),
                                ),
                            ],
                          ),
                        const SizedBox(height: 10),
                        if (frame['landmarks']['right_hand'] != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Right Hand:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              for (var i = 0;
                                  i < frame['landmarks']['right_hand'].length;
                                  i += 3)
                                Text(
                                  'Landmark ${i ~/ 3}: (${frame['landmarks']['right_hand'][i].toStringAsFixed(2)}, '
                                  '${frame['landmarks']['right_hand'][i + 1].toStringAsFixed(2)}, '
                                  '${frame['landmarks']['right_hand'][i + 2].toStringAsFixed(2)})',
                                  style: const TextStyle(fontSize: 12),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
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
                const SizedBox(height: 25),
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
                  child: _videoPath != null
                      ? _buildLandmarksDisplay()
                      : const Center(child: Text('No video processed')),
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
