import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';

import '../models/gestur_models.dart';

class VideoModal extends StatefulWidget {
  final GesturModel gestur;

  const VideoModal({Key? key, required this.gestur}) : super(key: key);

  @override
  _VideoModalState createState() => _VideoModalState();
}

class _VideoModalState extends State<VideoModal> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeVideo();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> initializeVideo() async {
    try {
      final fileInfo =
          await DefaultCacheManager().getFileFromCache(widget.gestur.linkVideo);
      final file = fileInfo?.file ??
          await DefaultCacheManager().getSingleFile(widget.gestur.linkVideo);

      _controller = VideoPlayerController.file(file);
      await _controller!.initialize();
      _controller!.setLooping(true);
      _controller!.setVolume(0);
      _controller!.play(); // Auto-play when modal opens

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('Error initializing video: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.gestur.terjemahan,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Ubuntu',
              ),
            ),
            SizedBox(height: 16),
            _isInitialized
                ? AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  )
                : Center(child: CircularProgressIndicator()),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _controller?.pause();
                Navigator.of(context).pop();
              },
              child: Text('Tutup'),
            ),
          ],
        ),
      ),
    );
  }
}
