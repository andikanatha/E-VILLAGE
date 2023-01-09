import 'dart:convert';

import 'package:e_villlage/Data/Formated/dayformated.dart';
import 'package:e_villlage/Data/Formated/formated.dart';
import 'package:e_villlage/Data/Model/LaporanAdminModel.dart';
import 'package:e_villlage/Data/Services/user_services.dart';
import 'package:e_villlage/Data/settings.dart';
import 'package:e_villlage/Ui/Admin/Datadetailpengeluaran.dart';
import 'package:e_villlage/Ui/Admin/Tambahpengeluaran.dart';
import 'package:e_villlage/Ui/Theme.dart';
import 'package:e_villlage/Ui/Widget/LoadWidget.dart';
import 'package:e_villlage/Ui/Widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class LaporanPengeluaran extends StatefulWidget {
  LaporanPengeluaran({Key? key}) : super(key: key);

  @override
  State<LaporanPengeluaran> createState() => _LaporanPDAMState();
}

class _LaporanPDAMState extends State<LaporanPengeluaran> {
  LaporanAdminModel? laporanAdminModel;
  bool isload = true;

  void getdata() async {
    String token = await getToken();
    final responsepembayaran = await http
        .get(Uri.parse(baseurl_evillageapi + "/api/admin/laporan"), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    laporanAdminModel = LaporanAdminModel.fromJson(
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
      backgroundColor: primarycolor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TambahPengeluaran(),
              ));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: defaultappbar(
          title: "Pengeluaran",
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
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      DataTable(
                          horizontalMargin: 0,
                          columnSpacing: 10,
                          columns: [
                            DataColumn(
                                label: Container(
                              width: 100,
                              child: Text('Tanggal',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: surfacecolor)),
                            )),
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
                              child: Text('Keperluan',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: surfacecolor)),
                            )),
                          ],
                          rows: List.generate(
                              laporanAdminModel!.laporan!.length,
                              (index) => DataRow(
                                      onLongPress: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailPengeluaran(
                                                        laporan:
                                                            laporanAdminModel!
                                                                    .laporan![
                                                                index])));
                                      },
                                      cells: [
                                        DataCell(Container(
                                            width: 100,
                                            child: Text(
                                                formatTglIndo(
                                                    date: laporanAdminModel!
                                                        .laporan![index].date
                                                        .toString()),
                                                style: TextStyle(
                                                    color: surfacecolor)))),
                                        DataCell(Container(
                                            width: 100,
                                            child: Text(
                                                Idrcvt.convertToIdr(
                                                    count: int.parse(
                                                        laporanAdminModel!
                                                            .laporan![index]
                                                            .nominal
                                                            .toString()),
                                                    decimalDigit: 2),
                                                style: TextStyle(
                                                    color: surfacecolor)))),
                                        DataCell(Container(
                                            width: 100,
                                            child: Text(
                                                laporanAdminModel!
                                                    .laporan![index].keperluan
                                                    .toString(),
                                                style: TextStyle(
                                                    color: surfacecolor)))),
                                      ])))
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
