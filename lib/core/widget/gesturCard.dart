import 'package:cached_network_image/cached_network_image.dart'; // Import ini
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:temanbisindoa9/core/widget/videoModal.dart';
import 'package:video_player/video_player.dart';

import '../models/gestur_models.dart';

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
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initializeVideo() async {
    if (_controller != null) return; // Prevent multiple initializations

    try {
      final fileInfo =
          await DefaultCacheManager().getFileFromCache(widget.gestur.linkVideo);
      final file = fileInfo?.file ??
          await DefaultCacheManager().getSingleFile(widget.gestur.linkVideo);

      if (!mounted) return;

      _controller = VideoPlayerController.file(file);
      await _controller!.initialize();
      await _controller!.setLooping(false);
      await _controller!.pause(); // Tetap pause setelah inisialisasi

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      print('Error initializing video: $e');
      if (mounted) {
        setState(() {
          _isInitialized = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
              onTap: () async {
                await _initializeVideo(); // Inisialisasi video saat tap
                showDialog(
                  context: context,
                  builder: (context) => VideoModal(gestur: widget.gestur),
                );
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 75,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: widget.gestur.linkImage.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: widget
                                  .gestur.linkImage, // Menggunakan thumbnail
                              fit: BoxFit.cover,
                              width: 100,
                              height: 75,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[300],
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            )
                          : Container(
                              color: Colors.grey[300],
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 75,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.play_circle_outline,
                      color: Colors.white,
                      size: 40,
                    ),
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
