import 'dart:convert';

import 'package:console/console.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:vuln/components/drawer_view.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
//import 'package:vuln/components/mybutton.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:vuln/components/mybutton.dart';
import 'package:vuln/pages/home_page.dart';
import 'package:vuln/services/add_file.dart';
import 'package:path/path.dart' as path;
import 'package:vuln/services/update.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key}) : super(key: key);

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

String currentDirectory = Directory.current.path;

String pathToScanOne = '$currentDirectory/../../Scanning/CustomDirScan.py';
String pathToScanTwo = '$currentDirectory/../../Scanning/clamd_scan.py';
String pathToScanthree = '$currentDirectory/../../Scanning/swift_scan.py';
String pathToScanfour = '$currentDirectory/../../Scanning/clam_fullsys.py';

class _ScannerPageState extends State<ScannerPage> {
  String selectedFile = '';

  List<String> infectedList = []; //current list of files found to be infected
  //changes with each scan instance

  List<String> parseClamscanOutput(String output) {
    // Define a regular expression to match the file paths in the ClamAV output
    RegExp regexPattern = RegExp(r'^([^:]+): (.+?) FOUND$');

    List<String> infectedFiles = [];

    LineSplitter.split(output).forEach((line) {
      Match? match = regexPattern.firstMatch(line);
      if (match != null) {
        // Extract the file path and add it to the list
        String filePath = match.group(1)!.trim();
        infectedFiles.add(filePath);
      }
    });

    return infectedFiles;
  }

  String _extractFileName(String absolutepath) {
    // Extract file name from the absolute path
    String fileName = path.basename(absolutepath);

    return fileName;
  }

  Future<void> addinfected(String output) async {
    List<String> infectious = parseClamscanOutput(output);
    setState(() {
      infectedList = infectious;
    });

    for (String file in infectious) {
      String base = _extractFileName(file);
      addFiles(
          file: base,
          filePath: file,
          infected: true,
          clean: false,
          quarantine: false);
    }
  }

  Future<String> quarantineScript(
      String scriptPath, String abs_file, String quarantine_folder) async {
    try {
      print(
          'Executing Python script: python $scriptPath $abs_file $quarantine_folder');
      final process = await Process.run(
          'python', [scriptPath, abs_file, quarantine_folder]);

      var temp = _extractFileName(abs_file);
      final updateData = {'quarantine': true};
      await updateFile(temp, updateData);
      return process.stdout;
    } catch (e) {
      print('Error executing Python script: $e');
      return "error";
    }
  }

  Future<void> quarantineall() async {
    String pathToquarantine = '$currentDirectory/../../quarantine.py';

    for (String file in infectedList) {
      await quarantineScript(pathToquarantine, file, 'quarantine_folder');
    }
  }

  Future<String> removeScript(String scriptPath, String abs) async {
    try {
      print('Executing Python script: python $scriptPath $abs');
      final process = await Process.run('python', [scriptPath, abs]);

      return process.stdout;
    } catch (e) {
      print('Error executing Python script: $e');
      return "error";
    }
  }

  Future<void> removeall() async {
    String pathToremove = '$currentDirectory/../../remove.py';

    for (String file in infectedList) {
      await removeScript(pathToremove, file);
    }
  }

  Future<void> fetchProgress() async {
    String urlString = 'http://localhost:8000';
    Uri uri = Uri.parse(urlString);

// Now you can use the 'uri' object where a Uri is expected

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      // Parse and process progress messages from the response
      print(response.body);
    } else {
      // Handle error
      print('Error fetching progress: ${response.statusCode}');
    }
  }

  void showScanResultAlertDialog(BuildContext context, String scanResult) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Scan Result"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text(scanResult),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                //Code to Delete all infected files
                await removeall();
                Navigator.of(context).pop();
              },
              child: const Text("Delete Files"),
            ),
            TextButton(
              onPressed: () async {
                //Code to Qurantine all infected files
                await quarantineall();
                Navigator.of(context).pop();
              },
              child: const Text("Quarantine"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void onButtonPressed(int buttonNumber) async {
    // Handle the button press based on the buttonNumber
    print('Scan $buttonNumber pressed');

    // Execute the Python script with progress updates
    if (buttonNumber == 1) {
      // Custom Directory Scan Logic
      // Pick file you wish to scan
      // Progress bar : Report
      await scanit(pathToScanOne, 0);
    }
    if (buttonNumber == 2) {
      print("inside check 1");
      //Swift Scan
      await scanit(pathToScanthree, 0);
    }

    if (buttonNumber == 3) {
      //fast scan
      scanit(pathToScanTwo, 1);
    }
    if (buttonNumber == 4) {
      fullsys();
    } else {
      print("Scan not Initialized");
    }
  }

  Future<void> scanit(String scanfile, int choice) async {
    try {
      // Custom Directory Scan Logic
      // Pick file you wish to scan
      // Progress bar : Report
      // Open the file picker
      FilePickerResult? result;

      if (choice == 0) {
        result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['directory'],
          allowMultiple: false,
        );
      } else {
        result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['*'],
            allowMultiple: false);
      }

      if (result != null) {
        String filePath = result.files.single.path!;
        setState(() {
          selectedFile = filePath;
        });

        print('Selected path: $filePath');

        ProgressDialog progressDialog = ProgressDialog(context);
        progressDialog.style(
          message: 'Scanning...',
          messageTextStyle:
              TextStyle(color: Theme.of(context).highlightColor.withOpacity(1)),
          progressWidget: const CircularProgressIndicator.adaptive(
            backgroundColor: Colors.deepPurple,
            strokeWidth: 5.5,
          ),
          textAlign: TextAlign.center,
          backgroundColor: Theme.of(context).cardColor,
        );

        progressDialog.show();

        // Define a variable to store the scan result
        String scanResult = '';

        // Execute the Python script with a callback for progress updates
        await executePythonScript(
          scanfile,
          selectedFile,
          (progress) {
            // Update the progress dialog with the received progress
            print(progress);
            scanResult = progress;
            //showScanResultAlertDialog(context, scanResult);
            //progressDialog.hide();
            progressDialog.update(message: "Complete");
          },
        );
        progressDialog.hide();
        await addinfected(scanResult);
        showScanResultAlertDialog(context, scanResult);
      } else {
        // User canceled the file picker
        print('User canceled file picker');
      }
    } catch (e) {
      print('Error in onButtonPressed: $e');
    }
  }

  Future<void> fullsys() async {
    //Full system scan
    try {
      // Custom Directory Scan Logic
      // Pick file you wish to scan
      // Progress bar : Report
      // Open the file picker

      ProgressDialog progressDialog = ProgressDialog(context);
      progressDialog.style(
        message: 'Scanning...',
        progressWidget: const CircularProgressIndicator(),
      );

      progressDialog.show();

      // Define a variable to store the scan result
      String scanResult = '';

      // Execute the Python script with a callback for progress updates
      await executePythonScript(
        pathToScanfour,
        '/',
        (progress) {
          // Update the progress dialog with the received progress
          print(progress);
          scanResult = progress;

          //showScanResultAlertDialog(context, scanResult);
          //progressDialog.hide();
          progressDialog.update(message: "Complete");
        },
      );
      progressDialog.hide();
      // ignore: use_build_context_synchronously
      showScanResultAlertDialog(context, scanResult);
    } catch (e) {
      print('Error in onButtonPressed: $e');
    }
  }

  Future<void> executePythonScript(
    String scriptPath,
    String directoryPath,
    Function(String) updateProgress,
  ) async {
    try {
      final process =
          await Process.start('python', [scriptPath, directoryPath]);

      process.stdout.transform(utf8.decoder).listen((String data) {
        // Update the progress based on the data received from the script

        print('This is the data: $data');
        updateProgress(data);
      });

      await process.exitCode;
    } catch (e) {
      print('Error executing Python script: $e');
    }
  }

  String generateDescription(int scanNumber) {
    // Customize the descriptions based on the scan number
    if (scanNumber == 1) {
      return """Efficient with larger directories""";
    }
    if (scanNumber == 2) {
      return """More thorough then a fast scan""";
    }
    if (scanNumber == 3) {
      return """Use on singular files and small directories""";
    }
    if (scanNumber == 4) {
      return """May take some time to complete""";
    } else {
      return 'Custom Description for Scan $scanNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
        height: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          image: DecorationImage(
            fit: BoxFit.fill,
            image: const AssetImage('assets/images/honeycomb.jpg'),
            colorFilter: ColorFilter.mode(
              Theme.of(context).canvasColor,
              BlendMode.colorBurn,
            ),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: List.generate(
              2,
              (index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: size.height * 0.35,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: Theme.of(context).highlightColor,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: MyButton(
                        size: size,
                        buttonText: index == 0 ? "Directory Scan" : "Fast Scan",
                        descriptionText: generateDescription(index * 2 + 1),
                        onPressed: () => onButtonPressed(index * 2 + 1),
                      ),
                    ),
                    Container(
                      height: size.height * 0.35,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: Theme.of(context).highlightColor,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: MyButton(
                        size: size,
                        buttonText:
                            index == 1 ? "Full System Scan" : "Swift Scan",
                        descriptionText: generateDescription(index * 2 + 2),
                        onPressed: () => onButtonPressed(index * 2 + 2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
