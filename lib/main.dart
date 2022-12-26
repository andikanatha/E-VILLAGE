// ignore_for_file: use_build_context_synchronously

import 'package:e_villlage/Data/Model/ApiResponse.dart';
import 'package:e_villlage/Data/Services/user_services.dart';
import 'package:e_villlage/Data/settings.dart';
import 'package:e_villlage/Ui/GetStarted/Login_ui.dart';
import 'package:e_villlage/Ui/Theme.dart';
import 'package:e_villlage/Ui/Widget/Navbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        primarySwatch: themecolor,
      ),
      home: CheckLogin(),
    );
  }
}

class CheckLogin extends StatefulWidget {
  @override
  _CheckLoginState createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin> {
  void _loadUserInfo() async {
    String token = await getToken();
    if (token == '') {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false);
    } else {
      ApiResponse response = await getuserdetail();
      if (response.error == null) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => NavBotBar()),
            (route) => false);
      } else if (response.error == unauthroized) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}'),
        ));
      }
    }
  }

  @override
  void initState() {
    _loadUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: primarycolor,
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
