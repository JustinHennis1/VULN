import 'dart:io';
import 'dart:convert';

void main() async {
  await scanFiles("/");
}

Future<void> scanFiles(String directory) async {
  var dir = Directory(directory);

  await for (var entity in dir.list(recursive: true)) {
    if (entity is File) {
      await scanFile(entity.path);
    }
  }
}

Future<void> scanFile(String filePath) async {
  var file = File(filePath);

  try {
    var fileStat = await file.stat();

    // Check if the file is a regular file
    if (fileStat.type == FileSystemEntityType.file) {
      var process = await Process.start(
        'sudo',
        ['clamdscan', '--no-summary', filePath],
        mode: ProcessStartMode.inheritStdio,
      );

      var exitCode = await process.exitCode;
      if (exitCode != 0) {
        print('Scan failed for $filePath with exit code $exitCode.');
      }
    }
  } catch (e) {
    if (e is ProcessException && e.errorCode == 2) {
      print('Skipped inaccessible file: $filePath');
    } else {
      print('Error accessing file $filePath: $e');
    }
  }
}
