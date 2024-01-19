import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:flutter/material.dart';
import 'package:vuln/services/delete_file.dart';
import 'package:vuln/services/getquarantined.dart';
import 'package:vuln/services/update.dart';

class QuarantinedFilesList extends StatefulWidget {
  const QuarantinedFilesList({super.key, required this.searchQuery});
  final String searchQuery;

  @override
  State<QuarantinedFilesList> createState() => _QuarantinedFilesListState();
}

String currentDirectory = Directory.current.parent.parent.path;
String pathtoquarantine = '$currentDirectory/UI/vuln/quarantine_folder/';

class _QuarantinedFilesListState extends State<QuarantinedFilesList> {
  late Future<Iterable<Map<String, dynamic>>> _quarantinedFiles;
  String selectedFile = '';
  //String searchQuery = ''; // Add this line

  @override
  void initState() {
    super.initState();
    _quarantinedFiles = getQuarantinedFiles();
  }

  Future<String> removeScript(String scriptPath, String abs) async {
    try {
      print('Executing Python script: python $scriptPath $abs');
      final process = await Process.run('python', [scriptPath, abs]);
      print('Exit Code: ${process.exitCode}');
      print('stdout: ${process.stdout}');
      print('stderr: ${process.stderr}');
      return process.stdout;
    } catch (e) {
      print('Error executing Python script: $e');
      return "error";
    }
  }

  Future<String> quarantineScript(
      String scriptPath, String abs_file, String quarantine_folder) async {
    try {
      print(
          'Executing Python script: python $scriptPath $abs_file $quarantine_folder');
      final process = await Process.run(
          'python', [scriptPath, abs_file, quarantine_folder]);
      print('Exit Code: ${process.exitCode}');
      print('stdout: ${process.stdout}');
      print('stderr: ${process.stderr}');
      var temp = _extractFileName(abs_file);
      final updateData = {'quarantine': true};
      await updateFile(temp, updateData);
      return process.stdout;
    } catch (e) {
      print('Error executing Python script: $e');
      return "error";
    }
  }

  Future<String> movebackScript(
      String abs_file, String quarantine_folder) async {
    try {
      final process = await Process.run('mv', [quarantine_folder, abs_file]);
      print('Exit Code: ${process.exitCode}');
      print('stdout: ${process.stdout}');
      print('stderr: ${process.stderr}');
      var temp = _extractFileName(abs_file);
      final updateData = {'quarantine': false};
      await updateFile(temp, updateData);
      return process.stdout;
    } catch (e) {
      print('Error executing mv script: $e');
      return "error";
    }
  }

  bool containsFound(String inputString) {
    return inputString.toLowerCase().contains('found');
  }

  String _extractFileName(String absolutepath) {
    // Extract file name from the absolute path
    String fileName = path.basename(absolutepath);

    return fileName;
  }

  Future<void> _deleteFileName(String absolutepath) async {
    // Extract file name from the absolute path
    String fileName = _extractFileName(selectedFile);

    await deleteFile(fileName);
  }

  @override
  Widget build(BuildContext context) {
    String currentDirectory = Directory.current.path;

    String pathToremove = '$currentDirectory/../../remove.py';

    return FutureBuilder<Iterable<Map<String, dynamic>>>(
      future: _quarantinedFiles,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No quarantined files available.');
        } else {
          // Use the searchQuery to filter the displayed files
          final filteredFiles = snapshot.data!
              .where((file) =>
                  file['file']
                      .toLowerCase()
                      .contains(widget.searchQuery.toLowerCase()) ||
                  file['file_path']
                      .toLowerCase()
                      .contains(widget.searchQuery.toLowerCase()))
              .toList();

          return ListView.builder(
            key: UniqueKey(),
            itemCount: filteredFiles.length,
            itemBuilder: (context, index) {
              final file = filteredFiles[index];
              return ListTile(
                title: Text('File: ${file['file']}'),
                subtitle: Text('File Path: ${file['file_path']}'),
                onTap: () {
                  print(file['file']);
                  String selectpath = '';
                  setState(() {
                    selectedFile = file['file'];
                    selectpath = file['file_path'];
                  });
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Container(
                        width: MediaQuery.sizeOf(context).width * 0.5,
                        height: MediaQuery.sizeOf(context).height * 0.5,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'What would you like to do to the file?',
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.sizeOf(context).width * 0.02),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      await movebackScript(selectpath,
                                          '$pathtoquarantine$selectedFile');
                                      setState(() {
                                        _quarantinedFiles =
                                            getQuarantinedFiles();
                                      });
                                    },
                                    child: Text(
                                      'Ignore',
                                      style: TextStyle(
                                          fontSize:
                                              MediaQuery.sizeOf(context).width *
                                                  0.02),
                                    )),
                                ElevatedButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      await removeScript(pathToremove,
                                          '$pathtoquarantine$selectedFile');
                                      final updateData = {'quarantine': false};
                                      await updateFile(
                                          selectedFile, updateData);
                                      setState(() {
                                        _quarantinedFiles =
                                            getQuarantinedFiles();
                                      });
                                    },
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(
                                          fontSize:
                                              MediaQuery.sizeOf(context).width *
                                                  0.02),
                                    )),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                          fontSize:
                                              MediaQuery.sizeOf(context).width *
                                                  0.02),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}
