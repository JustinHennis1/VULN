import 'dart:io';
import 'package:console/console.dart';

class ScanProgress {
  int totalFiles = 0;
  int scannedFiles = 0;

  double get progress => totalFiles == 0 ? 0 : scannedFiles / totalFiles;

  void printProgress(String path) {
    Console.eraseDisplay();
    Console.moveCursor(row: 1, column: 1);

    final int barLength = 50;
    final int filledLength = (progress * barLength).round();
    final String bar = '=' * filledLength + '-' * (barLength - filledLength);
    final String percentage = (progress * 100).toStringAsFixed(2);

    print('Scanning: $path');
    print('Progress: [$bar] $percentage%');
  }
}

Future<void> scanDirectory(String path, ScanProgress progress) async {
  try {
    var result = await Process.run('clamscan', ['-r', path]);

    if (result.exitCode == 0) {
      print('$path is clean.');
    } else {
      print('$path may contain infected files. ClamAV detected an issue.');
    }
  } catch (e) {
    print('An error occurred while scanning $path: $e');
  } finally {
    progress.scannedFiles++;
    progress.printProgress(path);
  }
}

Future<void> main(List<String> args) async {
  if (args.length != 1) {
    print('Usage: dart script.dart <directory_to_scan>');
    exit(1);
  }

  var directoryToScan = args[0];
  var progress = ScanProgress();

  try {
    var files =
        Directory(directoryToScan).listSync(recursive: true).whereType<File>();

    await Future.forEach(files, (entity) async {
      progress.totalFiles++;
      await scanDirectory(entity.path, progress);
    });
  } catch (e) {
    print('An error occurred: $e');
  }
}
