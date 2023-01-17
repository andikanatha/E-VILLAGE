// ignore_for_file: prefer_const_constructors

import 'package:e_villlage/Data/LocalSettings.dart';
import 'package:e_villlage/Data/Model/ApiResponse.dart';
import 'package:e_villlage/Data/Model/UserModel.dart';
import 'package:e_villlage/Data/Services/user_services.dart';
import 'package:e_villlage/Data/settings.dart';
import 'package:e_villlage/Ui/GetStarted/Login_ui.dart';
import 'package:e_villlage/Ui/NotificationUi/notification_ui.dart';
import 'package:e_villlage/Ui/ProfileScreenUi/FaqUI.dart';
import 'package:e_villlage/Ui/ProfileScreenUi/akunscreen_ui.dart';
import 'package:e_villlage/Ui/Settings/PengaturanUI.dart';
import 'package:e_villlage/Ui/SuggestionUi/kelolaurunrembug_ui.dart';
import 'package:e_villlage/Ui/Theme.dart';
import 'package:e_villlage/Ui/Widget/ErrorWidget.dart';
import 'package:e_villlage/Ui/Widget/LoadWidget.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? user;
  bool error = false;
  bool isload = true;

  void getuser() async {
    ApiResponse response = await getuserdetail();
    if (response.data != null) {
      setState(() {
        error = false;
        isload = false;
        user = response.data as UserModel;
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primarycolor,
      body: isload
          ? isloadingwidget()
          : error
              ? iserror(ontap: () {
                  setState(() {
                    isload = true;
                    getuser();
                  });
                })
              : SafeArea(
                  child: ListView(
                  children: [
                    Container(
                      color: secondarycolor,
                      child: Container(
                        padding: EdgeInsets.only(bottom: 20),
                        margin: const EdgeInsets.only(top: 30),
                        child: Column(
                          children: [
                            Container(
                              height: 40,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("Profil",
                                              style: appbartitlestyle),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    right: 20,
                                    top: 0,
                                    child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: primarycolor,
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          boxShadow: const [
                                            BoxShadow(
                                              color:
                                                  Color.fromARGB(18, 0, 0, 0),
                                              spreadRadius: 2,
                                              blurRadius: 7,
                                              offset: Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const NotificationScreen(),
                                                  ));
                                            },
                                            child: Container(
                                                child: Icon(
                                              Icons.notifications,
                                              color: secondarycolorhigh,
                                            )))),
                                  )
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                      image: user!.image_user != null
                                          ? DecorationImage(
                                              image: NetworkImage(
                                                  user!.image_user.toString()),
                                              fit: BoxFit.cover)
                                          : DecorationImage(
                                              image: AssetImage(
                                                  "Asset/Image/default-image-user.png"),
                                              fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(100),
                                      color: defaultbgimg),
                                  padding: const EdgeInsets.all(5),
                                  margin: const EdgeInsets.only(top: 30),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  child: Text(
                                    user!.username ?? "Nama Pengguna",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    user!.name.toString(),
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 228, 228, 228)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Stack(
                      children: [
                        Container(
                          height: 200,
                          color: secondarycolor,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                            color: primarycolor,
                          ),
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 3),
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
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    onTap: () async {
                                      final reLoadPage = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AccountScreen(),
                                          ));
                                      if (!mounted) return;
                                      setState(() {
                                        isload = true;
                                        getuser();
                                      });
                                    },
                                    trailing: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: accentcolor,
                                    ),
                                    leading: Icon(
                                      Icons.people,
                                      color: accentcolor,
                                    ),
                                    title: Text(
                                      "Akun",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: surfacecolor),
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
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    onTap: () async {
                                      final reload = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PengaturanUI(),
                                          ));
                                      if (!mounted) return;
                                      setState(() {
                                        isload = true;
                                        getuser();
                                      });
                                    },
                                    trailing: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: accentcolor,
                                    ),
                                    leading: Icon(
                                      Icons.settings,
                                      color: accentcolor,
                                    ),
                                    title: Text(
                                      "Pengaturan",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: surfacecolor),
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
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FAQBANTUANUI(),
                                          ));
                                    },
                                    trailing: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: accentcolor,
                                    ),
                                    leading: Icon(
                                      Icons.help,
                                      color: accentcolor,
                                    ),
                                    title: Text(
                                      "FAQ dan bantuan",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: surfacecolor),
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
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                KelolaUrunRembug(),
                                          ));
                                    },
                                    trailing: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: accentcolor,
                                    ),
                                    leading: Icon(
                                      Icons.warning,
                                      color: accentcolor,
                                    ),
                                    title: Text(
                                      "Kelola urun rembug",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: surfacecolor),
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
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    trailing: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Colors.red,
                                    ),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text("Peringatan Logout!"),
                                            content: Text(
                                                "Apa kamu yakin untuk melakukan Logout?"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Tidak")),
                                              TextButton(
                                                  onPressed: () {
                                                    logout().then((value) => {
                                                          Navigator.of(context)
                                                              .pushAndRemoveUntil(
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              LoginScreen()),
                                                                  (route) =>
                                                                      false)
                                                        });
                                                  },
                                                  child: Text("Ya"))
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    leading: const Icon(
                                      Icons.logout,
                                      color: Colors.red,
                                    ),
                                    title: const Text(
                                      "Keluar",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
    );
  }
}
