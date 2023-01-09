import 'dart:convert';

import 'package:e_villlage/Data/Formated/dayformated.dart';
import 'package:e_villlage/Data/Formated/formated.dart';
import 'package:e_villlage/Data/Model/DataTopupModel.dart';
import 'package:e_villlage/Data/Services/user_services.dart';
import 'package:e_villlage/Data/settings.dart';
import 'package:e_villlage/Ui/Admin/KonfirmasitopupDetail.dart';
import 'package:e_villlage/Ui/Theme.dart';
import 'package:e_villlage/Ui/Widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class KonfirmasiTOPUPSaldo extends StatefulWidget {
  KonfirmasiTOPUPSaldo({Key? key}) : super(key: key);

  @override
  State<KonfirmasiTOPUPSaldo> createState() => _KonfirmasiTOPUPSaldoState();
}

class _KonfirmasiTOPUPSaldoState extends State<KonfirmasiTOPUPSaldo> {
  DataTopupModel? notconfirmed;
  DataTopupModel? confirmed;
  bool isload = true;

  void getdata() async {
    int id = await getUserid();
    String token = await getToken();
    final responseconfirmed = await http.get(
        Uri.parse(baseurl_evillageapi + "/api/user/topup/confirmed"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
    final responsenotconfirmed = await http.get(
        Uri.parse(baseurl_evillageapi + "/api/user/topup/notconfirmed"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    notconfirmed =
        DataTopupModel.fromJson(json.decode(responseconfirmed.body.toString()));
    confirmed = DataTopupModel.fromJson(
        json.decode(responsenotconfirmed.body.toString()));

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
      appBar: defaultappbar(
        title: "Konfirmasi Top-up Saldo",
        btncek: ModalRoute.of(context)?.canPop ?? false,
        ontap: () {
          Navigator.pop(context);
        },
        backgroundcolor: Theme.of(context).colorScheme.primary,
      ),
      backgroundColor: primarycolor,
      body: isload
          ? Container(
              color: primarycolor,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : DefaultTabController(
              length: 2, // length of tabs
              initialIndex: 0,
              child: Stack(
                children: [
                  Container(
                      margin: EdgeInsets.only(top: 45),
                      decoration: BoxDecoration(
                        color: primarycolor,
                      ),
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height,
                      ),
                      child:
                          TabBarView(children: [belumdikonfirmasi(), done()])),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(37, 0, 0, 0),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      color: boxcolor,
                      borderRadius: BorderRadius.circular(
                        25.0,
                      ),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: TabBar(
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          25.0,
                        ),
                        color: secondarycolorhigh,
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: secondarycolorhigh,
                      tabs: [
                        Tab(
                          text: 'Belum Dikonfrim',
                        ),
                        Tab(
                          text: 'Telah Dikonfrim',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget belumdikonfirmasi() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: confirmed!.dataTransaksi!.length,
                  itemBuilder: (BuildContext context, int index) {
                    bool isSameDate = true;
                    final String dateString =
                        confirmed!.dataTransaksi![index].topupDate.toString();
                    final DateTime date = DateTime.parse(dateString);
                    final item = confirmed!.dataTransaksi![index];
                    if (index == 0) {
                      isSameDate = false;
                    } else {
                      final String prevDateString = confirmed!
                          .dataTransaksi![index - 1].topupDate
                          .toString();
                      final DateTime prevDate = DateTime.parse(prevDateString);
                      isSameDate = date.isSameDate(prevDate);
                    }
                    if (index == 0 || !(isSameDate)) {
                      return Column(children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Text(
                                formatTglIndo(date: dateString),
                                style: TextStyle(color: surfacecolor),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      KonfirmasiTopupDetailAdmin(
                                    dataTransaksi:
                                        confirmed!.dataTransaksi![index],
                                  ),
                                ));
                          },
                          child: Container(
                            height: 70,
                            margin: const EdgeInsets.only(
                                right: 20, left: 20, top: 10, bottom: 10),
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
                            child: Row(
                              children: [
                                Container(
                                    width: 10,
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          bottomLeft: Radius.circular(15)),
                                    )),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                      margin: const EdgeInsets.only(left: 20),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                confirmed!.dataTransaksi![index]
                                                    .users!.username
                                                    .toString(),
                                                style: TextStyle(
                                                    color: surfacecolor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Meminta konfirmasi top-up " +
                                                    Idrcvt.convertToIdr(
                                                        count: int.parse(
                                                            confirmed!
                                                                .dataTransaksi![
                                                                    index]
                                                                .nominal
                                                                .toString()),
                                                        decimalDigit: 2),
                                                style: TextStyle(
                                                    fontSize: 9,
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          )
                                        ],
                                      )),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                          margin:
                                              const EdgeInsets.only(right: 20),
                                          child: InkWell(
                                            child: Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              color: secondarycolor,
                                            ),
                                          )),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ]);
                    } else {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    KonfirmasiTopupDetailAdmin(
                                  dataTransaksi:
                                      confirmed!.dataTransaksi![index],
                                ),
                              ));
                        },
                        child: Container(
                          height: 70,
                          margin: const EdgeInsets.only(
                              right: 20, left: 20, top: 10, bottom: 10),
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
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        bottomLeft: Radius.circular(15)),
                                  )),
                              Expanded(
                                flex: 2,
                                child: Container(
                                    margin: const EdgeInsets.only(left: 20),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              confirmed!.dataTransaksi![index]
                                                  .users!.username
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
                                              "Meminta konfirmasi top-up " +
                                                  Idrcvt.convertToIdr(
                                                      count: int.parse(
                                                          confirmed!
                                                              .dataTransaksi![
                                                                  index]
                                                              .nominal
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
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                        margin:
                                            const EdgeInsets.only(right: 20),
                                        child: InkWell(
                                          child: Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: secondarycolor,
                                          ),
                                        )),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  }),
            ],
          ),
        ],
      ),
    );
  }

  Widget done() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: notconfirmed!.dataTransaksi!.length,
                  itemBuilder: (BuildContext context, int index) {
                    bool isSameDate = true;
                    final String dateString = notconfirmed!
                        .dataTransaksi![index].topupDate
                        .toString();
                    final DateTime date = DateTime.parse(dateString);
                    final item = notconfirmed!.dataTransaksi![index];
                    if (index == 0) {
                      isSameDate = false;
                    } else {
                      final String prevDateString = notconfirmed!
                          .dataTransaksi![index - 1].topupDate
                          .toString();
                      final DateTime prevDate = DateTime.parse(prevDateString);
                      isSameDate = date.isSameDate(prevDate);
                    }
                    if (index == 0 || !(isSameDate)) {
                      return Column(children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Text(
                                formatTglIndo(date: dateString),
                                style: TextStyle(color: surfacecolor),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: boxcolor,
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(37, 0, 0, 0),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        KonfirmasiTopupDetailAdmin(
                                      dataTransaksi:
                                          notconfirmed!.dataTransaksi![index],
                                    ),
                                  ));
                            },
                            title: Text(
                              notconfirmed!
                                  .dataTransaksi![index].users!.username
                                  .toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: surfacecolor),
                            ),
                            subtitle: Text(
                                "Top-up " +
                                    Idrcvt.convertToIdr(
                                        count: int.parse(notconfirmed!
                                            .dataTransaksi![index].nominal
                                            .toString()),
                                        decimalDigit: 2) +
                                    " Telah ikonfirmasi",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                            trailing: Icon(Icons.arrow_forward_ios_rounded),
                            leading: Container(
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 218, 236, 242),
                                    borderRadius: BorderRadius.circular(7)),
                                height: 60,
                                width: 60,
                                child: Center(
                                  child: Icon(Icons.check),
                                )),
                          ),
                        )
                      ]);
                    } else {
                      return Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: boxcolor,
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(37, 0, 0, 0),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      KonfirmasiTopupDetailAdmin(
                                    dataTransaksi:
                                        notconfirmed!.dataTransaksi![index],
                                  ),
                                ));
                          },
                          title: Text(
                            notconfirmed!.dataTransaksi![index].users!.username
                                .toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: surfacecolor),
                          ),
                          subtitle: Text(
                            "Top-up " +
                                Idrcvt.convertToIdr(
                                    count: int.parse(notconfirmed!
                                        .dataTransaksi![index].nominal
                                        .toString()),
                                    decimalDigit: 2) +
                                " Telah ikonfirmasi",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios_rounded),
                          leading: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 218, 236, 242),
                                  borderRadius: BorderRadius.circular(7)),
                              height: 60,
                              width: 60,
                              child: Center(
                                child: Icon(Icons.check),
                              )),
                        ),
                      );
                    }
                  }),
            ],
          ),
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
