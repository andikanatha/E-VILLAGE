import 'package:e_villlage/Data/Formated/dayformated.dart';
import 'package:e_villlage/Data/Model/LaporModel.dart';
import 'package:e_villlage/Data/Model/PembayaranModelGet.dart';
import 'package:e_villlage/Data/Services/user_services.dart';
import 'package:e_villlage/Data/settings.dart';
import 'package:e_villlage/Ui/LaporKades/lapordetail.dart';
import 'package:e_villlage/Ui/PembayaranUI/PembayaranDetail.dart';
import 'package:e_villlage/Ui/Theme.dart';
import 'package:e_villlage/Ui/Widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({Key? key}) : super(key: key);

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  PembayaranModelGet? pembayaranModelGet;
  ModelLapor? modelLapor;
  bool isload = true;

  void getdata() async {
    int id = await getUserid();
    final responsepembayaran = await http.get(Uri.parse(
        baseurl_evillageapi + "/api/user/transaksi/" + id.toString()));
    final responsereport = await http.get(
        Uri.parse(baseurl_evillageapi + "/api/user/report/" + id.toString()));

    pembayaranModelGet = PembayaranModelGet.fromJson(
        json.decode(responsepembayaran.body.toString()));
    modelLapor =
        ModelLapor.fromJson(json.decode(responsereport.body.toString()));

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
    return isload
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: Theme.of(context).colorScheme.primary,
            appBar: defaultappbar(
              title: "Riwayat",
              btncek: ModalRoute.of(context)?.canPop ?? false,
              ontap: () {
                Navigator.pop(context);
              },
              backgroundcolor: Theme.of(context).colorScheme.primary,
            ),
            body: DefaultTabController(
              length: 2, // length of tabs
              initialIndex: 0,
              child: Stack(
                children: [
                  Container(
                      margin: EdgeInsets.only(top: 22),
                      decoration: BoxDecoration(
                          color: primarycolor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height,
                      ),
                      child: TabBarView(
                          children: [pembayaranui(), pelaporanui()])),
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        25.0,
                      ),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 70),
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
                          text: 'Pembayaran',
                        ),
                        Tab(
                          text: 'Pelaporan',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }

  Widget pembayaranui() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                height: 50,
                margin: EdgeInsets.only(top: 15, left: 20, right: 20),
                child: TextFormField(
                    validator: (val) => val!.isEmpty ? '' : null,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        filled: true,
                        fillColor: inputtxtbg,
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 12,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: surfacecolor,
                        ),
                        hintText: 'Anda ingin mencari apa?')),
              ),
              SizedBox(
                height: 20,
              ),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: pembayaranModelGet!.dataTransaksi!.length,
                  itemBuilder: (BuildContext context, int index) {
                    bool isSameDate = true;
                    final String dateString = pembayaranModelGet!
                        .dataTransaksi![index].createdAt
                        .toString();
                    final DateTime date = DateTime.parse(dateString);
                    final item = pembayaranModelGet!.dataTransaksi![index];
                    if (index == 0) {
                      isSameDate = false;
                    } else {
                      final String prevDateString = pembayaranModelGet!
                          .dataTransaksi![index - 1].createdAt
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
                              Text(formatTglIndo(date: dateString)),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
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
                                    builder: (context) => Detailpembayaran(
                                        id: int.parse(pembayaranModelGet!
                                            .dataTransaksi![index].id
                                            .toString())),
                                  ));
                            },
                            title: Text(
                              pembayaranModelGet!.dataTransaksi![index].trxName
                                  .toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(formatTglIndo(
                                date: pembayaranModelGet!
                                    .dataTransaksi![index].createdAt
                                    .toString())),
                            trailing: Icon(Icons.arrow_forward_ios_rounded),
                            leading: Container(
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 218, 236, 242),
                                    borderRadius: BorderRadius.circular(7)),
                                height: 60,
                                width: 60,
                                child: Center(
                                  child: Icon(pembayaranModelGet!
                                              .dataTransaksi![index].status
                                              .toString() ==
                                          "Berhasil"
                                      ? Icons.check
                                      : Icons.report),
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
                          color: Colors.white,
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
                                  builder: (context) => Detailpembayaran(
                                      id: int.parse(pembayaranModelGet!
                                          .dataTransaksi![index].id
                                          .toString())),
                                ));
                          },
                          title: Text(
                            pembayaranModelGet!.dataTransaksi![index].trxName
                                .toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(formatTglIndo(
                              date: pembayaranModelGet!
                                  .dataTransaksi![index].createdAt
                                  .toString())),
                          trailing: Icon(Icons.arrow_forward_ios_rounded),
                          leading: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 218, 236, 242),
                                  borderRadius: BorderRadius.circular(7)),
                              height: 60,
                              width: 60,
                              child: Center(
                                child: Icon(pembayaranModelGet!
                                            .dataTransaksi![index].status
                                            .toString() ==
                                        "Berhasil"
                                    ? Icons.check
                                    : Icons.report),
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

  Widget pelaporanui() {
    return ListView(
      shrinkWrap: true,
      children: [
        SizedBox(
          height: 40,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: modelLapor!.dataTransaksi!.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(37, 0, 0, 0),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Detaillaporan(
                            dataTransaksi: modelLapor!.dataTransaksi![index]),
                      ));
                },
                title: Text(
                  "Laporan " + index.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(formatTglIndo(
                    date: modelLapor!.dataTransaksi![index].createdDate
                        .toString())),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
                leading: Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 218, 236, 242),
                        borderRadius: BorderRadius.circular(7)),
                    height: 60,
                    width: 60,
                    child: Center(
                      child: Icon(Icons.report),
                    )),
              ),
            );
          },
        ),
      ],
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
