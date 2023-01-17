// ignore_for_file: prefer_const_constructors, sort_child_properties_last, file_names, unrelated_type_equality_checks

import 'package:e_villlage/Data/Model/ApiResponse.dart';
import 'package:e_villlage/Data/Model/UserModel.dart';
import 'package:e_villlage/Data/Services/user_services.dart';
import 'package:e_villlage/Data/settings.dart';
import 'package:e_villlage/Ui/Admin/HomescreenAdminUI.dart';
import 'package:e_villlage/Ui/GetStarted/Login_ui.dart';
import 'package:e_villlage/Ui/Theme.dart';
import 'package:e_villlage/Ui/Widget/LoadWidget.dart';
import 'package:e_villlage/Ui/Widget/Navbar.dart';
import 'package:e_villlage/Ui/Widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String pin = "0000";
  void _registeruser() async {
    ApiResponse response = await registerUser(
        username: username.text,
        name: name.text,
        pin: pin,
        email: email.text,
        password: password.text);
    if (response.data != null) {
      savetoken(response.data as UserModel);
    } else if (response.error == alreadyemailuse) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Peringatan gagal mendaftar"),
            content: Text(
                "Username atau Email yang kamu gunakan untuk mendaftar telah terdaftar sebelumnya, silahkan login sekarang"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      load = false;
                    });
                  },
                  child: Text("Tidak")),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ));
                  },
                  child: Text("Ya"))
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Terjadi Kesalahan"),
            content:
                Text("Mohon maaf sedang terjadi kesalahan, coba lagi nanti"),
            actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      load = false;
                    });
                    Navigator.pop(context);
                  },
                  child: Text("Oke"))
            ],
          );
        },
      );
    }
  }

  void savetoken(UserModel userModel) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', userModel.token ?? '');
    await pref.setInt('userId', userModel.id ?? 0);
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

  TextEditingController username = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController passwordconfrimation = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool ishide = true;
  bool ishideconfirm = true;
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
              backgroundColor: primarycolor,
              elevation: 0,
              centerTitle: true,
              title: Text(
                "Daftar",
                style: GoogleFonts.poppins(
                    color: secondarycolorhigh, fontWeight: FontWeight.w600),
              ),
            ),
            body: ListView(
              children: [
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: double.infinity,
                  height: 150,
                  child: SvgPicture.asset('Asset/Svg/LoginAssets.svg'),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Form(key: formkey, child: inputdesign()),
                ),
                Container(
                  margin:
                      EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                  child: longbtn(
                      ontap: () {
                        if (formkey.currentState!.validate()) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Buat Pin Anda"),
                                content: Form(
                                    child: PinCodeTextField(
                                  onCompleted: (value) {
                                    setState(() {
                                      pin = value;
                                      load = true;
                                    });
                                    _registeruser();
                                    Navigator.pop(context);
                                  },
                                  keyboardType: TextInputType.number,
                                  pinTheme: PinTheme(
                                    fieldHeight: 50,
                                    fieldWidth: 40,
                                    activeFillColor: Colors.grey,
                                  ),
                                  length: 4,
                                  appContext: context,
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                )),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Batal",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              );
                            },
                          );
                        }
                      },
                      text: "Daftar"),
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
              controller: username,
              validator: (val) =>
                  val!.isEmpty ? 'Mohon Masukkan Username Anda!' : null,
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
                  hintStyle: GoogleFonts.poppins(fontSize: 12, color: hinttext),
                  prefixIcon: Icon(
                    Icons.people,
                    color: surfacecolor,
                  ),
                  hintText: 'masukkan username anda')),
        ),
        Container(
          margin: EdgeInsets.only(top: 15),
          child: TextFormField(
              style: TextStyle(color: surfacecolor),
              controller: name,
              validator: (val) =>
                  val!.isEmpty ? 'Mohon Masukkan Nama Lengkap Anda!' : null,
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
                  hintStyle: GoogleFonts.poppins(
                    color: hinttext,
                    fontSize: 12,
                  ),
                  prefixIcon: Icon(
                    Icons.people,
                    color: surfacecolor,
                  ),
                  hintText: 'masukkan nama lengkap')),
        ),
        Container(
          margin: EdgeInsets.only(top: 15),
          child: TextFormField(
              style: TextStyle(color: surfacecolor),
              keyboardType: TextInputType.emailAddress,
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
                  hintStyle: GoogleFonts.poppins(
                    color: hinttext,
                    fontSize: 12,
                  ),
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: surfacecolor,
                  ),
                  hintText: 'masukkan email anda')),
        ),
        Container(
          margin: EdgeInsets.only(top: 15),
          child: TextFormField(
              style: TextStyle(color: surfacecolor),
              obscureText: ishide ? true : false,
              controller: password,
              validator: (val) => val!.length < 6
                  ? 'Minimal panjang password adalah 6 karakter'
                  : null,
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
                  hintStyle: GoogleFonts.poppins(
                    color: hinttext,
                    fontSize: 12,
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
                  prefixIcon: Icon(
                    Icons.lock,
                    color: surfacecolor,
                  ),
                  hintText: 'masukkan password')),
        ),
        Container(
          margin: EdgeInsets.only(top: 15),
          child: TextFormField(
              style: TextStyle(color: surfacecolor),
              obscureText: ishideconfirm ? true : false,
              controller: passwordconfrimation,
              validator: (val) => val != password.text
                  ? 'Konfirmasi password tidak sesuai!'
                  : null,
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
                  hintStyle: GoogleFonts.poppins(
                    color: hinttext,
                    fontSize: 12,
                  ),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          ishideconfirm = !ishideconfirm;
                        });
                      },
                      icon: Icon(
                        ishideconfirm ? Icons.visibility : Icons.visibility_off,
                        color: surfacecolor,
                      )),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: surfacecolor,
                  ),
                  hintText: 'konfirmasi password')),
        ),
      ],
    );
  }
}
