// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle appbartitlestyle = GoogleFonts.poppins(
    color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16);

Color accentcolor = Color.fromARGB(255, 130, 222, 255);
// ignore: prefer_const_declarations
Color primarycolor = Colors.white;
Color boxcolor = Colors.white;

// ignore: prefer_const_declarations
Color surfacecolor = Colors.black;
// ignore: prefer_const_declarations
Color secondarycolor = const Color.fromARGB(255, 48, 167, 207);
Color secondarycolorhigh = Color.fromARGB(255, 130, 222, 255);
Color inputtxtbg = Color.fromARGB(255, 218, 236, 242);
Color defaultbgimg = Color.fromARGB(255, 217, 217, 217);

MaterialColor themecolor = MaterialColor(
  const Color.fromARGB(255, 75, 197, 241).value,
  const <int, Color>{
    50: Color.fromRGBO(75, 197, 241, 0.1),
    100: Color.fromRGBO(75, 197, 241, 0.2),
    200: Color.fromRGBO(75, 197, 241, 0.3),
    300: Color.fromRGBO(75, 197, 241, 0.4),
    400: Color.fromRGBO(75, 197, 241, 0.5),
    500: Color.fromRGBO(75, 197, 241, 0.6),
    600: Color.fromRGBO(75, 197, 241, 0.7),
    700: Color.fromRGBO(75, 197, 241, 0.8),
    800: Color.fromRGBO(75, 197, 241, 0.9),
    900: Color.fromRGBO(75, 197, 241, 1),
  },
);
