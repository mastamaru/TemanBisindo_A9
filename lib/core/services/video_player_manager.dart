import 'package:flutter/foundation.dart';

class VideoPlayerManager extends ChangeNotifier {
  String? _currentlyPlayingVideoId;

  String? get currentlyPlayingVideoId => _currentlyPlayingVideoId;

  void setCurrentlyPlaying(String? videoId) {
    if (_currentlyPlayingVideoId != videoId) {
      _currentlyPlayingVideoId = videoId;
      notifyListeners();
    }
  }

  bool isCurrentlyPlaying(String videoId) {
    return _currentlyPlayingVideoId == videoId;
  }
}
