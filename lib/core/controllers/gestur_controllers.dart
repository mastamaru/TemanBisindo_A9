import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:temanbisindoa9/core/models/gestur_models.dart';
import 'package:temanbisindoa9/core/services/gestur_services.dart';
import 'package:video_player/video_player.dart';

class GesturController extends GetxController {
  final GesturService _gesturService = GesturService();
  final RxList<GesturModel> gesturList = <GesturModel>[].obs;
  final RxList<GesturModel> filteredGesturList =
      <GesturModel>[].obs; // List untuk menyimpan data yang difilter
  final RxBool isLoading = false.obs;
  final RxString selectedCategory =
      'Pilihan: '.obs; // Menyimpan kategori yang dipilih

  @override
  void onInit() {
    super.onInit();
    fetchAllGestur();
  }

  Future<void> fetchAllGestur() async {
    try {
      isLoading(true);
      final gesturData = await _gesturService.getAllGestur();
      gesturList.assignAll(gesturData);
      filteredGesturList
          .assignAll(gesturData); // Inisialisasi dengan semua data
    } catch (e) {
      Get.snackbar('Error', 'Failed to load gestur data: $e');
    } finally {
      isLoading(false);
    }
  }

  void filterGestur(String category) {
    print('Filtering category: $category'); // Tambahkan log
    isLoading.value = true;

    try {
      if (category == 'Semua') {
        // Tambahkan kondisi untuk 'Semua'
        filteredGesturList.assignAll(gesturList);
      } else if (category == 'Huruf') {
        filteredGesturList.assignAll(
            gesturList.where((gestur) => gestur.category == 'Huruf').toList());
      } else if (category == 'Angka') {
        filteredGesturList.assignAll(
            gesturList.where((gestur) => gestur.category == 'Angka').toList());
      } else if (category == 'Kata') {
        filteredGesturList.assignAll(
            gesturList.where((gestur) => gestur.category == 'Kata').toList());
      }

      print(
          'Filtered list length: ${filteredGesturList.length}'); // Tambahkan log
    } catch (e) {
      print('Error during filtering: $e'); // Tambahkan log error
    } finally {
      isLoading.value = false;
    }
  }

  // Di GesturController
  final Map<String, VideoPlayerController> _videoControllerCache = {};

// Fungsi untuk mendapatkan controller dari cache
  Future<VideoPlayerController> getVideoController(String videoUrl) async {
    if (_videoControllerCache.containsKey(videoUrl)) {
      return _videoControllerCache[videoUrl]!;
    }

    final fileInfo = await DefaultCacheManager().getFileFromCache(videoUrl);
    final file =
        fileInfo?.file ?? await DefaultCacheManager().getSingleFile(videoUrl);

    final controller = VideoPlayerController.file(file);
    await controller.initialize();
    _videoControllerCache[videoUrl] = controller;

    return controller;
  }

// Fungsi untuk membersihkan cache
  void clearVideoCache() {
    for (var controller in _videoControllerCache.values) {
      controller.dispose();
    }
    _videoControllerCache.clear();
  }
}
