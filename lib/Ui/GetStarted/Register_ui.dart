// ignore_for_file: prefer_const_constructors, sort_child_properties_last, file_names, unrelated_type_equality_checks

import 'package:e_villlage/Data/Model/ApiResponse.dart';
import 'package:e_villlage/Data/Model/UserModel.dart';
import 'package:e_villlage/Data/Services/user_services.dart';
import 'package:e_villlage/Data/settings.dart';
import 'package:e_villlage/Ui/GetStarted/Login_ui.dart';
import 'package:e_villlage/Ui/Theme.dart';
import 'package:e_villlage/Ui/Widget/Navbar.dart';
import 'package:e_villlage/Ui/Widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  void _registeruser() async {
    ApiResponse response = await registerUser(
        username: username.text,
        name: name.text,
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
                "Email yang kamu gunakan untuk mendaftar telah terdaftar sebelumnya, silahkan login sekarang"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
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
    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => NavBotBar(),
        ),
        (route) => false);
  }

  TextEditingController username = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController passwordconfrimation = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool ishide = false;
  bool ishideconfirm = false;
  bool load = false;
  @override
  Widget build(BuildContext context) {
    return load
        ? Container(
            color: primarycolor,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
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
                Container(
                  margin: EdgeInsets.only(top: 20),
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("Asset/Image/amico.png"),
                          fit: BoxFit.fitHeight)),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Form(key: formkey, child: inputdesign()),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 50),
                  child: longbtn(
                      ontap: () {
                        if (formkey.currentState!.validate()) {
                          setState(() {
                            load = true;
                          });
                          _registeruser();
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
          margin: EdgeInsets.only(top: 15),
          child: TextFormField(
              controller: username,
              validator: (val) =>
                  val!.isEmpty ? 'Mohon Masukkan Nama Anda!' : null,
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
                    fontSize: 12,
                  ),
                  prefixIcon: Icon(
                    Icons.people,
                    color: surfacecolor,
                  ),
                  hintText: 'masukkan nama anda')),
        ),
        Container(
          margin: EdgeInsets.only(top: 15),
          child: TextFormField(
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
