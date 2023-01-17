import 'dart:convert';

import 'package:e_villlage/Data/Formated/dayformated.dart';
import 'package:e_villlage/Data/Model/ApiResponse.dart';
import 'package:e_villlage/Data/Model/RembugreportModel.dart';
import 'package:e_villlage/Data/Services/rembug_services.dart';
import 'package:e_villlage/Data/Services/user_services.dart';
import 'package:e_villlage/Data/settings.dart';
import 'package:e_villlage/Ui/GetStarted/Login_ui.dart';
import 'package:e_villlage/Ui/Theme.dart';
import 'package:e_villlage/Ui/Widget/LoadWidget.dart';
import 'package:e_villlage/Ui/Widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class LaporUrunRembug extends StatefulWidget {
  const LaporUrunRembug({Key? key}) : super(key: key);

  @override
  State<LaporUrunRembug> createState() => _LaporUrunRembugState();
}

class _LaporUrunRembugState extends State<LaporUrunRembug> {
  bool error = false;
  String? datenow;
  String? datenow2;
  int daynow = 0;
  RembugReport? rembugReport;
  bool isload = true;

  void deleterembugg({required String? id}) async {
    ApiResponse response = await deleterembugadmin(id: id.toString());

    if (response.data != null) {
      setState(() {
        getdata();
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Berhasil menghapus postingan')));
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

  void getdata() async {
    String token = await getToken();
    DateTime dt = DateTime.parse(DateTime.now().toString());
    String daynoww = DateFormat('dd').format(dt);
    String datenoww = formatTglIndo(date: DateTime.now().toString());
    String datenoww2 = formatBulanIndo(date: DateTime.now().toString());
    final res = await http.get(
        Uri.parse(baseurl_evillageapi + "/api/user/rembug/report"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    rembugReport = RembugReport.fromJson(json.decode(res.body.toString()));

    setState(() {
      error = false;
      datenow = datenoww;
      daynow = int.parse(daynoww);
      datenow2 = datenoww2;

      isload = false;
    });
  }

  @override
  void initState() {
    getdata();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isload
        ? isloadingwidget()
        : Scaffold(
            backgroundColor: primarycolor,
            appBar: defaultappbar(
                btncek: ModalRoute.of(context)?.canPop ?? false,
                ontap: () {
                  Navigator.pop(context);
                },
                backgroundcolor: secondarycolor,
                title: "Laporan Urun Rembug"),
            body: ListView(
              children: [
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: rembugReport!.laporan!.length > 0
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: rembugReport!.laporan!.length,
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
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                  color: boxcolor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 20, left: 20, right: 20),
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
                                                            rembugReport!
                                                                .laporan![index]
                                                                .usersposts!
                                                                .imageUser
                                                                .toString()),
                                                        fit: BoxFit.cover),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    color: Colors.grey),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              margin: EdgeInsets.only(left: 10),
                                              child: Text(
                                                rembugReport!.laporan![index]
                                                    .usersposts!.username
                                                    .toString(),
                                                style: TextStyle(
                                                    color: surfacecolor,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                              date: rembugReport!
                                                                  .laporan![
                                                                      index]
                                                                  .posts!
                                                                  .createdDate
                                                                  .toString()) ==
                                                          datenow.toString()
                                                      ? "Hari ini"
                                                      : daykmrin(date: rembugReport!.laporan![index].posts!.createdDate.toString())
                                                                      .toString() +
                                                                  formatBulanIndo(
                                                                      date: rembugReport!
                                                                          .laporan![
                                                                              index]
                                                                          .posts!
                                                                          .createdDate
                                                                          .toString()) ==
                                                              daynow.toString() +
                                                                  datenow2
                                                                      .toString()
                                                          ? "Kemarin"
                                                          : formatTglIndo(
                                                              date: rembugReport!
                                                                  .laporan![
                                                                      index]
                                                                  .posts!
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
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Text(
                                              rembugReport!.laporan![index]
                                                  .posts!.deskripsi
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: surfacecolor),
                                            ),
                                          ),
                                          rembugReport!.laporan![index].posts!
                                                      .image !=
                                                  null
                                              ? Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 20),
                                                  height: 135,
                                                  width: 300,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              rembugReport!
                                                                  .laporan![
                                                                      index]
                                                                  .posts!
                                                                  .image
                                                                  .toString()),
                                                          fit: BoxFit.cover),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: Colors.grey),
                                                )
                                              : Container(),
                                          Divider(),
                                          Row(
                                            children: [
                                              Text("Deskripsi laporan",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: surfacecolor,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                  rembugReport!.laporan![index]
                                                      .description
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: surfacecolor)),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                width: 120,
                                                child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary:
                                                                Colors.red),
                                                    onPressed: () {
                                                      setState(() {
                                                        isload = true;
                                                        deleterembugg(
                                                            id: rembugReport!
                                                                .laporan![index]
                                                                .posts!
                                                                .id
                                                                .toString());
                                                      });
                                                    },
                                                    child: Text(
                                                      "Hapus",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    )),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 150,
                                ),
                                SvgPicture.asset("Asset/Svg/nodata.svg"),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Belum ada pelaporan urun rembug...",
                                  style: TextStyle(color: hinttext),
                                ),
                              ],
                            ),
                          ))
              ],
            ),
          );
  }
}
