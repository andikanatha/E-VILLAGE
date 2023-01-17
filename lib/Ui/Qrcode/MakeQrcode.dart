import 'package:e_villlage/Data/LocalSettings.dart';
import 'package:e_villlage/Data/Model/ApiResponse.dart';
import 'package:e_villlage/Data/Model/UserModel.dart';
import 'package:e_villlage/Data/Services/user_services.dart';
import 'package:e_villlage/Data/settings.dart';
import 'package:e_villlage/Ui/GetStarted/Login_ui.dart';
import 'package:e_villlage/Ui/Theme.dart';
import 'package:e_villlage/Ui/Widget/LoadWidget.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReqQrCode extends StatefulWidget {
  ReqQrCode({Key? key}) : super(key: key);

  @override
  State<ReqQrCode> createState() => _ReqQrCodeState();
}

class _ReqQrCodeState extends State<ReqQrCode> {
  UserModel? user;
  bool isload = true;
  bool error = false;
  bool isdark = false;

  void getuser() async {
    bool theme = await getisDarkTheme();
    setState(() {
      isdark = theme;
    });
    ApiResponse response = await getuserdetail();
    if (response.data != null) {
      setState(() {
        error = false;
        user = response.data as UserModel;
        isload = false;
      });
    } else if (response.error == unauthroized) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
          (route) => false);
    } else {
      setState(() {
        isload = false;
        error = true;
      });
    }
  }

  @override
  void initState() {
    getuser();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isload
        ? isloadingwidget()
        : Scaffold(
            backgroundColor: secondarycolor,
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
              ),
              automaticallyImplyLeading: false,
              title: Text(
                "Permintaan Saldo",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: secondarycolor,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: boxcolor),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        QrImage(
                          foregroundColor: surfacecolor,
                          data: user!.username.toString(),
                          version: QrVersions.auto,
                          size: 250.0,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Scan QR Code",
                          style: TextStyle(
                              color: secondarycolorhigh,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        Text(
                          "Scan QR Code untuk bayar",
                          style: TextStyle(
                              color: isdark ? Colors.white : Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: 13),
                        )
                      ],
                    )),
              ],
            ),
          );
  }
}
