import 'package:e_villlage/Data/Formated/dayformated.dart';
import 'package:e_villlage/Data/Formated/formated.dart';
import 'package:e_villlage/Data/Model/ApiResponse.dart';
import 'package:e_villlage/Data/Model/UserModel.dart';
import 'package:e_villlage/Data/Services/user_services.dart';
import 'package:e_villlage/Data/settings.dart';
import 'package:e_villlage/Ui/GetStarted/Login_ui.dart';
import 'package:e_villlage/Ui/LaporKades/postLaporKadesUI.dart';
import 'package:e_villlage/Ui/NotificationUi/notification_ui.dart';
import 'package:e_villlage/Ui/PembayaranUI/PembayaranUI.dart';
import 'package:e_villlage/Ui/RiwayatUi/riwayat_ui.dart';
import 'package:e_villlage/Ui/SuggestionUi/Urunrembug_ui.dart';
import 'package:e_villlage/Ui/Theme.dart';
import 'package:e_villlage/Ui/Widget/ErrorWidget.dart';
import 'package:flutter/material.dart';
import 'package:inner_shadow_widget/inner_shadow_widget.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int hoursnow = 0;
  String greeting = "";
  String datenow = "0000-00-00";
  String? token;

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

  @override
  void initState() {
    getCurrentDate();
    getuser();
    super.initState();
  }

  String img =
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQqwiNontOp9Xx9E_VBtnTldT7IB65ik1oN2R6VZi6KzLqjLGSU9G21I-G3C5W8xBMrl18&usqp=CAU";
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
                            color: Theme.of(context).colorScheme.primary,
                          )),
                          Expanded(child: Container())
                        ],
                      ),
                      ListView(
                        children: [
                          Container(
                            color: Theme.of(context).colorScheme.primary,
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
                                                    ? user!.username.toString()
                                                    : "Pengguna",
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
                                                        Icons.notifications))))
                                      ],
                                    ))
                                  ],
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
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
                                                      child: Text(
                                                        Idrcvt.convertToIdr(
                                                            count: int.parse(
                                                                user!.saldo),
                                                            decimalDigit: 2),
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                        ),
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
                                                              onTap: () {},
                                                              child: Container(
                                                                width: 40,
                                                                height: 40,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .primary,
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
                                                            onTap: () {},
                                                            child: Container(
                                                              width: 40,
                                                              height: 40,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary,
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
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PembayaranUI(
                                                          action: "sampah"),
                                                ));
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
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
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
                                                          Icons.cached,
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
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PembayaranUI(
                                                          action: "PDAM"),
                                                ));
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
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
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
                                                          Icons.water,
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
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      SugestionScreen(),
                                                ));
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
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
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
                                                          Icons.people,
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
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PostLaporKadesUI(),
                                                ));
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
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
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
                                                          Icons.report,
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
                                color: Colors.white),
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
                  children: const [
                    Text(
                      "Aktivitas",
                      style: TextStyle(fontWeight: FontWeight.bold),
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
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  height: 60,
                  margin: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                      color: primarycolor,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(18, 0, 0, 0),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.circular(15)),
                  width: 231,
                  child: Row(
                    children: [
                      Container(
                          width: 10,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                bottomLeft: Radius.circular(15)),
                          )),
                      Container(
                          margin: const EdgeInsets.only(left: 20),
                          width: 160,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: const [
                                  Text(
                                    "Pembayaran PDAM",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                children: const [
                                  Text(
                                    "Bulan : Agustus",
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
                              color: secondarycolor,
                            ),
                          ))
                    ],
                  ),
                );
              },
            ),
          )
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
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Container(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.only(
                    top: 15,
                  ),
                  padding: EdgeInsets.all(20),
                  width: 315,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(37, 0, 0, 0),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
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
                                              "https://i.pinimg.com/550x/9c/bc/af/9cbcafccdbd1995937772a047437ceb9.jpg"),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.grey),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: Container(
                                margin: EdgeInsets.only(left: 20),
                                child: const Text(
                                  "Keyyy",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Hari ini",
                                    style: TextStyle(
                                        fontSize: 8,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 200,
                            child: const Text(
                              "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                              style: TextStyle(fontSize: 9),
                            ),
                          ),
                        ],
                      ),
                      img != ""
                          ? Container(
                              margin: const EdgeInsets.only(top: 20),
                              height: 135,
                              width: 300,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(img),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey),
                            )
                          : Container(),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 5),
                                    child: InkWell(
                                      onTap: () {},
                                      child: Icon(
                                        Icons.favorite_outline,
                                        size: 18,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 5),
                                    child: InkWell(
                                      onTap: () {},
                                      child: Icon(
                                        Icons.share,
                                        size: 18,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {},
                                    child: Icon(
                                      Icons.reply_all,
                                      size: 18,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text(
                                    "10:00",
                                    style: TextStyle(
                                        fontSize: 8,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
