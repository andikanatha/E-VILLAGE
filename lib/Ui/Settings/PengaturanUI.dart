import 'package:e_villlage/Data/LocalSettings.dart';
import 'package:e_villlage/Ui/ProfileScreenUi/FaqUI.dart';
import 'package:e_villlage/Ui/Settings/Privacy%20Settings/PrivacySettings.dart';
import 'package:e_villlage/Ui/Theme.dart';
import 'package:e_villlage/Ui/Widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PengaturanUI extends StatefulWidget {
  const PengaturanUI({Key? key}) : super(key: key);

  @override
  State<PengaturanUI> createState() => _PengaturanUIState();
}

class _PengaturanUIState extends State<PengaturanUI> {
  var selectedValue = ThemeSelect.light;
  int _index = 0;

  void getsettings() async {
    bool themeget = await getisDarkTheme();

    if (themeget == true) {
      selectedValue = ThemeSelect.dark;
    } else {
      selectedValue = ThemeSelect.light;
    }
  }

  void setbool() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (selectedValue == ThemeSelect.dark) {
      await pref.setBool('theme', true);
      setState(() {
        primarycolor = Color.fromARGB(255, 33, 73, 98);
        accentcolor = Colors.white;
        secondarycolor = Color.fromARGB(255, 22, 53, 72);
        boxcolor = Color.fromARGB(255, 65, 103, 126);
        surfacecolor = Colors.white;
        inputtxtbg = Color.fromARGB(255, 65, 103, 126);
      });
    } else {
      await pref.setBool('theme', false);
      setState(() {
        surfacecolor = Colors.black;
        secondarycolor = const Color.fromARGB(255, 48, 167, 207);
        boxcolor = Colors.white;
        inputtxtbg = Color.fromARGB(255, 218, 236, 242);
        primarycolor = Colors.white;
        accentcolor = Color.fromARGB(255, 130, 222, 255);
      });
    }
    getsettings();
  }

  @override
  void initState() {
    getsettings();
    // TODO: implement initState
    super.initState();
  }

  void _showModalSheet(int i) {
    showModalBottomSheet(
        backgroundColor: primarycolor,
        context: context,
        builder: (builder) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            height: 170,
            child: Column(
              children: [
                RadioListTile<ThemeSelect>(
                    title: Text(
                      'Light',
                      style: TextStyle(
                        color: surfacecolor,
                      ),
                    ),
                    value: ThemeSelect.light,
                    groupValue: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value!;
                        setbool();
                        Navigator.pop(context);
                      });
                    }),
                RadioListTile<ThemeSelect>(
                  title: Text('Dark',
                      style: TextStyle(
                        color: surfacecolor,
                      )),
                  value: ThemeSelect.dark,
                  groupValue: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value!;
                      setbool();
                      Navigator.pop(context);
                    });
                  },
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: defaultappbar(
        title: "Pengaturan",
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
                      onTap: () {
                        _index = _index + 1;
                        _showModalSheet(_index);
                      },
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: surfacecolor,
                      ),
                      leading: Icon(
                        Icons.help,
                        color: surfacecolor,
                      ),
                      title: Text(
                        "Tema",
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
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PrivasiSettings(),
                            ));
                      },
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: surfacecolor,
                      ),
                      leading: Icon(
                        Icons.help,
                        color: surfacecolor,
                      ),
                      title: Text(
                        "Privasi",
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

enum ThemeSelect { light, dark }
