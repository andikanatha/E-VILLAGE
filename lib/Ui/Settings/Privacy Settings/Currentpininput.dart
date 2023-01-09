import 'package:e_villlage/Data/LocalSettings.dart';
import 'package:e_villlage/Data/Model/ApiResponse.dart';
import 'package:e_villlage/Data/Model/UserModel.dart';
import 'package:e_villlage/Data/Services/user_services.dart';
import 'package:e_villlage/Data/settings.dart';
import 'package:e_villlage/Ui/GetStarted/Login_ui.dart';
import 'package:e_villlage/Ui/Settings/Privacy%20Settings/Updatepin.dart';
import 'package:e_villlage/Ui/Theme.dart';
import 'package:e_villlage/Ui/Widget/Navbar.dart';
import 'package:e_villlage/Ui/Widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Currentpinupdate extends StatefulWidget {
  Currentpinupdate({Key? key}) : super(key: key);

  @override
  State<Currentpinupdate> createState() => _PrivasiSettingsState();
}

class _PrivasiSettingsState extends State<Currentpinupdate> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String pin = "";
  bool isload = false;
  bool haserror = false;
  bool error = true;

  void getsettings() async {
    String pinget = await getpin();
    bool fingerprintsettingsget = await getFingersettings();
    setState(() {
      pin = pinget;
    });
  }

  @override
  void initState() {
    getsettings();
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
              title: "Ganti Pin",
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
                      height: 80,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        haserror
                            ? Text(
                                "Pin yang anda masukkan salah",
                                style: TextStyle(color: Colors.red),
                              )
                            : Text(
                                "Masukkan pin lama",
                                style: TextStyle(color: surfacecolor),
                              ),
                      ],
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                      child: PinCodeTextField(
                        onCompleted: (value) {
                          if (value == pin) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdatePin(),
                                ));
                          } else {
                            setState(() {
                              haserror = true;
                            });
                          }
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
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
