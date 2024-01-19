import 'package:dio/dio.dart';

Future<List<Map<String, dynamic>>> getInfectedFiles() async {
  final dio = Dio();
  String base_url = 'http://127.0.0.1:5000';
  // Replace the URL with your Flask server endpoint
  final serverUrl = '$base_url/getinfectedfiles';

  try {
    final response = await dio.get(serverUrl);
    if (response.statusCode == 200) {
      List<Map<String, dynamic>> infectedFiles =
          List<Map<String, dynamic>>.from(response.data);
      return infectedFiles;
    } else {
      throw Exception('Failed to load infected files');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}
