import 'dart:convert';

import 'package:e_villlage/Data/Formated/dayformated.dart';
import 'package:e_villlage/Data/Model/LaporanModel.dart';
import 'package:e_villlage/Data/Services/user_services.dart';
import 'package:e_villlage/Data/settings.dart';
import 'package:e_villlage/Ui/Admin/DetailLaporanAdmin,.dart';
import 'package:e_villlage/Ui/LaporKades/lapordetail.dart';
import 'package:e_villlage/Ui/PembayaranUI/PembayaranDetail.dart';
import 'package:e_villlage/Ui/Theme.dart';
import 'package:e_villlage/Ui/Widget/LoadWidget.dart';
import 'package:e_villlage/Ui/Widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class LaporKadesAdminUI extends StatefulWidget {
  const LaporKadesAdminUI({Key? key}) : super(key: key);

  @override
  State<LaporKadesAdminUI> createState() => _LaporKadesAdminUIState();
}

class _LaporKadesAdminUIState extends State<LaporKadesAdminUI> {
  LaporanWarga? laporanWarga;
  bool isload = true;

  void getdata() async {
    String token = await getToken();
    final res = await http
        .get(Uri.parse(baseurl_evillageapi + "/api/user/report"), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    laporanWarga = LaporanWarga.fromJson(json.decode(res.body.toString()));

    setState(() {
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
    return Scaffold(
      backgroundColor: primarycolor,
      appBar: defaultappbar(
          title: "Lapor Kades",
          ontap: () {
            Navigator.pop(context);
          },
          backgroundcolor: Theme.of(context).colorScheme.primary,
          btncek: ModalRoute.of(context)?.canPop ?? false),
      body: isload
          ? isloadingwidget()
          : ListView(
              children: [
                Container(
                    margin: EdgeInsets.only(top: 20),
                    child: laporanWarga!.laporan!.length > 0
                        ? ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: laporanWarga!.laporan!.length,
                            itemBuilder: (BuildContext context, int index) {
                              bool isSameDate = true;
                              final String dateString = laporanWarga!
                                  .laporan![index].createdDate
                                  .toString();
                              final DateTime date = DateTime.parse(dateString);
                              final item = laporanWarga!.laporan![index];
                              if (index == 0) {
                                isSameDate = false;
                              } else {
                                final String prevDateString = laporanWarga!
                                    .laporan![index - 1].createdDate
                                    .toString();
                                final DateTime prevDate =
                                    DateTime.parse(prevDateString);
                                isSameDate = date.isSameDate(prevDate);
                              }
                              if (index == 0 || !(isSameDate)) {
                                return Column(children: [
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Row(
                                      children: [
                                        Text(formatTglIndo(date: dateString),
                                            style:
                                                TextStyle(color: surfacecolor)),
                                      ],
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: boxcolor,
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromARGB(37, 0, 0, 0),
                                            spreadRadius: 2,
                                            blurRadius: 7,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                laporanWarga!.laporan![index]
                                                    .users!.username
                                                    .toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: surfacecolor),
                                              )),
                                              Expanded(
                                                  child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                      formatJamIndo(
                                                          date: laporanWarga!
                                                              .laporan![index]
                                                              .createdDate
                                                              .toString()),
                                                      style: TextStyle(
                                                          color: surfacecolor)),
                                                ],
                                              )),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                              laporanWarga!
                                                  .laporan![index].deskripsi
                                                  .toString(),
                                              style: TextStyle(
                                                  color: surfacecolor)),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetaillaporanAdmin(
                                                        laporan: laporanWarga!
                                                            .laporan![index],
                                                      ),
                                                    ));
                                              },
                                              child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 20),
                                                  child: Text(
                                                    "Detail",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )))
                                        ],
                                      ))
                                ]);
                              } else {
                                return Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: boxcolor,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color.fromARGB(37, 0, 0, 0),
                                          spreadRadius: 2,
                                          blurRadius: 7,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                                child: Text(
                                              laporanWarga!.laporan![index]
                                                  .users!.username
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: surfacecolor),
                                            )),
                                            Expanded(
                                                child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                    formatJamIndo(
                                                        date: laporanWarga!
                                                            .laporan![index]
                                                            .createdDate
                                                            .toString()),
                                                    style: TextStyle(
                                                        color: surfacecolor)),
                                              ],
                                            )),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            laporanWarga!
                                                .laporan![index].deskripsi
                                                .toString(),
                                            style:
                                                TextStyle(color: surfacecolor)),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetaillaporanAdmin(
                                                      laporan: laporanWarga!
                                                          .laporan![index],
                                                    ),
                                                  ));
                                            },
                                            child: Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 20),
                                                child: Text(
                                                  "Detail",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )))
                                      ],
                                    ));
                              }
                            })
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
                                  "Belum ada laporan dari warga...",
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

String dateFormatter = 'MMMM dd, y';

extension DateHelper on DateTime {
  String formatDate() {
    final formatter = DateFormat(dateFormatter);
    return formatter.format(this);
  }

  bool isSameDate(DateTime other) {
    return this.year == other.year &&
        this.month == other.month &&
        this.day == other.day;
  }

  int getDifferenceInDaysWithNow() {
    final now = DateTime.now();
    return now.difference(this).inDays;
  }
}
