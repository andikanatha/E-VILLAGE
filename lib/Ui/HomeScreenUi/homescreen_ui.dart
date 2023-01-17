import 'dart:convert';

import 'package:e_villlage/Data/Formated/dayformated.dart';
import 'package:e_villlage/Data/Formated/formated.dart';
import 'package:e_villlage/Data/LocalSettings.dart';
import 'package:e_villlage/Data/Model/ApiResponse.dart';
import 'package:e_villlage/Data/Model/PembayaranModelGet.dart';
import 'package:e_villlage/Data/Model/RembugModel.dart';
import 'package:e_villlage/Data/Model/UserModel.dart';
import 'package:e_villlage/Data/Services/ReportRembug_services.dart';
import 'package:e_villlage/Data/Services/rembug_services.dart';
import 'package:e_villlage/Data/Services/user_services.dart';
import 'package:e_villlage/Data/settings.dart';
import 'package:e_villlage/Icons/feature_icons_icons.dart';
import 'package:e_villlage/Ui/GetStarted/Login_ui.dart';
import 'package:e_villlage/Ui/LaporKades/postLaporKadesUI.dart';
import 'package:e_villlage/Ui/NotificationUi/notification_ui.dart';
import 'package:e_villlage/Ui/PembayaranUI/KirimsaldoUI.dart';
import 'package:e_villlage/Ui/PembayaranUI/ListtopupsaldoUI.dart';
import 'package:e_villlage/Ui/PembayaranUI/PembayaranDetail.dart';
import 'package:e_villlage/Ui/PembayaranUI/PembayaranUI.dart';
import 'package:e_villlage/Ui/PembayaranUI/TopupSaldoUI.dart';
import 'package:e_villlage/Ui/Qrcode/MakeQrcode.dart';
import 'package:e_villlage/Ui/RiwayatUi/riwayat_ui.dart';
import 'package:e_villlage/Ui/SuggestionUi/CommentRembugUI.dart';
import 'package:e_villlage/Ui/SuggestionUi/Urunrembug_ui.dart';
import 'package:e_villlage/Ui/Theme.dart';
import 'package:e_villlage/Ui/Widget/ErrorWidget.dart';
import 'package:flutter/material.dart';
import 'package:inner_shadow_widget/inner_shadow_widget.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int hoursnow = 0;
  String greeting = "";
  String datenow = "0000-00-00";
  bool isdark = false;

  PembayaranModelGet? pembayaranModelGet;

  getCurrentDate() {
    var date = DateTime.now();
    var dateParse = DateTime.parse(date.toString());
    var formattedhours = "${dateParse.hour}";
    var formattedtime = "${dateParse.day} ${dateParse.hour}";

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
  String? dateenow;
  String? datenow2;
  int daynow = 0;

  TextEditingController deskripsitxt = TextEditingController();
  void _postreport(
      {required String? deskripsi,
      String? id_post,
      String? id_user_posts}) async {
    ApiResponse response = await reportrembug(
      deskripsi: deskripsi.toString(),
      id_post: id_post.toString(),
      id_user_posts: id_user_posts.toString(),
    );

    if (response.data != null) {
      setState(() {
        getuser();
        deskripsitxt.text = "";
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.data}')));
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

  RembugData? rembugData;
  void getuser() async {
    bool theme = await getisDarkTheme();
    String token = await getToken();

    DateTime dt = DateTime.parse(DateTime.now().toString());
    String daynoww = DateFormat('dd').format(dt);
    String datenoww = formatTglIndo(date: DateTime.now().toString());
    String datenoww2 = formatBulanIndo(date: DateTime.now().toString());

    final responsepembayaran = await http.get(
        Uri.parse(baseurl_evillageapi + "/api/user/transaksi/all"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
    ApiResponse responserembug = await getallrembug();
    ApiResponse response = await getuserdetail();
    if (response.data != null &&
        responserembug.data != null &&
        responsepembayaran.body != null) {
      setState(() {
        dateenow = datenoww;
        daynow = int.parse(daynoww);
        datenow2 = datenoww2;
        rembugData = responserembug.data as RembugData;
        error = false;
        pembayaranModelGet = PembayaranModelGet.fromJson(
            json.decode(responsepembayaran.body.toString()));
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

    setState(() {
      isdark = theme;
    });
  }

  @override
  void initState() {
    getCurrentDate();
    getuser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primarycolor,
      body: isload
          ? Center(
              child: CircularProgressIndicator.adaptive(),
            )
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
                          Expanded(child: Container())
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
                                      flex: 3,
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
                                                    : "Halo, Pengguna",
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
                                            margin: EdgeInsets.only(right: 5),
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: primarycolor,
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
                                                onTap: () async {
                                                  final reLoadPage =
                                                      await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    ReqQrCode(),
                                                          ));
                                                  if (!mounted) return;
                                                  setState(() {
                                                    isload = true;
                                                    getuser();
                                                  });
                                                },
                                                child: Container(
                                                    child: Icon(
                                                  Icons.qr_code,
                                                  color: secondarycolorhigh,
                                                )))),
                                        Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: primarycolor,
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
                                                onTap: () async {
                                                  final reLoadPage =
                                                      await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                NotificationScreen(),
                                                          ));
                                                  if (!mounted) return;
                                                  setState(() {
                                                    isload = true;
                                                    getuser();
                                                  });
                                                },
                                                child: Container(
                                                    child: Icon(
                                                  Icons.notifications,
                                                  color: secondarycolorhigh,
                                                ))))
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
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Saldo anda",
                                                            style: TextStyle(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: isdark
                                                                  ? accentcolor
                                                                  : Colors.grey,
                                                            ),
                                                          ),
                                                          Text(
                                                            Idrcvt.convertToIdr(
                                                                count: int
                                                                    .parse(user!
                                                                        .saldo),
                                                                decimalDigit:
                                                                    2),
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: isdark
                                                                  ? accentcolor
                                                                  : secondarycolor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 10,
                                                                    right: 10),
                                                            child: InkWell(
                                                              onTap: () async {
                                                                final reLoadPage =
                                                                    await Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              KirimSaldoUI(),
                                                                        ));
                                                                if (!mounted)
                                                                  return;
                                                                setState(() {
                                                                  isload = true;
                                                                  getuser();
                                                                });
                                                              },
                                                              child: Container(
                                                                width: 40,
                                                                height: 40,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  color:
                                                                      secondarycolorhigh,
                                                                ),
                                                                child: Center(
                                                                  child: Icon(
                                                                    Icons
                                                                        .arrow_upward,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          InkWell(
                                                            onTap: () async {
                                                              final reLoadPage =
                                                                  await Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                Listtopup(),
                                                                      ));
                                                              if (!mounted)
                                                                return;
                                                              setState(() {
                                                                isload = true;
                                                                getuser();
                                                              });
                                                            },
                                                            child: Container(
                                                              width: 40,
                                                              height: 40,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color:
                                                                    secondarycolorhigh,
                                                              ),
                                                              child: Center(
                                                                child: Icon(
                                                                  Icons.add,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 30),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () async {
                                            final reLoadPage =
                                                await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          PembayaranUI(
                                                        action: "sampah",
                                                      ),
                                                    ));
                                            if (!mounted) return;
                                            setState(() {
                                              isload = true;
                                              getuser();
                                            });
                                          },
                                          child: Column(
                                            children: [
                                              InnerShadow(
                                                blur: 10,
                                                color: Color.fromARGB(
                                                    119, 255, 255, 255),
                                                offset: const Offset(10, 8),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: secondarycolor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  height: 64,
                                                  width: 64,
                                                  child: Stack(
                                                    children: [
                                                      Center(
                                                        child: Icon(
                                                          FeatureIcons.trash,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 70,
                                                child: const Text(
                                                  "Sampah",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white,
                                                      fontSize: 10),
                                                  textAlign: TextAlign.center,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () async {
                                            final reLoadPage =
                                                await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          PembayaranUI(
                                                        action: "PDAM",
                                                      ),
                                                    ));
                                            if (!mounted) return;
                                            setState(() {
                                              isload = true;
                                              getuser();
                                            });
                                          },
                                          child: Column(
                                            children: [
                                              InnerShadow(
                                                blur: 10,
                                                color: Color.fromARGB(
                                                    119, 255, 255, 255),
                                                offset: const Offset(10, 8),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: secondarycolor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  height: 64,
                                                  width: 64,
                                                  child: Stack(
                                                    children: [
                                                      Center(
                                                        child: Icon(
                                                          FeatureIcons.water,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 70,
                                                child: const Text(
                                                  "Pdam",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white,
                                                      fontSize: 10),
                                                  textAlign: TextAlign.center,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () async {
                                            final reLoadPage =
                                                await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          SugestionScreen(),
                                                    ));
                                            if (!mounted) return;
                                            setState(() {
                                              isload = true;
                                              getuser();
                                            });
                                          },
                                          child: Column(
                                            children: [
                                              InnerShadow(
                                                blur: 10,
                                                color: Color.fromARGB(
                                                    119, 255, 255, 255),
                                                offset: const Offset(10, 8),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: secondarycolor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  height: 64,
                                                  width: 64,
                                                  child: Stack(
                                                    children: [
                                                      Center(
                                                        child: Icon(
                                                          FeatureIcons.people,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 70,
                                                child: const Text(
                                                  "Urun Rembug",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white,
                                                      fontSize: 10),
                                                  textAlign: TextAlign.center,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () async {
                                            final reLoadPage =
                                                await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          PostLaporKadesUI(),
                                                    ));
                                            if (!mounted) return;
                                            setState(() {
                                              isload = true;
                                              getuser();
                                            });
                                          },
                                          child: Column(
                                            children: [
                                              InnerShadow(
                                                blur: 10,
                                                color: Color.fromARGB(
                                                    119, 255, 255, 255),
                                                offset: const Offset(10, 8),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: secondarycolor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  height: 64,
                                                  width: 64,
                                                  child: Stack(
                                                    children: [
                                                      Center(
                                                        child: Icon(
                                                          Icons.warning,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 70,
                                                child: const Text(
                                                  "Lapor Kades",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white,
                                                      fontSize: 10),
                                                  textAlign: TextAlign.center,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20)),
                                color: primarycolor),
                            child: Column(
                              children: [activity(), highlight()],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget activity() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                    child: Row(
                  children: [
                    Text(
                      "Aktivitas",
                      style: TextStyle(
                          color: surfacecolor, fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RiwayatScreen(),
                            ));
                      },
                      child: const Text(
                        "Lihat lainnya",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ))
              ],
            ),
          ),
          Container(
              margin: const EdgeInsets.only(left: 20),
              height: 80,
              child: pembayaranModelGet!.dataTransaksi!.length > 0
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: pembayaranModelGet!.dataTransaksi!.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Detailpembayaran(
                                      id: int.parse(pembayaranModelGet!
                                          .dataTransaksi![index].id
                                          .toString())),
                                ));
                          },
                          child: Container(
                            height: 60,
                            margin: const EdgeInsets.only(
                                right: 20, top: 10, bottom: 10),
                            decoration: BoxDecoration(
                                color: boxcolor,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromARGB(18, 0, 0, 0),
                                    spreadRadius: 2,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(15)),
                            width: 231,
                            child: Row(
                              children: [
                                Container(
                                    width: 10,
                                    decoration: BoxDecoration(
                                      color: secondarycolor,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          bottomLeft: Radius.circular(15)),
                                    )),
                                Container(
                                    margin: const EdgeInsets.only(left: 20),
                                    width: 160,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              pembayaranModelGet!
                                                  .dataTransaksi![index].trxName
                                                  .toString(),
                                              style: TextStyle(
                                                  color: surfacecolor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              Idrcvt.convertToIdr(
                                                  count: int.parse(
                                                      pembayaranModelGet!
                                                          .dataTransaksi![index]
                                                          .totalTrx
                                                          .toString()),
                                                  decimalDigit: 2),
                                              style: TextStyle(
                                                  fontSize: 9,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )
                                      ],
                                    )),
                                Container(
                                    margin: EdgeInsets.only(left: 7),
                                    child: InkWell(
                                      child: Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: accentcolor,
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        "Belum ada aktivitas terbaru nih...",
                        style: TextStyle(color: hinttext),
                      ),
                    ))
        ],
      ),
    );
  }

  Widget highlight() {
    return Container(
      margin: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Urun Rembug Teratas",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: surfacecolor),
              ),
            ],
          ),
          Container(
              child: rembugData!.rembug!.length > 0
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: rembugData!.rembug!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.only(
                            top: 15,
                          ),
                          width: 315,
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(37, 0, 0, 0),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                            color: boxcolor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 20, left: 20),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 35,
                                      child: Expanded(
                                        child: Container(
                                          height: 35,
                                          width: 35,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      rembugData!.rembug![index]
                                                          .users!.imageUser
                                                          .toString()),
                                                  fit: BoxFit.cover),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: Text(
                                          rembugData!
                                              .rembug![index].users!.username
                                              .toString(),
                                          style: TextStyle(
                                              color: surfacecolor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            formatTglIndo(
                                                        date: rembugData!
                                                            .rembug![index]
                                                            .createdDate
                                                            .toString()) ==
                                                    dateenow.toString()
                                                ? "Hari ini"
                                                : daykmrin(
                                                                    date: rembugData!
                                                                        .rembug![
                                                                            index]
                                                                        .createdDate
                                                                        .toString())
                                                                .toString() +
                                                            formatBulanIndo(
                                                                date: rembugData!
                                                                    .rembug![
                                                                        index]
                                                                    .createdDate
                                                                    .toString()) ==
                                                        daynow.toString() +
                                                            datenow2.toString()
                                                    ? "Kemarin"
                                                    : formatTglIndo(
                                                        date: rembugData!
                                                            .rembug![index]
                                                            .createdDate
                                                            .toString()),
                                            style: TextStyle(
                                                fontSize: 8,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          PopupMenuButton(
                                              icon: Icon(
                                                Icons.more_vert_rounded,
                                                color: surfacecolor,
                                              ),
                                              itemBuilder: (context) {
                                                return [
                                                  PopupMenuItem<int>(
                                                    value: 0,
                                                    child: Text("Laporkan"),
                                                  ),
                                                ];
                                              },
                                              onSelected: (value) {
                                                if (value == 0) {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                          title: Text(
                                                              "Masukkan deskripsi laporan"),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                    "Batal")),
                                                            TextButton(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    Navigator.pop(
                                                                        context);
                                                                    isload =
                                                                        true;
                                                                    _postreport(
                                                                        deskripsi:
                                                                            deskripsitxt
                                                                                .text,
                                                                        id_post: rembugData!
                                                                            .rembug![
                                                                                index]
                                                                            .id
                                                                            .toString(),
                                                                        id_user_posts: rembugData!
                                                                            .rembug![index]
                                                                            .users!
                                                                            .id
                                                                            .toString());
                                                                  });
                                                                },
                                                                child: Text(
                                                                  "Report",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red),
                                                                ))
                                                          ],
                                                          content:
                                                              TextFormField(
                                                            controller:
                                                                deskripsitxt,
                                                          ));
                                                    },
                                                  );
                                                }
                                              })
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        rembugData!.rembug![index].deskripsi
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 12, color: surfacecolor),
                                      ),
                                    ),
                                    rembugData!.rembug![index].image != null
                                        ? Container(
                                            margin:
                                                const EdgeInsets.only(top: 20),
                                            height: 135,
                                            width: 300,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        rembugData!
                                                            .rembug![index]
                                                            .image
                                                            .toString()),
                                                    fit: BoxFit.cover),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.grey),
                                          )
                                        : Container(),
                                    Container(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              CommentUrunRembugUI(
                                                                  rembug: rembugData!
                                                                          .rembug![
                                                                      index]),
                                                        ));
                                                  },
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.reply_all,
                                                        size: 22,
                                                        color: accentcolor,
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        rembugData!
                                                            .rembug![index]
                                                            .commentsCount
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: accentcolor),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  formatJamIndo(
                                                      date: rembugData!
                                                          .rembug![index]
                                                          .createdDate
                                                          .toString()),
                                                  style: TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: 80,
                        ),
                        Center(
                          child: Text(
                            "Belum ada postingan...",
                            style: TextStyle(color: hinttext),
                          ),
                        ),
                      ],
                    )),
        ],
      ),
    );
  }
}
