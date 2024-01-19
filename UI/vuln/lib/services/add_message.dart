import 'package:dio/dio.dart';

Future<void> addMessage(String messageText) async {
  final dio = Dio();
  String base_url = 'http://127.0.0.1:5000';
  // Replace the URL with your Flask server endpoint
  final serverUrl = '$base_url/add_message';

  try {
    // Make a POST request to the server to add a message
    final response = await dio.post(
      serverUrl,
      data: {'message_text': messageText},
    );

    // Print the response from the server
    print('Server Response: ${response.data}');
  } catch (e) {
    // Handle any errors that occur during the request
    print('Error: $e');
  }
}

void main() {
  // Replace this with your actual message text
  final messageText = 'Hello, this is a test message';

  // Call the addMessage function with the message
  addMessage(messageText);
}
