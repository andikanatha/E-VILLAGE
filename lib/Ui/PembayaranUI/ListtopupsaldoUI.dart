import 'dart:convert';

import 'package:e_villlage/Data/Formated/dayformated.dart';
import 'package:e_villlage/Data/Formated/formated.dart';
import 'package:e_villlage/Data/Model/TopuplistModel.dart';
import 'package:e_villlage/Data/Services/user_services.dart';
import 'package:e_villlage/Data/settings.dart';
import 'package:e_villlage/Ui/PembayaranUI/TopupSaldoUI.dart';
import 'package:e_villlage/Ui/Theme.dart';
import 'package:e_villlage/Ui/Widget/LoadWidget.dart';
import 'package:e_villlage/Ui/Widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Listtopup extends StatefulWidget {
  const Listtopup({Key? key}) : super(key: key);

  @override
  State<Listtopup> createState() => _ListtopupState();
}

class _ListtopupState extends State<Listtopup> {
  bool isload = true;
  TopuplistModel? topuplistModel;

  void getdata() async {
    String token = await getToken();
    final responsepembayaran = await http
        .get(Uri.parse(baseurl_evillageapi + "/api/user/topup/list"), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    topuplistModel = TopuplistModel.fromJson(
        json.decode(responsepembayaran.body.toString()));

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
      floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TopupSaldoUI(),
                ));
          }),
      appBar: defaultappbar(
          title: "List Topup",
          ontap: () {
            Navigator.pop(context);
          },
          backgroundcolor: Theme.of(context).colorScheme.primary,
          btncek: ModalRoute.of(context)?.canPop ?? false),
      body: isload
          ? isloadingwidget()
          : Container(
              color: primarycolor,
              child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: Column(
                      children: [
                        DataTable(
                            horizontalMargin: 0,
                            columnSpacing: 10,
                            columns: [
                              DataColumn(
                                  label: Container(
                                width: 100,
                                child: Text('Nominal',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: surfacecolor)),
                              )),
                              DataColumn(
                                  label: Container(
                                width: 100,
                                child: Text('Tgl',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: surfacecolor)),
                              )),
                              DataColumn(
                                  label: Container(
                                width: 100,
                                child: Text('Status',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: surfacecolor)),
                              )),
                            ],
                            rows: List.generate(
                                topuplistModel!.dataTransaksi!.length,
                                (index) => DataRow(cells: [
                                      DataCell(Container(
                                          width: 100,
                                          child: Text(
                                              Idrcvt.convertToIdr(
                                                  count: int.parse(
                                                      topuplistModel!
                                                          .dataTransaksi![index]
                                                          .nominal
                                                          .toString()),
                                                  decimalDigit: 2),
                                              style: TextStyle(
                                                  color: surfacecolor)))),
                                      DataCell(Container(
                                          width: 100,
                                          child: Text(
                                              formatTglIndo(
                                                  date: topuplistModel!
                                                      .dataTransaksi![index]
                                                      .topupDate
                                                      .toString()),
                                              style: TextStyle(
                                                  color: surfacecolor)))),
                                      DataCell(Container(
                                          width: 100,
                                          child: Text(
                                              topuplistModel!
                                                  .dataTransaksi![index].status
                                                  .toString(),
                                              style: TextStyle(
                                                  color: surfacecolor)))),
                                    ])))
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
