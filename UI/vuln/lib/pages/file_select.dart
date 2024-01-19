import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:vuln/components/drawer_view.dart';
import 'package:vuln/components/mybutton.dart';
import 'package:path/path.dart' as path;
import 'package:vuln/pages/home_page.dart';
import 'package:vuln/services/add_file.dart';
import 'package:vuln/services/delete_file.dart';
import 'package:vuln/services/update.dart';

class FileSPage extends StatefulWidget {
  const FileSPage({super.key});

  @override
  State<FileSPage> createState() => _FileSPageState();
}

class _FileSPageState extends State<FileSPage> {
  String selectedFile = '';
  String scanR = '';

  void showScanResultAlertDialog(BuildContext context, String scanResult,
      String pathtoremove, String pathtoquarantine) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Scan Result"),
          content: Text(scanResult),
          actions: [
            TextButton(
              onPressed: () async {
                await _deleteFileName(selectedFile);
                await removeScript(pathtoremove, selectedFile);
                setState(() {
                  selectedFile = '';
                });
                Navigator.of(context).pop();
              },
              child: const Text("Delete Files"),
            ),
            TextButton(
              onPressed: () async {
                quarantineScript(
                    pathtoquarantine, selectedFile, 'quarantine_folder');
                setState(() {
                  selectedFile = '';
                });
                Navigator.of(context).pop();
              },
              child: const Text("Quarantine"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  selectedFile = '';
                });
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<String> executePythonScript(
      String scriptPath, String directoryPath) async {
    try {
      print('Executing Python script: python $scriptPath $directoryPath');
      final process = await Process.run('python', [scriptPath, directoryPath]);
      print('Exit Code: ${process.exitCode}');
      print('stdout: ${process.stdout}');
      print('stderr: ${process.stderr}');
      return process.stdout;
    } catch (e) {
      print('Error executing Python script: $e');
      return "error";
    }
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

  Future<void> _addFileName(String absolutepath, scanR) async {
    // Extract file name from the absolute path
    String fileName = _extractFileName(selectedFile);
    bool isInfected = containsFound(scanR);

    await addFiles(
        file: fileName,
        filePath: selectedFile,
        infected: isInfected == true ? true : false,
        clean: isInfected == false ? true : false,
        quarantine: false);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // Get the current working directory of the Dart script
    String currentDirectory = Directory.current.path;

    // Construct the relative path to clamd_scan.py
    String pathToScanOne = '$currentDirectory/../../Scanning/clamd_scan.py';
    String pathToremove = '$currentDirectory/../../remove.py';
    String pathToquarantine = '$currentDirectory/../../quarantine.py';
    // List<String> allowedExtensions = [
    //   // ClamAV file types
    //   '.7z', '.7zsfx', '.apm', '.arj', '.arjsfx', '.autoit', '.bin', '.binhex',
    //   '.bz', '.cabsfx', '.cpio_crc', '.cpio_newc', '.cpio_odc', '.cpio_old',
    //   '.cryptff', '.dmg', '.egg', '.elf', '.gif', '.gpt', '.graphics', '.gz',
    //   '.html_utf16', '.html', '.hwp3', '.hwpole2', '.internal', '.ishield_msi',
    //   '.iso9660', '.java', '.jpeg', '.lnk', '.macho_unibin', '.macho', '.mail',
    //   '.mbr', '.mhtml', '.mscab', '.mschm', '.msexe', '.msole2', '.msszdd',
    //   '.nulsft', '.old_tar', '.ooxml_hwp', '.ooxml_ppt', '.ooxml_word',
    //   '.ooxml_xl', '.part_hfsplus', '.pdf', '.png', '.posix_tar', '.ps',
    //   '.rar', '.rarsfx', '.riff', '.rtf', '.screnc', '.script', '.sis', '.swf',
    //   '.text_ascii', '.text_utf16be', '.text_utf16le', '.text_utf8', '.tiff',
    //   '.tnef', '.uuencoded', '.xar', '.xdp', '.xml_hwp', '.xml_word', '.xml_xl',
    //   '.xz', '.zip', '.zipsfx',

    //   // Common coding file types
    //   '.py', '.pyc', '.pyd', '.pyo', '.pyw', '.pyz', '.cpp', '.h', '.hpp',
    //   '.c', '.cs', '.java', '.js', '.ts', '.php', '.html', '.css', '.rb',
    //   '.swift', '.go', '.dart', '.lua', '.sh', '.bash', '.ps1', '.bat', '.pl',
    //   '.r', '.scala', '.kotlin', '.vb', '.json', '.xml', '.yaml', '.yml',
    //   '.ini', '.cfg', '.toml'
    // ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Center(
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ));
                },
                child: const Text('Vulnerabilities Under Learned Network'))),
      ),
      drawer: const DrawerView(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Theme.of(context).secondaryHeaderColor,
          image: DecorationImage(
            fit: BoxFit.fill,
            image: const AssetImage('assets/images/honeycomb.jpg'),
            colorFilter: ColorFilter.mode(
              Theme.of(context).canvasColor,
              BlendMode.colorBurn,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Container(
                width: size.width * 0.3,
                height: size.height * 0.52,
                decoration: BoxDecoration(
                  color: Theme.of(context).secondaryHeaderColor,
                  border: Border.all(),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text("Step 1", style: TextStyle(fontSize: 40)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            "To select a File press: ",
                            style: TextStyle(fontSize: 20),
                          ),
                          ElevatedButton(
                            autofocus: true,
                            onPressed: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles(
                                type: FileType.any,
                                //allowedExtensions: allowedExtensions,
                                allowMultiple: false,
                              );

                              if (result != null) {
                                String filePath = result.files.single.path!;
                                setState(() {
                                  selectedFile = filePath;
                                });

                                print('Selected path: $filePath');
                              } else {
                                print('User canceled file picker');
                              }
                            },
                            child: Text(
                              'Choose File',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: size.width * 0.3,
                height: size.height * 0.52,
                decoration: BoxDecoration(
                  color: Theme.of(context).secondaryHeaderColor,
                  border: Border.all(),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        "Step 2",
                        style: TextStyle(fontSize: 40),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("The file path you selected is: "),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          selectedFile,
                          style: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontSize: size.height * .023,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MyButton(
                              size: size * .8,
                              buttonText: 'Scan Now',
                              descriptionText: "",
                              onPressed: () async {
                                try {
                                  if (selectedFile != "") {
                                    String scanResult =
                                        await executePythonScript(
                                            pathToScanOne, selectedFile);
                                    setState(() {
                                      scanR = scanResult;
                                    });
                                    _addFileName(selectedFile, scanR);
                                    showScanResultAlertDialog(
                                        context,
                                        scanResult,
                                        pathToremove,
                                        pathToquarantine);
                                  } else {}
                                } catch (e) {
                                  print("Error in file select");
                                }
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:process_run/process_run.dart';

// class FileSPage extends StatelessWidget {
//   const FileSPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('File Scanner'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             await _startFileScan(context);
//           },
//           child: const Text('Start File Scan'),
//         ),
//       ),
//     );
//   }

//   Future<void> _startFileScan(BuildContext context) async {
//     String currentDirectory = Directory.current.path;

//     String pathToScanOne = '$currentDirectory/lib/services/count.dart';
//     try {
//       // Replace '/path/to/your/directory' with the actual path
//       var results = await run(
//         'dart $pathToScanOne',
//         commandVerbose: true,
//       );

//       // Display the output in a dialog
//       await showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text('Scan Result'),
//             content: SingleChildScrollView(
//               child: Column(
//                 children: results.map((result) {
//                   return Text(result.stdout.toString());
//                 }).toList(),
//               ),
//             ),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
// }
