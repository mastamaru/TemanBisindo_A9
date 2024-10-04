import 'package:get/get.dart';
import 'package:temanbisindoa9/core/models/gestur_models.dart';
import 'package:temanbisindoa9/core/services/gestur_services.dart';

class GesturController extends GetxController {
  final GesturService _gesturService = GesturService();
  final RxList<GesturModel> gesturList = <GesturModel>[].obs;
  final RxBool isLoading = false.obs;

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
    } catch (e) {
      Get.snackbar('Error', 'Failed to load gestur data: $e');
    } finally {
      isLoading(false);
    }
  }
}
