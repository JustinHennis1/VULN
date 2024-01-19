import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vuln/components/themeprovider.dart';
import 'package:vuln/components/themes.dart';
import 'package:vuln/pages/file_pick.dart';
import 'package:vuln/pages/home_page.dart';
import 'dart:io';
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Check if the WINDOW_CONSTRAINTS environment variable is set
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // Apply window size constraints
    applyWindowSizeConstraints();
  }
  runApp(ChangeNotifierProvider(
      create: (context) => ThemeProvider(), child: const MyApp()));
}

void applyWindowSizeConstraints() {
  // Use platform-specific code to set window size constraints
  // For Linux, you can use the `dart:ffi` library or platform channels
  // to interact with the native windowing system and set constraints.
  // Alternatively, you can use the `window_size` package.
  // Example (using `window_size` package):
  setWindowMinSize(const Size(800, 600));
  setWindowMaxSize(const Size(1600, 1200));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: context.watch<ThemeProvider>().currentTheme,
      home: const HomePage(),
    );
  }
}
