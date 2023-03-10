import 'dart:convert';

import 'package:e_villlage/Data/Formated/dayformated.dart';
import 'package:e_villlage/Data/Formated/formated.dart';
import 'package:e_villlage/Data/Model/ApiResponse.dart';
import 'package:e_villlage/Data/Model/LaporanAdminModel.dart';
import 'package:e_villlage/Data/Services/AdminPengeluaran_services.dart';
import 'package:e_villlage/Data/Services/user_services.dart';
import 'package:e_villlage/Data/settings.dart';
import 'package:e_villlage/Ui/Admin/HomescreenAdminUI.dart';
import 'package:e_villlage/Ui/GetStarted/Login_ui.dart';
import 'package:e_villlage/Ui/HomeScreenUi/homescreen_ui.dart';
import 'package:e_villlage/Ui/Theme.dart';
import 'package:e_villlage/Ui/Widget/LoadWidget.dart';
import 'package:e_villlage/Ui/Widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class TambahPengeluaran extends StatefulWidget {
  TambahPengeluaran({Key? key}) : super(key: key);

  @override
  State<TambahPengeluaran> createState() => _LaporanPDAMState();
}

class _LaporanPDAMState extends State<TambahPengeluaran> {
  bool isload = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _post() async {
    ApiResponse response = await postlaporanadmin(
        description: deskripsi.text,
        keperluan: keperluan.text,
        nominal: nominal.text);

    if (response.data != null) {
      setState(() {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomeScreenAdmin()),
            (route) => false);
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

  TextEditingController nominal = TextEditingController();
  TextEditingController keperluan = TextEditingController();
  TextEditingController deskripsi = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primarycolor,
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
                      TextFormField(
                          style: TextStyle(color: surfacecolor),
                          controller: nominal,
                          keyboardType: TextInputType.number,
                          validator: (val) => val!.isEmpty
                              ? 'Mohon Masukkan Nominal Saldo!'
                              : null,
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
                                color: hinttext,
                              ),
                              hintText: 'masukkan nominal saldo')),
                      Row(
                        children: [
                          Text(
                            "Masukkan hanya angka, jangan memasukan simbol lain",
                            style: TextStyle(fontSize: 10, color: surfacecolor),
                          ),
                          Text("!",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.red)),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                          style: TextStyle(color: surfacecolor),
                          controller: keperluan,
                          validator: (val) => val!.isEmpty
                              ? 'Mohon Masukkan Keperluan Saldo!'
                              : null,
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
                                color: hinttext,
                              ),
                              hintText: 'masukkan keperluan saldo')),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                          style: TextStyle(color: surfacecolor),
                          controller: deskripsi,
                          maxLines: 4,
                          validator: (val) =>
                              val!.isEmpty ? 'Mohon Masukkan Deskripsi!' : null,
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
                                color: hinttext,
                              ),
                              hintText: 'deskripsi')),
                      SizedBox(
                        height: 180,
                      ),
                      longbtn(
                          ontap: () {
                            setState(() {
                              isload = true;
                              _post();
                            });
                          },
                          text: "Simpan")
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
