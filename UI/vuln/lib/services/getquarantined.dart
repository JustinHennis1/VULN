import 'package:dio/dio.dart';

Future<Iterable<Map<String, dynamic>>> getQuarantinedFiles() async {
  final dio = Dio();
  String base_url = 'http://127.0.0.1:5000';
  final serverUrl = '$base_url/getquarantinedfiles';

  try {
    final response = await dio.get(serverUrl);
    if (response.statusCode == 200) {
      Iterable<Map<String, dynamic>> quarantinedFiles =
          List<Map<String, dynamic>>.from(response.data);
      return quarantinedFiles;
    } else {
      throw Exception('Failed to load quarantined files');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}
