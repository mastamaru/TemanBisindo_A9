import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
import 'package:temanbisindoa9/core/models/gestur_models.dart';
import 'package:temanbisindoa9/core/services/video_player_manager.dart';
import 'package:video_player/video_player.dart';

class GesturCard extends StatefulWidget {
  final GesturModel gestur;

  const GesturCard({Key? key, required this.gestur}) : super(key: key);

  @override
  _GesturCardState createState() => _GesturCardState();
}

class _GesturCardState extends State<GesturCard> {
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

  @override
  void didUpdateWidget(GesturCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Jika gestur berubah, inisialisasi ulang video
    if (oldWidget.gestur != widget.gestur) {
      initializeVideo();
    }
  }

  Future<void> initializeVideo() async {
    // Hapus controller yang lama jika ada
    if (_controller != null) {
      await _controller!.dispose();
    }

    try {
      final fileInfo =
          await DefaultCacheManager().getFileFromCache(widget.gestur.linkVideo);
      final file = fileInfo?.file ??
          await DefaultCacheManager().getSingleFile(widget.gestur.linkVideo);

      _controller = VideoPlayerController.file(file);
      await _controller!.initialize();
      _controller!.setLooping(true);
      _controller!.setVolume(0);

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('Error initializing video: $e');
    }
  }

  void _togglePlayPause(VideoPlayerManager manager) {
    if (_controller == null) return;

    if (manager.isCurrentlyPlaying(widget.gestur.id)) {
      _controller!.pause();
      _controller!.seekTo(Duration.zero);
      manager.setCurrentlyPlaying(null);
    } else {
      manager.setCurrentlyPlaying(widget.gestur.id);
      _controller!.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final videoManager = Provider.of<VideoPlayerManager>(context);

    if (_controller != null) {
      if (!videoManager.isCurrentlyPlaying(widget.gestur.id)) {
        _controller!.pause();
        _controller!.seekTo(Duration.zero);
      }
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: Color(0xFFD0EFFF)),
        color: Color(0xFFD0EFFF),
      ),
      width: 190,
      height: 140,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _togglePlayPause(videoManager),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    color: Colors.black,
                    width: 100,
                    height: 75,
                    child: _isInitialized
                        ? AspectRatio(
                            aspectRatio: _controller!.value.aspectRatio,
                            child: VideoPlayer(_controller!),
                          )
                        : Center(child: CircularProgressIndicator()),
                  ),
                  if (_isInitialized &&
                      !videoManager.isCurrentlyPlaying(widget.gestur.id))
                    Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 40,
                    ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Text(
              widget.gestur.terjemahan,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: 'Ubuntu',
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
