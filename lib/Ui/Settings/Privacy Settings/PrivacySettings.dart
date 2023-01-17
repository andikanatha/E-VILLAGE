import 'package:e_villlage/Data/LocalSettings.dart';
import 'package:e_villlage/Data/Services/user_services.dart';
import 'package:e_villlage/Ui/Settings/Privacy%20Settings/Currentpininput.dart';
import 'package:e_villlage/Ui/Settings/Privacy%20Settings/Updatepassword.dart';
import 'package:e_villlage/Ui/Theme.dart';
import 'package:e_villlage/Ui/Widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivasiSettings extends StatefulWidget {
  PrivasiSettings({Key? key}) : super(key: key);

  @override
  State<PrivasiSettings> createState() => _PrivasiSettingsState();
}

class _PrivasiSettingsState extends State<PrivasiSettings> {
  bool fingerprintsettings = false;
  String pin = "";
  void getsettings() async {
    String pinget = await getpin();
    bool fingerprintsettingsget = await getFingersettings();
    setState(() {
      pin = pinget;
      fingerprintsettings = fingerprintsettingsget;
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: defaultappbar(
        title: "Privasi",
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
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: boxcolor,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(37, 0, 0, 0),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ListTile(
                      onTap: () async {
                        final reLoadPage = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Currentpinupdate(),
                            ));
                        if (!mounted) return;
                        setState(() {
                          getsettings();
                        });
                      },
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: accentcolor,
                      ),
                      leading: Icon(
                        Icons.pin,
                        color: accentcolor,
                      ),
                      title: Text(
                        "Ganti pin",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: surfacecolor),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: boxcolor,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(37, 0, 0, 0),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ListTile(
                      onTap: () async {
                        final reLoadPage = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PasswordUpdate(),
                            ));
                        if (!mounted) return;
                        setState(() {
                          getsettings();
                        });
                      },
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: accentcolor,
                      ),
                      leading: Icon(
                        Icons.lock,
                        color: accentcolor,
                      ),
                      title: Text(
                        "Ganti password",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: surfacecolor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
