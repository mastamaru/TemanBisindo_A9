import 'package:get/get.dart';
import 'package:temanbisindoa9/core/models/gestur_models.dart';
import 'package:temanbisindoa9/core/services/gestur_services.dart';

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
    isLoading.value = true;
    // Misalkan Anda memiliki logika pemfilteran berdasarkan kategori
    if (category == 'Huruf') {
      filteredGesturList.value =
          gesturList.where((gestur) => gestur.category == 'Huruf').toList();
    } else if (category == 'Angka') {
      filteredGesturList.value =
          gesturList.where((gestur) => gestur.category == 'Angka').toList();
    } else if (category == 'Kata') {
      filteredGesturList.value =
          gesturList.where((gestur) => gestur.category == 'Kata').toList();
    } else {
      filteredGesturList.value =
          gesturList; // Menampilkan semua jika 'Pilihan:'
    }
    // Set loading ke false setelah filter selesai
    isLoading.value = false;
  }
}
