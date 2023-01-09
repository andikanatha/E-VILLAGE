// ignore_for_file: prefer_const_constructors, file_names, sized_box_for_whitespace, unnecessary_import

import 'dart:ui';

import 'package:e_villlage/Data/Model/ApiResponse.dart';
import 'package:e_villlage/Data/Model/UserModel.dart';
import 'package:e_villlage/Data/Services/user_services.dart';
import 'package:e_villlage/Ui/Admin/HomescreenAdminUI.dart';
import 'package:e_villlage/Ui/GetStarted/Register_ui.dart';
import 'package:e_villlage/Ui/Theme.dart';
import 'package:e_villlage/Ui/Widget/LoadWidget.dart';
import 'package:e_villlage/Ui/Widget/Navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void _login() async {
    ApiResponse response =
        await login(email: email.text, password: password.text);
    if (response.data != null) {
      savetokenlogin(response.data as UserModel);
    } else {
      setState(() {
        load = false;
      });
      response.error == "User tidak ditemukan"
          ? showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Kesalahan saat masuk"),
                  content: Text(
                      "Mohon maaf, email atau password yang anda masukkan salah"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Oke"))
                  ],
                );
              },
            )
          : response.error == "email invalid"
              ? showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Kesalahan saat masuk"),
                      content: Text(
                          "Email yang ada masukkan tidak valid, Mohon masukkan email sesuai dengan email anda"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterScreen(),
                                  ));
                            },
                            child: Text("Oke"))
                      ],
                    );
                  },
                )
              : showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Kesalahan saat masuk"),
                      content: Text(
                          "Mohon maaf sedang terjadi kesalahan, coba lagi nanti"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Oke"))
                      ],
                    );
                  },
                );
    }
  }

  void savetokenlogin(UserModel userModel) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', userModel.token ?? '');
    await pref.setInt('userId', userModel.id ?? 0);
    await pref.setString('role', userModel.akses ?? "");
    await pref.setString('pin', userModel.pin ?? "");
    // ignore: use_build_context_synchronously

    if (userModel.akses.toString() == "admin") {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreenAdmin(),
          ),
          (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => NavBotBar(),
          ),
          (route) => false);
    }
  }

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool ishide = true;
  bool load = false;
  @override
  Widget build(BuildContext context) {
    return load
        ? isloadingwidget()
        : Scaffold(
            backgroundColor: primarycolor,
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: secondarycolorhigh,
                  )),
              automaticallyImplyLeading: false,
              backgroundColor: primarycolor,
              elevation: 0,
              centerTitle: true,
              title: Text(
                "Masuk",
                style: GoogleFonts.poppins(
                    color: secondarycolorhigh, fontWeight: FontWeight.w600),
              ),
            ),
            body: ListView(
              children: [
                SizedBox(
                  height: 50,
                ),
                Container(
                  width: double.infinity,
                  height: 150,
                  child: SvgPicture.asset('Asset/Svg/LoginAssets.svg'),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Form(key: formkey, child: inputdesign()),
                ),
                Container(
                  margin: EdgeInsets.only(right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                          onTap: () {},
                          child: Text(
                            "Lupa Password?",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          )),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 20),
                        width: 148,
                        height: 54,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterScreen(),
                                  ));
                            },
                            // ignore: sort_child_properties_last
                            child: Text(
                              "Daftar",
                              style: TextStyle(
                                  color: secondarycolorhigh,
                                  fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(color: secondarycolorhigh),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: 0,
                              primary: primarycolor,
                            )),
                      ),
                      Container(
                        width: 148,
                        height: 54,
                        child: ElevatedButton(
                            onPressed: () {
                              if (formkey.currentState!.validate()) {
                                setState(() {
                                  load = true;
                                });
                                _login();
                              }
                            },
                            // ignore: sort_child_properties_last
                            child: Text(
                              "Masuk",
                              style: TextStyle(
                                  color: primarycolor,
                                  fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: 0,
                              primary: secondarycolorhigh,
                            )),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
  }

  Widget inputdesign() {
    return Column(
      children: [
        Container(
          child: TextFormField(
              style: TextStyle(color: surfacecolor),
              controller: email,
              validator: (val) =>
                  val!.isEmpty ? 'Mohon Masukkan Email Anda!' : null,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  filled: true,
                  fillColor: inputtxtbg,
                  prefixIcon: Icon(
                    Icons.email,
                    color: surfacecolor,
                  ),
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 12,
                  ),
                  hintText: 'masukkan email anda')),
        ),
        Container(
          margin: EdgeInsets.only(top: 15),
          child: TextFormField(
              style: TextStyle(color: surfacecolor),
              controller: password,
              validator: (val) =>
                  val!.isEmpty ? 'Mohon Masukkan Password Anda!' : null,
              obscureText: ishide ? true : false,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          ishide = !ishide;
                        });
                      },
                      icon: Icon(
                        ishide ? Icons.visibility : Icons.visibility_off,
                        color: surfacecolor,
                      )),
                  filled: true,
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 12,
                  ),
                  fillColor: inputtxtbg,
                  prefixIcon: Icon(
                    Icons.lock,
                    color: surfacecolor,
                  ),
                  hintText: 'masukkan password')),
        ),
      ],
    );
  }
}
