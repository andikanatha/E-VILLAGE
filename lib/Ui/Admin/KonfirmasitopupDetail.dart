import 'dart:convert';

import 'package:e_villlage/Data/Formated/dayformated.dart';
import 'package:e_villlage/Data/Model/ApiResponse.dart';
import 'package:e_villlage/Data/Model/DataTopupModel.dart';
import 'package:e_villlage/Data/Services/KonfirmasiTOPUP_services.dart';
import 'package:e_villlage/Data/Services/user_services.dart';
import 'package:e_villlage/Data/settings.dart';
import 'package:e_villlage/Ui/GetStarted/Login_ui.dart';
import 'package:e_villlage/Ui/Theme.dart';
import 'package:e_villlage/Ui/Widget/widget.dart';
import 'package:flutter/material.dart';

class KonfirmasiTopupDetailAdmin extends StatefulWidget {
  KonfirmasiTopupDetailAdmin({Key? key, required this.dataTransaksi})
      : super(key: key);
  DataTransaksi? dataTransaksi;
  @override
  State<KonfirmasiTopupDetailAdmin> createState() => _KonfirmasiTopupState();
}

class _KonfirmasiTopupState extends State<KonfirmasiTopupDetailAdmin> {
  TextEditingController nama = TextEditingController();
  TextEditingController tanggal = TextEditingController();
  TextEditingController waktu = TextEditingController();
  TextEditingController nominal = TextEditingController();

  bool isload = false;

  void post() async {
    ApiResponse response =
        await topupconfirm(id: widget.dataTransaksi!.id.toString());

    if (response.data != null) {
      setState(() {
        isload = false;
        Navigator.pop(context);
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Berhasil Konfirmasi')));
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

  @override
  void initState() {
    nama.text = widget.dataTransaksi!.users!.username.toString();
    tanggal.text =
        formatTglIndo(date: widget.dataTransaksi!.topupDate.toString());
    waktu.text =
        formatJamIndo(date: widget.dataTransaksi!.topupDate.toString());
    nominal.text = widget.dataTransaksi!.nominal.toString();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isload
        ? Container(
            color: primarycolor,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: defaultappbar(
              title: "Konfirmasi Top-up Saldo",
              btncek: ModalRoute.of(context)?.canPop ?? false,
              ontap: () {
                Navigator.pop(context);
              },
              backgroundcolor: Theme.of(context).colorScheme.primary,
            ),
            backgroundColor: primarycolor,
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  TextFormField(
                    enabled: false,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: surfacecolor),
                      labelText: 'Nama',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    style: TextStyle(color: surfacecolor),
                    readOnly: true,
                    controller: nama,
                  ),
                  TextFormField(
                      enabled: false,
                      decoration: InputDecoration(
                          labelText: 'Tanggal',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(color: surfacecolor)),
                      readOnly: true,
                      controller: tanggal,
                      style: TextStyle(color: surfacecolor)),
                  TextFormField(
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'Waktu',
                        labelStyle: TextStyle(color: surfacecolor),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      readOnly: true,
                      controller: waktu,
                      style: TextStyle(color: surfacecolor)),
                  TextFormField(
                      enabled: false,
                      decoration: InputDecoration(
                          labelText: 'Nominal Top-up',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(color: surfacecolor)),
                      readOnly: true,
                      controller: nominal,
                      style: TextStyle(color: surfacecolor)),
                  SizedBox(
                    height: 270,
                  ),
                  widget.dataTransaksi!.status.toString() ==
                          "Telah Dikonfirmasi"
                      ? SizedBox()
                      : longbtn(
                          ontap: () {
                            setState(() {
                              isload = true;
                              post();
                            });
                          },
                          text: "Konfirmasi")
                ],
              ),
            ),
          );
  }
}
