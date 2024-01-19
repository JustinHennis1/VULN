import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FilePickerDemo extends StatelessWidget {
  const FilePickerDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Picker Demo'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Open the file picker
            FilePickerResult? result =
                await FilePicker.platform.pickFiles(type: FileType.any);

            if (result != null) {
              // Handle the selected file or folder
              String filePath = result.files.single.path!;
              print('Selected path: $filePath');
            } else {
              // User canceled the file picker
              print('User canceled file picker');
            }
          },
          child: const Text('Pick a Folder'),
        ),
      ),
    );
  }
}
