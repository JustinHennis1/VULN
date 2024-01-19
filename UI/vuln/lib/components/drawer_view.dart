import 'package:flutter/material.dart';
import 'package:vuln/pages/about_us.dart';
import 'package:vuln/pages/file_select.dart';
import 'package:vuln/pages/home_page.dart';
import 'package:vuln/pages/quarantine.dart';
import 'package:vuln/pages/scanner_page.dart';
import 'package:vuln/pages/settings.dart';
import 'package:vuln/pages/support_page.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black87,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              // Add navigation logic if needed
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
            },
          ),
          ListTile(
            title: const Text('Scanner'),
            onTap: () {
              // Add navigation logic if needed
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const ScannerPage()));
            },
          ),
          ListTile(
            title: const Text('File Select'),
            onTap: () {
              // Add navigation logic if needed
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const FileSPage()));
            },
          ),
          ListTile(
            title: const Text('Quarantine'),
            onTap: () {
              // Add navigation logic if needed
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const QPage()));
            },
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () {
              // Add navigation logic if needed
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsPage()));
            },
          ),
          ListTile(
            title: const Text('About Us'),
            onTap: () {
              // Add navigation logic if needed
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const AboutPage()));
            },
          ),
          ListTile(
            title: const Text('Support'),
            onTap: () {
              // Add navigation logic if needed
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const SupportPage()));
            },
          ),
        ],
      ),
    );
  }
}
