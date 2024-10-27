// Translate.dart
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
  String? _videoPath;
  bool _isRecording = false;

  void _toggleRecording() async {
    if (!_isRecording) {
      await _cameraKey.currentState?.startRecording();
      setState(() {
        _isRecording = true;
      });
    } else {
      await _cameraKey.currentState?.stopRecording();
      setState(() {
        _isRecording = false;
      });
    }
  }

  void _onVideoRecorded(String path) {
    setState(() {
      _videoPath = path;
    });
    // Di sini Anda bisa menambahkan logika untuk memproses video
    print('Video recorded at: $_videoPath');
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
                      onVideoRecorded: _onVideoRecorded,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                FloatingActionButton(
                  onPressed: _toggleRecording,
                  child: Icon(
                      _isRecording ? Icons.stop : Icons.fiber_manual_record),
                  backgroundColor: _isRecording ? Colors.red : Colors.white,
                ),
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
