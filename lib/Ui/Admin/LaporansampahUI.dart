import 'dart:convert';

import 'package:e_villlage/Data/Formated/dayformated.dart';
import 'package:e_villlage/Data/Formated/formated.dart';
import 'package:e_villlage/Data/Model/AdminPembayaranModel.dart';
import 'package:e_villlage/Data/Services/user_services.dart';
import 'package:e_villlage/Data/settings.dart';
import 'package:e_villlage/Ui/PembayaranUI/PembayaranDetail.dart';
import 'package:e_villlage/Ui/Theme.dart';
import 'package:e_villlage/Ui/Widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class LaporanSampah extends StatefulWidget {
  LaporanSampah({Key? key}) : super(key: key);

  @override
  State<LaporanSampah> createState() => _LaporanSampahState();
}

class _LaporanSampahState extends State<LaporanSampah> {
  Getpembayaran? getpembayaran;
  String querypembayaran = "";
  TextEditingController pembayaranquery = TextEditingController();
  bool isload = true;

  void getdata() async {
    String token = await getToken();

    if (querypembayaran != "") {
      final responsepembayaransrc = await http.get(
          Uri.parse(baseurl_evillageapi +
              "/api/user/pemasukan/sampah/" +
              querypembayaran.toString()),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          });

      setState(() {
        getpembayaran = Getpembayaran.fromJson(
            json.decode(responsepembayaransrc.body.toString()));
      });
    } else {
      final responsepembayaran = await http.get(
          Uri.parse(baseurl_evillageapi + "/api/user/transaksi/sampah"),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          });

      setState(() {
        getpembayaran = Getpembayaran.fromJson(
            json.decode(responsepembayaran.body.toString()));
      });
    }

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
          title: "Laporan Uang Sampah",
          ontap: () {
            Navigator.pop(context);
          },
          backgroundcolor: Theme.of(context).colorScheme.primary,
          btncek: ModalRoute.of(context)?.canPop ?? false),
      body: isload
          ? Container(
              color: primarycolor,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : ListView(
              children: [
                Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: getpembayaran!.dataTransaksi!.length > 0
                        ? Column(
                            children: [
                              Container(
                                height: 50,
                                margin: EdgeInsets.only(
                                    top: 15, left: 20, right: 20),
                                child: TextFormField(
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime.now());

                                      if (pickedDate != null) {
                                        setState(() {
                                          String formattedDate =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(pickedDate);
                                          querypembayaran = formattedDate;
                                          pembayaranquery.text = formatTglIndo(
                                              date: pickedDate.toString());

                                          getdata();
                                        });
                                      } else {}
                                    },
                                    style: TextStyle(color: surfacecolor),
                                    controller: pembayaranquery,
                                    validator: (val) =>
                                        val!.isEmpty ? '' : null,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: BorderSide(
                                            width: 0,
                                            style: BorderStyle.none,
                                          ),
                                        ),
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                pembayaranquery.text = "";
                                                querypembayaran = "";
                                                getdata();
                                              });
                                            },
                                            icon: Icon(
                                              Icons.cancel,
                                              color: surfacecolor,
                                            )),
                                        filled: true,
                                        fillColor: inputtxtbg,
                                        hintStyle: GoogleFonts.poppins(
                                            fontSize: 12, color: surfacecolor),
                                        prefixIcon: Icon(
                                          Icons.search,
                                          color: surfacecolor,
                                        ),
                                        hintText:
                                            'Pilih tanggal yang ingin anda cari...')),
                              ),
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
                                      child: Text('Username',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: surfacecolor)),
                                    )),
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
                                  ],
                                  rows: List.generate(
                                      getpembayaran!.dataTransaksi!.length,
                                      (index) => DataRow(
                                              onLongPress: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          Detailpembayaran(
                                                              id: int.parse(
                                                                  getpembayaran!
                                                                      .dataTransaksi![
                                                                          index]
                                                                      .id
                                                                      .toString())),
                                                    ));
                                              },
                                              cells: [
                                                DataCell(Container(
                                                    width: 100,
                                                    child: Text(
                                                      getpembayaran!
                                                          .dataTransaksi![index]
                                                          .users!
                                                          .username
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: surfacecolor),
                                                    ))),
                                                DataCell(Container(
                                                    width: 100,
                                                    child: Text(
                                                        formatTglIndo(
                                                            date: getpembayaran!
                                                                .dataTransaksi![
                                                                    index]
                                                                .trxDate
                                                                .toString()),
                                                        style: TextStyle(
                                                            color:
                                                                surfacecolor)))),
                                                DataCell(Container(
                                                    width: 100,
                                                    child: Text(
                                                        Idrcvt.convertToIdr(
                                                            count: int.parse(
                                                                getpembayaran!
                                                                    .dataTransaksi![
                                                                        index]
                                                                    .totalTrx
                                                                    .toString()),
                                                            decimalDigit: 2),
                                                        style: TextStyle(
                                                            color:
                                                                surfacecolor)))),
                                              ])))
                            ],
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
                                  "Laporan pembayaran sampah masih kosong...",
                                  style: TextStyle(color: hinttext),
                                ),
                              ],
                            ),
                          )),
              ],
            ),
    );
  }
}
