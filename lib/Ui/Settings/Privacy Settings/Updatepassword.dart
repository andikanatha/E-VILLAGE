import 'package:e_villlage/Data/LocalSettings.dart';
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
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PasswordUpdate extends StatefulWidget {
  PasswordUpdate({Key? key}) : super(key: key);

  @override
  State<PasswordUpdate> createState() => _PrivasiSettingsState();
}

class _PrivasiSettingsState extends State<PasswordUpdate> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String pin = "";
  bool isload = false;
  bool error = true;

  void updatepw() async {
    ApiResponse response = await updatepassword(
        current: passwordlama.text, password: passwordbaru.text);

    if (response.data != null) {
      setState(() {
        isload = false;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => NavBotBar(),
            ),
            (route) => false);
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.data.toString())));
    } else if (response.error == unauthroized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false)
          });
    } else {
      setState(() {
        isload = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  TextEditingController passwordlama = TextEditingController();
  TextEditingController passwordbaru = TextEditingController();
  TextEditingController passwordbarukonfirm = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isload
        ? Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: defaultappbar(
              title: "Ganti Password",
              btncek: ModalRoute.of(context)?.canPop ?? false,
              ontap: () {
                Navigator.pop(context);
              },
              backgroundcolor: Theme.of(context).colorScheme.primary,
            ),
            backgroundColor: secondarycolor,
            body: Container(
              decoration: BoxDecoration(
                  color: primarycolor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Form(
                key: formkey,
                child: ListView(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Container(
                            child: TextFormField(
                                style: TextStyle(color: surfacecolor),
                                controller: passwordlama,
                                validator: (val) => val!.isEmpty
                                    ? 'Mohon Masukkan Password Lama Anda!'
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
                                      color: hinttext,
                                    ),
                                    hintText: 'masukkan password lama anda')),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Container(
                            child: TextFormField(
                                style: TextStyle(color: surfacecolor),
                                controller: passwordbaru,
                                validator: (val) => val!.isEmpty
                                    ? 'Mohon Masukkan Password Baru Anda!'
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
                                      color: hinttext,
                                    ),
                                    hintText: 'masukkan password baru anda')),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Container(
                            child: TextFormField(
                                style: TextStyle(color: surfacecolor),
                                controller: passwordbarukonfirm,
                                validator: (val) => val != passwordbaru.text
                                    ? 'Password yang anda masukkan tidak sesuai'
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
                                      color: hinttext,
                                    ),
                                    hintText: 'konfirmasi password baru anda')),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 250,
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: longbtn(
                            ontap: () {
                              if (formkey.currentState!.validate()) {
                                if (passwordbaru.text == passwordlama.text) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Perhatian"),
                                        content: Text(
                                            "Password baru anda tidak boleh sama dengan password lama anda"),
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
                                } else {
                                  setState(() {
                                    isload = true;
                                    updatepw();
                                  });
                                }
                              }
                            },
                            text: "Perbarui Password"))
                  ],
                ),
              ),
            ),
          );
  }
}
