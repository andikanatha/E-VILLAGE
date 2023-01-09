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

class UpdatePin extends StatefulWidget {
  UpdatePin({Key? key}) : super(key: key);

  @override
  State<UpdatePin> createState() => _PrivasiSettingsState();
}

class _PrivasiSettingsState extends State<UpdatePin> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String pin = "";
  bool isload = false;
  bool error = true;

  void updatepinn() async {
    ApiResponse response = await updatepin(pin: pininput.toString());

    if (response.data != null) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('pin', pininput.toString());
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

  String? pininput;
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
                        Text(
                          "Masukkan pin baru",
                        ),
                      ],
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                      child: PinCodeTextField(
                        onCompleted: (value) {
                          setState(() {
                            pininput = value;
                          });
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Perhatian"),
                                content: Text(
                                    "Apa kamu yakin ingin merubah pin anda menjadi " +
                                        pininput.toString()),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        setState(() {
                                          pininput = "";
                                        });
                                      },
                                      child: Text("Tidak")),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        setState(() {
                                          isload = true;
                                          updatepinn();
                                        });
                                      },
                                      child: Text("Ya"))
                                ],
                              );
                            },
                          );
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
