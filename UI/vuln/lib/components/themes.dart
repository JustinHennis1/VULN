import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
    primaryColor: Colors.white,
    indicatorColor: Colors.white,
    secondaryHeaderColor: Colors.grey.shade400,
    focusColor: Colors.black,
    hintColor: Colors.black,
    cardColor: Colors.black
        .withOpacity(0.99), //controls homepage or any page background w/o image
    canvasColor:
        Colors.white, //will control filter color of honeycomb background
    textTheme: GoogleFonts.playfairDisplayTextTheme(Typography.blackCupertino),
    colorScheme: ColorScheme.highContrastLight(
        brightness: Brightness.dark,
        primary: Colors.grey.shade900, //controls text color
        secondary: Colors.grey.shade800),
    brightness: Brightness.dark,
    drawerTheme: DrawerThemeData(backgroundColor: Colors.grey.shade300),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
    ));

ThemeData darkTheme = ThemeData(
    primaryColor: Colors.black87,
    indicatorColor: Colors.white,
    secondaryHeaderColor: Colors.grey.shade900,
    hintColor: Colors.white54,
    focusColor: Colors.white,
    cardColor:
        Colors.black, //controls homepage or any page background w/o image
    canvasColor:
        Colors.blue, //will control filter color of honeycomb background
    textTheme: GoogleFonts.playfairDisplayTextTheme(Typography.whiteCupertino),
    colorScheme: ColorScheme.highContrastDark(
        brightness: Brightness.dark,
        primary: Colors.blueGrey.shade400,
        secondary: Colors.grey.shade800),
    brightness: Brightness.dark,
    drawerTheme: DrawerThemeData(backgroundColor: Colors.grey.shade800),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
    ));

ThemeData redTheme = ThemeData(
    primaryColor: const Color.fromARGB(255, 128, 16, 16),
    indicatorColor: const Color.fromARGB(255, 128, 16, 16),
    secondaryHeaderColor: Colors.grey.shade900,
    hintColor: Colors.red.shade700,
    focusColor: Colors.black,
    cardColor: Colors.black
        .withOpacity(0.99), //controls homepage or any page background w/o image
    canvasColor:
        Colors.amber, //will control filter color of honeycomb background
    textTheme: GoogleFonts.playfairDisplayTextTheme(Typography.whiteCupertino),
    colorScheme: ColorScheme.highContrastDark(
        brightness: Brightness.dark,
        primary: Colors.white,
        secondary: Colors.red.shade800),
    brightness: Brightness.dark,
    drawerTheme: const DrawerThemeData(
        backgroundColor: Color.fromARGB(255, 128, 16, 16)),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
    ));

ThemeData blueTheme = ThemeData(
    primaryColor: const Color.fromARGB(255, 16, 23, 128),
    indicatorColor:
        const Color.fromARGB(255, 16, 23, 128), //controls color of word scan
    secondaryHeaderColor: Colors.grey.shade900,
    hintColor: Colors.blue.shade700,
    focusColor: Colors.amber,
    cardColor: Colors.black
        .withOpacity(0.99), //controls homepage or any page background w/o image
    canvasColor:
        Colors.indigo, //will control filter color of honeycomb background
    textTheme: GoogleFonts.playfairDisplayTextTheme(Typography.whiteCupertino),
    colorScheme: ColorScheme.highContrastDark(
        brightness: Brightness.dark,
        primary: Colors.white,
        secondary: Colors.blue.shade800),
    brightness: Brightness.dark,
    drawerTheme: const DrawerThemeData(
        backgroundColor: Color.fromARGB(255, 16, 23, 128)),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
    ));

ThemeData greenTheme = ThemeData(
    primaryColor: const Color.fromARGB(255, 5, 119, 20),
    indicatorColor:
        const Color.fromARGB(255, 5, 119, 20), //controls color of word scan
    secondaryHeaderColor: Colors.grey.shade900,
    hintColor: const Color.fromARGB(255, 93, 210, 25),
    focusColor: Colors.redAccent,
    cardColor: Colors.black
        .withOpacity(0.99), //controls homepage or any page background w/o image
    canvasColor:
        Colors.greenAccent, //will control filter color of honeycomb background
    textTheme: GoogleFonts.playfairDisplayTextTheme(Typography.whiteCupertino),
    colorScheme: ColorScheme.highContrastDark(
        brightness: Brightness.dark,
        primary: Colors.white,
        secondary: Colors.green.shade800),
    brightness: Brightness.dark,
    drawerTheme: const DrawerThemeData(
        backgroundColor: Color.fromARGB(255, 12, 102, 65)),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
    ));
