// ignore_for_file: use_build_context_synchronously

import 'package:e_villlage/Data/LocalSettings.dart';
import 'package:e_villlage/Data/Model/ApiResponse.dart';
import 'package:e_villlage/Data/Services/user_services.dart';
import 'package:e_villlage/Data/settings.dart';
import 'package:e_villlage/Ui/Admin/HomescreenAdminUI.dart';
import 'package:e_villlage/Ui/OnBoardingScreen/OnboardingUI.dart';
import 'package:e_villlage/Ui/Theme.dart';
import 'package:e_villlage/Ui/Widget/Navbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        MonthYearPickerLocalizations.delegate,
      ],
    );
  }
}

class CheckLogin extends StatefulWidget {
  @override
  _CheckLoginState createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin> {
  void _loadUserInfo() async {
    bool theme = await getisDarkTheme();
    if (theme == true) {
      primarycolor = Color.fromARGB(255, 33, 73, 98);
      accentcolor = Colors.white;
      secondarycolor = Color.fromARGB(255, 22, 53, 72);
      boxcolor = Color.fromARGB(255, 65, 103, 126);
      surfacecolor = Colors.white;
      inputtxtbg = Color.fromARGB(255, 65, 103, 126);
      hinttext = Color.fromARGB(255, 213, 213, 213);
    }
    String token = await getToken();
    String role = await getUserrole();
    if (token == '') {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => OnBoarding()),
          (route) => false);
    } else {
      if (role == "admin") {
        ApiResponse response = await getuserdetail();
        if (response.data != null) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomeScreenAdmin()),
              (route) => false);
        } else if (response.error == unauthroized) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => OnBoarding()),
              (route) => false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('${response.error}'),
          ));
        }
      } else {
        ApiResponse response = await getuserdetail();
        if (response.data != null) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => NavBotBar()),
              (route) => false);
        } else if (response.error == unauthroized) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => OnBoarding()),
              (route) => false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('${response.error}'),
          ));
        }
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
