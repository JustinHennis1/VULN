import 'package:dio/dio.dart';

Future<void> deleteFile(String fileName) async {
  final dio = Dio();
  const baseUrl = 'http://127.0.0.1:5000'; // Replace with your server URL

  try {
    print(fileName);
    final response =
        await dio.delete('$baseUrl/deletefile', data: {'file_name': fileName});

    print('Response Status Code: ${response.statusCode}');
    print('Response Data: ${response.data}');

    if (response.statusCode == 200) {
      print('File deleted successfully');
    } else {
      print('Error: ${response.statusCode}, ${response.statusMessage}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
