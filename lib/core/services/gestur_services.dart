import 'package:http/http.dart' as http;
import 'package:temanbisindoa9/core/models/gestur_models.dart';

class GesturService {
// final String baseUrl = 'http://10.0.2.2:8080/';
  final String baseUrl = 'https://66b4-112-78-132-212.ngrok-free.app/';

  Future<List<GesturModel>> getAllGestur() async {
    final response = await http.get(Uri.parse('$baseUrl/get_all_gestur'));

    if (response.statusCode == 200) {
      return gesturListFromJson(response.body);
    } else {
      throw Exception('Failed to load gestur data');
    }
  }
}