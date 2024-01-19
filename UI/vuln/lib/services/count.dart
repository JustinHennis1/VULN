import 'dart:convert';
import 'dart:io';

class CliWidget {
  int totalFileCount = 0;
  int totalInfectedCount = 0;
  List<String> infectious = [];

  int currentFileCount = 0;

  Future<int> countFilesInDirectory(String directoryPath) async {
    var directory = Directory(directoryPath);

    if (await directory.exists()) {
      var fileCount = 0;

      await for (var entity in directory.list(recursive: true)) {
        if (entity is File) {
          fileCount++;
        }
      }

      totalFileCount = fileCount;
      return fileCount;
    } else {
      throw FileSystemException('Directory not found: $directoryPath');
    }
  }

  Future<void> scanFilesAndPrintProgress(String directoryPath) async {
    var directory = Directory(directoryPath);

    print('Scanning files in directory: $directoryPath\n');

    await for (var entity in directory.list(recursive: true)) {
      if (entity is File) {
        currentFileCount++;

        print(
            'Scanning file $currentFileCount of $totalFileCount: ${entity.path}');
        await scanFile(entity.path);
      }
    }
    print('\n-----------Infected-----------');
    for (String filepath in infectious) print(filepath);

    print('\nScanning completed. Total Infected: $totalInfectedCount');
  }

  Future<void> scanFile(String filePath) async {
    var process = await Process.start('clamdscan', ['--no-summary', filePath]);

    await process.stdout.transform(utf8.decoder).forEach((data) {
      if (data.toLowerCase().contains('found')) {
        //print('\nInfected file: $filePath');
        //print(data);
        totalInfectedCount++;
        infectious.add(filePath);
      }
    });

    await process.stderr.transform(utf8.decoder).forEach((data) {
      //print('\nError: $data');
    });

    var exitCode = await process.exitCode;
    if (exitCode != 0) {
      //print('$exitCode');
    }
  }

  void run(String directoryPath) async {
    try {
      var fileCount = await countFilesInDirectory(directoryPath);
      if (fileCount == 0) {
        print('No files found in the directory.');
        return;
      }

      await scanFilesAndPrintProgress(directoryPath);
    } catch (e) {
      print('Error: $e');
    }
  }
}

void main() {
  var widget = CliWidget();
  var directoryPath = '/home/justin1/Downloads'; // Replace with the actual path
  widget.run(directoryPath);
}
