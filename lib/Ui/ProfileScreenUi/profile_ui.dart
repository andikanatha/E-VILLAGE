// ignore_for_file: prefer_const_constructors

import 'package:e_villlage/Data/Model/ApiResponse.dart';
import 'package:e_villlage/Data/Model/UserModel.dart';
import 'package:e_villlage/Data/Services/user_services.dart';
import 'package:e_villlage/Ui/GetStarted/Login_ui.dart';
import 'package:e_villlage/Ui/NotificationUi/notification_ui.dart';
import 'package:e_villlage/Ui/ProfileScreenUi/akunscreen_ui.dart';
import 'package:e_villlage/Ui/Theme.dart';
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
    } else if (response.error != null) {
      isload = false;
      error = true;
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
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Column(
              children: [
                Container(
                  color: Theme.of(context).colorScheme.primary,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Profil", style: appbartitlestyle),
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
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(100),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color.fromARGB(18, 0, 0, 0),
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
                                            child: const Icon(
                                                Icons.notifications)))),
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
                                    color: Color.fromARGB(255, 228, 228, 228)),
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
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        color: primarycolor,
                      ),
                      child: Container(
                        margin: EdgeInsets.all(25),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: primarycolor,
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
                                        builder: (context) => AccountScreen(),
                                      ));
                                },
                                trailing: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: secondarycolor,
                                ),
                                leading: Icon(
                                  Icons.people,
                                  color: secondarycolor,
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
                                color: primarycolor,
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
                                  color: secondarycolor,
                                ),
                                leading: Icon(
                                  Icons.settings,
                                  color: secondarycolor,
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
                                color: primarycolor,
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
                                  color: secondarycolor,
                                ),
                                leading: Icon(
                                  Icons.help,
                                  color: secondarycolor,
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
                                color: primarycolor,
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
                                                              (route) => false)
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
