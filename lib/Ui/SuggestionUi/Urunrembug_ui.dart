import 'package:e_villlage/Data/Formated/dayformated.dart';
import 'package:e_villlage/Data/Model/ApiResponse.dart';
import 'package:e_villlage/Data/Model/RembugModel.dart';
import 'package:e_villlage/Data/Services/ReportRembug_services.dart';
import 'package:e_villlage/Data/Services/rembug_services.dart';
import 'package:e_villlage/Data/Services/user_services.dart';
import 'package:e_villlage/Data/settings.dart';
import 'package:e_villlage/Ui/GetStarted/Login_ui.dart';
import 'package:e_villlage/Ui/SuggestionUi/CommentRembugUI.dart';
import 'package:e_villlage/Ui/SuggestionUi/posturunrembug_ui.dart';
import 'package:e_villlage/Ui/Theme.dart';
import 'package:e_villlage/Ui/Widget/ErrorWidget.dart';
import 'package:e_villlage/Ui/Widget/LoadWidget.dart';
import 'package:e_villlage/Ui/Widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class SugestionScreen extends StatefulWidget {
  SugestionScreen({Key? key}) : super(key: key);

  @override
  State<SugestionScreen> createState() => _SugestionScreenState();
}

class _SugestionScreenState extends State<SugestionScreen> {
  bool isload = true;
  bool error = false;
  RembugData? rembugData;
  String img = "";
  String? datenow;
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
        _getallrembug();
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

  void _getallrembug() async {
    DateTime dt = DateTime.parse(DateTime.now().toString());
    String daynoww = DateFormat('dd').format(dt);
    ApiResponse response = await getallrembug();
    String datenoww = formatTglIndo(date: DateTime.now().toString());
    String datenoww2 = formatBulanIndo(date: DateTime.now().toString());
    if (response.data != null) {
      setState(() {
        error = false;
        datenow = datenoww;
        daynow = int.parse(daynoww);
        datenow2 = datenoww2;
        rembugData = response.data as RembugData;

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
    _getallrembug();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return error
        ? iserror(ontap: () {
            setState(() {
              isload = true;
              getallrembug();
            });
          })
        : isload
            ? isloadingwidget()
            : Scaffold(
                backgroundColor: secondarycolor,
                floatingActionButton: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: InkWell(
                    onTap: () async {
                      final reload = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UrunRembugPostUI(),
                          ));
                      if (!mounted) return;
                      setState(() {
                        isload = true;
                        _getallrembug();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: secondarycolorhigh,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(0))),
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 20, right: 20),
                      child: const Text(
                        "Tambah urun rembug",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                appBar: defaultappbar(
                  btncek: ModalRoute.of(context)?.canPop ?? false,
                  title: "Urun rembug",
                  ontap: () {
                    Navigator.pop(context);
                  },
                  backgroundcolor: Theme.of(context).colorScheme.primary,
                ),
                body: Container(
                  decoration: BoxDecoration(
                      color: primarycolor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  child: ListView(
                    children: [
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(20),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                Container(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: rembugData!.rembug!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        margin: const EdgeInsets.only(
                                          top: 15,
                                        ),
                                        width: 315,
                                        decoration: BoxDecoration(
                                          boxShadow: const [
                                            BoxShadow(
                                              color:
                                                  Color.fromARGB(37, 0, 0, 0),
                                              spreadRadius: 2,
                                              blurRadius: 7,
                                              offset: Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                          color: boxcolor,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 20, left: 20),
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
                                                                    rembugData!
                                                                        .rembug![
                                                                            index]
                                                                        .users!
                                                                        .imageUser
                                                                        .toString()),
                                                                fit: BoxFit
                                                                    .cover),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            color: Colors.grey),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 10),
                                                      child: Text(
                                                        rembugData!
                                                            .rembug![index]
                                                            .users!
                                                            .username
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: surfacecolor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
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
                                                                          .rembug![
                                                                              index]
                                                                          .createdDate
                                                                          .toString()) ==
                                                                  datenow
                                                                      .toString()
                                                              ? "Hari ini"
                                                              : daykmrin(date: rembugData!.rembug![index].createdDate.toString())
                                                                              .toString() +
                                                                          formatBulanIndo(
                                                                              date: rembugData!.rembug![index].createdDate
                                                                                  .toString()) ==
                                                                      daynow.toString() +
                                                                          datenow2
                                                                              .toString()
                                                                  ? "Kemarin"
                                                                  : formatTglIndo(
                                                                      date: rembugData!
                                                                          .rembug![
                                                                              index]
                                                                          .createdDate
                                                                          .toString()),
                                                          style: TextStyle(
                                                              fontSize: 8,
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        PopupMenuButton(
                                                            icon: Icon(
                                                              Icons
                                                                  .more_vert_rounded,
                                                              color:
                                                                  surfacecolor,
                                                            ),
                                                            itemBuilder:
                                                                (context) {
                                                              return [
                                                                PopupMenuItem<
                                                                    int>(
                                                                  value: 0,
                                                                  child: Text(
                                                                      "Laporkan"),
                                                                ),
                                                              ];
                                                            },
                                                            onSelected:
                                                                (value) {
                                                              if (value == 0) {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return AlertDialog(
                                                                        title: Text(
                                                                            "Masukkan deskripsi laporan"),
                                                                        actions: [
                                                                          TextButton(
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: Text("Batal")),
                                                                          TextButton(
                                                                              onPressed: () {
                                                                                setState(() {
                                                                                  Navigator.pop(context);
                                                                                  isload = true;
                                                                                  _postreport(deskripsi: deskripsitxt.text, id_post: rembugData!.rembug![index].id.toString(), id_user_posts: rembugData!.rembug![index].users!.id.toString());
                                                                                });
                                                                              },
                                                                              child: Text(
                                                                                "Report",
                                                                                style: TextStyle(color: Colors.red),
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
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Text(
                                                      rembugData!.rembug![index]
                                                          .deskripsi
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: surfacecolor),
                                                    ),
                                                  ),
                                                  rembugData!.rembug![index]
                                                              .image !=
                                                          null
                                                      ? Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 20),
                                                          height: 135,
                                                          width: 300,
                                                          decoration: BoxDecoration(
                                                              image: DecorationImage(
                                                                  image: NetworkImage(rembugData!
                                                                      .rembug![
                                                                          index]
                                                                      .image
                                                                      .toString()),
                                                                  fit: BoxFit
                                                                      .cover),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color:
                                                                  Colors.grey),
                                                        )
                                                      : Container(),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20),
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
                                                                        builder:
                                                                            (context) =>
                                                                                CommentUrunRembugUI(rembug: rembugData!.rembug![index]),
                                                                      ));
                                                                },
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .reply_all,
                                                                      size: 22,
                                                                      color:
                                                                          accentcolor,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Text(
                                                                      rembugData!
                                                                          .rembug![
                                                                              index]
                                                                          .commentsCount
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          color:
                                                                              accentcolor),
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
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                formatJamIndo(
                                                                    date: rembugData!
                                                                        .rembug![
                                                                            index]
                                                                        .createdDate
                                                                        .toString()),
                                                                style: TextStyle(
                                                                    fontSize: 8,
                                                                    color: Colors
                                                                        .grey,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
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
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
  }
}
