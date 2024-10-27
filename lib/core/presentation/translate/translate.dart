// Translate.dart
import 'dart:async';

import 'package:flutter/material.dart';

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
  static const int maxDuration = 10; // Durasi maksimum dalam detik

  @override
  void dispose() {
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
                  height: 164,
                  width: 384,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white),
                    color: Colors.white,
                  ),
                  child: _videoPath != null
                      ? Center(
                          child: Text(
                            'Video tersimpan di:\n$_videoPath',
                            textAlign: TextAlign.center,
                          ),
                        )
                      : null,
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
