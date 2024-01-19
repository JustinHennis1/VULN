import 'package:dio/dio.dart';

Future<void> addFiles({
  required String file,
  required String filePath,
  required bool infected,
  required bool clean,
  required bool quarantine,
}) async {
  const baseUrl = 'http://127.0.0.1:5000';

  try {
    final dio = Dio();
    final response = await dio.post(
      '$baseUrl/addfiles',
      data: {
        'file': file,
        'file_path': filePath,
        'infected': infected,
        'clean': clean,
        'quarantine': quarantine,
      },
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Data: ${response.data}');

    if (response.statusCode == 200) {
      print('File added successfully');
    } else {
      print(
          'Error adding file: ${response.statusCode}, ${response.statusMessage}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
