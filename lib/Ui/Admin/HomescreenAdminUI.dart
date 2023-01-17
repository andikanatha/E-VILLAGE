import 'package:e_villlage/Data/Formated/dayformated.dart';
import 'package:e_villlage/Data/Formated/formated.dart';
import 'package:e_villlage/Data/Model/ApiResponse.dart';
import 'package:e_villlage/Data/Model/UserModel.dart';
import 'package:e_villlage/Data/Services/user_services.dart';
import 'package:e_villlage/Data/settings.dart';
import 'package:e_villlage/Icons/admin_menu_icons_icons.dart';
import 'package:e_villlage/Ui/Admin/DataPengeluaran.dart';
import 'package:e_villlage/Ui/Admin/KonfirmasiTopupSaldo.dart';
import 'package:e_villlage/Ui/Admin/LaporKadesUI.dart';
import 'package:e_villlage/Ui/Admin/LaporanPDAM.dart';
import 'package:e_villlage/Ui/Admin/LaporanUrunRembug.dart';
import 'package:e_villlage/Ui/Admin/LaporansampahUI.dart';
import 'package:e_villlage/Ui/GetStarted/Login_ui.dart';
import 'package:e_villlage/Ui/ProfileScreenUi/FaqUI.dart';
import 'package:e_villlage/Ui/ProfileScreenUi/akunscreen_ui.dart';
import 'package:e_villlage/Ui/Settings/PengaturanUI.dart';
import 'package:e_villlage/Ui/Theme.dart';
import 'package:e_villlage/Ui/Widget/ErrorWidget.dart';
import 'package:e_villlage/Ui/Widget/LoadWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreenAdmin extends StatefulWidget {
  const HomeScreenAdmin({Key? key}) : super(key: key);

  @override
  State<HomeScreenAdmin> createState() => _HomeScreenAdminState();
}

class _HomeScreenAdminState extends State<HomeScreenAdmin> {
  int hoursnow = 0;
  String greeting = "";
  String datenow = "0000-00-00";
  String? token;

  getCurrentDate() {
    var date = DateTime.now();
    var dateParse = DateTime.parse(date.toString());
    var formattedhours = "${dateParse.hour}";

    setState(() {
      hoursnow = int.parse(formattedhours);
      datenow = dateParse.toString();
    });

    if (hoursnow >= 5 && hoursnow < 11) {
      setState(() {
        greeting = "Selamat Pagi";
      });
    } else if (hoursnow >= 11 && hoursnow < 15) {
      setState(() {
        greeting = "Selamat Siang";
      });
    } else if (hoursnow >= 15 && hoursnow < 18) {
      setState(() {
        greeting = "Selamat Sore";
      });
    } else if (hoursnow >= 18 && hoursnow <= 24) {
      setState(() {
        greeting = "Selamat Malam";
      });
    } else if (hoursnow >= 0 && hoursnow < 5) {
      setState(() {
        greeting = "Selamat Malam";
      });
    }
  }

  UserModel? user;
  bool error = false;
  bool isload = true;

  void getuser() async {
    String token2 = await getUserrole();
    ApiResponse response = await getuserdetail();
    if (response.data != null) {
      setState(() {
        token = token2;
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

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    getCurrentDate();
    getuser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
        backgroundColor: primarycolor,
        child: ListView(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xff4BC4F1),
                ),
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: SvgPicture.asset("Asset/Svg/iconapk.svg"))),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: ListTile(
                onTap: () async {
                  final reLoadPage = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AccountScreen(),
                      ));
                  if (!mounted) return;
                  setState(() {
                    isload = true;
                    getuser();
                  });
                },
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: surfacecolor,
                ),
                leading: Icon(
                  Icons.people,
                  color: surfacecolor,
                ),
                title: Text(
                  "Akun",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: surfacecolor),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: ListTile(
                onTap: () async {
                  final reLoadPage = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PengaturanUI(),
                      ));
                  if (!mounted) return;
                  setState(() {
                    isload = true;
                    getuser();
                  });
                },
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: surfacecolor,
                ),
                leading: Icon(
                  Icons.settings,
                  color: surfacecolor,
                ),
                title: Text(
                  "Pengaturan",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: surfacecolor),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: ListTile(
                onTap: () async {
                  final reLoadPage = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FAQBANTUANUI(),
                      ));
                  if (!mounted) return;
                  setState(() {
                    isload = true;
                    getuser();
                  });
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
                  "FAQ dan bantuan",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: surfacecolor),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
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
                        content: Text("Apa kamu yakin untuk melakukan Logout?"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Tidak")),
                          TextButton(
                              onPressed: () {
                                logout().then((value) => {
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) =>
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
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
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
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Expanded(
                              child: Container(
                            color: secondarycolor,
                          )),
                          Expanded(flex: 2, child: Container())
                        ],
                      ),
                      ListView(
                        children: [
                          Container(
                            color: secondarycolor,
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 20, bottom: 20),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                user!.username.toString() !=
                                                        null
                                                    ? "Halo, " +
                                                        user!.username
                                                            .toString()
                                                    : "Halo, " + "Admin",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                greeting,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                formatdayIndo(date: datenow) +
                                                    ", " +
                                                    formatTglIndo(
                                                        date: datenow),
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color.fromARGB(
                                                      18, 0, 0, 0),
                                                  spreadRadius: 2,
                                                  blurRadius: 7,
                                                  offset: Offset(0,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: InkWell(
                                                onTap: () => _scaffoldKey
                                                    .currentState!
                                                    .openEndDrawer(),
                                                child: Container(
                                                    child: const Icon(
                                                        Icons.menu))))
                                      ],
                                    ))
                                  ],
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: primarycolor,
                                      borderRadius: BorderRadius.circular(20)),
                                  margin: const EdgeInsets.only(top: 20),
                                  child: Stack(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                              height: 85,
                                              child: Image.asset(
                                                  "Asset/Image/asset-icon-saldo.png")),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(20),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 85,
                                        child: Container(
                                            width: 220,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      Idrcvt.convertToIdr(
                                                          count: int.parse(
                                                              user!.saldo),
                                                          decimalDigit: 2),
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: accentcolor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20)),
                                color: primarycolor),
                            child: Column(
                              children: [
                                Wrap(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        final reLoadPage = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  LaporanSampah(),
                                            ));
                                        if (!mounted) return;
                                        setState(() {
                                          isload = true;
                                          getuser();
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(20),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        height: 150,
                                        width: 150,
                                        decoration: BoxDecoration(
                                            color: boxcolor,
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
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Icon(
                                                AdminMenuIcons.trash,
                                                color: accentcolor,
                                                size: 40,
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "Laporan pemasukan uang sampah",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 10,
                                                        color: surfacecolor),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        final reLoadPage = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  LaporanPdam(),
                                            ));
                                        if (!mounted) return;
                                        setState(() {
                                          isload = true;
                                          getuser();
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(20),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        height: 150,
                                        width: 150,
                                        decoration: BoxDecoration(
                                            color: boxcolor,
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
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Icon(
                                                AdminMenuIcons.water,
                                                color: accentcolor,
                                                size: 40,
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "Laporan pemasukan uang PDAM",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 10,
                                                        color: surfacecolor),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        final reLoadPage = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  KonfirmasiTOPUPSaldo(),
                                            ));
                                        if (!mounted) return;
                                        setState(() {
                                          isload = true;
                                          getuser();
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(20),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        height: 150,
                                        width: 150,
                                        decoration: BoxDecoration(
                                            color: boxcolor,
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
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Icon(
                                                AdminMenuIcons.money,
                                                size: 40,
                                                color: accentcolor,
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "Konfirmasi top-up saldo",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 10,
                                                        color: surfacecolor),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        final reLoadPage = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  LaporanPengeluaran(),
                                            ));
                                        if (!mounted) return;
                                        setState(() {
                                          isload = true;
                                          getuser();
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(20),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        height: 150,
                                        width: 150,
                                        decoration: BoxDecoration(
                                            color: boxcolor,
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
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Icon(
                                                AdminMenuIcons.dompet,
                                                size: 40,
                                                color: accentcolor,
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "Tambah Pengeluaran",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 10,
                                                        color: surfacecolor),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        final reLoadPage = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  LaporKadesAdminUI(),
                                            ));
                                        if (!mounted) return;
                                        setState(() {
                                          isload = true;
                                          getuser();
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(20),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        height: 150,
                                        width: 150,
                                        decoration: BoxDecoration(
                                            color: boxcolor,
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
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Icon(
                                                Icons.warning,
                                                size: 40,
                                                color: accentcolor,
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "Laporan Warga",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 10,
                                                        color: surfacecolor),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        final reLoadPage = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  LaporUrunRembug(),
                                            ));
                                        if (!mounted) return;
                                        setState(() {
                                          isload = true;
                                          getuser();
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(20),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        height: 150,
                                        width: 150,
                                        decoration: BoxDecoration(
                                            color: boxcolor,
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
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Icon(
                                                Icons.warning,
                                                size: 40,
                                                color: accentcolor,
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "Laporan Urun Rembug & Kelola",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 10,
                                                        color: surfacecolor),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }
}
