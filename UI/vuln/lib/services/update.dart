import 'package:dio/dio.dart';

Future<void> updateFile(String file, Map<String, dynamic> updateData) async {
  final dio = Dio();
  const baseUrl = 'http://127.0.0.1:5000'; // Replace with your server URL

  try {
    final response = await dio.put(
      '$baseUrl/updatefile',
      data: {'file': file, ...updateData},
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Data: ${response.data}');

    if (response.statusCode == 200) {
      print('File updated successfully');
    } else {
      print('Error: ${response.statusCode}, ${response.statusMessage}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
