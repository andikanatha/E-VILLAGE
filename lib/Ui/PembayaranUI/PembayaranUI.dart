import 'dart:ffi';
import 'dart:io';

import 'package:e_villlage/Data/Model/ApiResponse.dart';
import 'package:e_villlage/Data/Model/PembayaranModel.dart';
import 'package:e_villlage/Data/Services/pembayaran_services.dart';
import 'package:e_villlage/Data/Services/user_services.dart';
import 'package:e_villlage/Data/settings.dart';
import 'package:e_villlage/Ui/GetStarted/Login_ui.dart';
import 'package:e_villlage/Ui/Theme.dart';
import 'package:e_villlage/Ui/Widget/Navbar.dart';
import 'package:e_villlage/Ui/Widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:popover/popover.dart';

class PembayaranUI extends StatefulWidget {
  PembayaranUI({Key? key, required this.action}) : super(key: key);
  String? action;

  @override
  State<PembayaranUI> createState() => _PembayaranUIState();
}

class _PembayaranUIState extends State<PembayaranUI> {
  String currentText = "";
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController month = TextEditingController();
  TextEditingController nominal = TextEditingController();
  TextEditingController keterangan = TextEditingController();
  bool isload = false;
  String pin = "5432";

  bool ispinerror = false;

  void res(PembayaranModel pembayaranModel) async {
    if (pembayaranModel.massage == "Transaksi Berhasil") {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NavBotBar(),
          ));
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Berhasil Melakukan Pembayaran')));
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(pembayaranModel.massage.toString()),
            content: Text("Mohon maaf, pembayaran anda gagal dilakukan"),
            actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      isload = false;
                    });
                    Navigator.pop(context);
                  },
                  child: Text("Coba kembali")),
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NavBotBar(),
                        ));
                  },
                  child: Text("Oke"))
            ],
          );
        },
      );
    }
  }

  void pembayaranpost() async {
    ApiResponse response = await pembayaran(
      keterangan: keterangan.text,
      name: widget.action.toString(),
      transactiontotal: nominal.text,
    );

    if (response.error == null) {
      res(response.data as PembayaranModel);
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
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isload
        ? Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: defaultappbar(
              title: "Pembayaran " + widget.action.toString(),
              btncek: ModalRoute.of(context)?.canPop ?? false,
              ontap: () {
                Navigator.pop(context);
              },
              backgroundcolor: Theme.of(context).colorScheme.primary,
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
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
                  Form(
                      key: formkey,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                        child: Column(
                          children: [
                            Container(
                              child: TextFormField(
                                  controller: month,
                                  onTap: () async {
                                    final selectedmonth =
                                        await showMonthYearPicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime.now(),
                                    );
                                    if (selectedmonth != null) {
                                      setState(() {
                                        month.text = selectedmonth.toString();
                                      });
                                    }
                                  },
                                  readOnly: true,
                                  validator: (val) =>
                                      val!.isEmpty ? 'Mohon Isi Bulan!' : null,
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
                                      prefixIcon: Icon(
                                        Icons.date_range,
                                        color: surfacecolor,
                                      ),
                                      hintStyle: GoogleFonts.poppins(
                                        fontSize: 12,
                                      ),
                                      hintText: 'Bulan')),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: nominal,
                                  validator: (val) => val!.isEmpty
                                      ? 'Mohon Isi Nominal!'
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
                                      prefixIcon: Icon(
                                        Icons.price_change,
                                        color: surfacecolor,
                                      ),
                                      hintStyle: GoogleFonts.poppins(
                                        fontSize: 12,
                                      ),
                                      hintText: 'Nominal')),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: TextFormField(
                                  controller: keterangan,
                                  validator: (val) => val!.isEmpty
                                      ? 'Mohon Isi Keterangan!'
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
                                      prefixIcon: Icon(
                                        Icons.description,
                                        color: surfacecolor,
                                      ),
                                      hintStyle: GoogleFonts.poppins(
                                        fontSize: 12,
                                      ),
                                      hintText: 'Keterangan')),
                            ),
                            SizedBox(
                              height: 300,
                            ),
                            longbtn(
                                ontap: () {
                                  if (formkey.currentState!.validate()) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Masukkan Pin Anda"),
                                          content: Form(
                                              child: PinCodeTextField(
                                            onCompleted: (value) {
                                              if (value == pin) {
                                                setState(() {
                                                  isload = true;
                                                });
                                                Navigator.pop(context);
                                                pembayaranpost();
                                              } else {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          "Pin Tidak Sesuai!"),
                                                      content: Text(
                                                          "PIN yang anda masukkan tidak sesuai, mohon masukkan pin dengan benar!"),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text("Oke")),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                            keyboardType: TextInputType.number,
                                            pinTheme: PinTheme(
                                              fieldHeight: 50,
                                              fieldWidth: 40,
                                              activeFillColor: Colors.grey,
                                            ),
                                            length: 4,
                                            appContext: context,
                                            onChanged: (value) {
                                              setState(() {
                                                ispinerror = false;
                                                currentText = value;
                                              });
                                            },
                                          )),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                "Batal",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                text: "Bayar")
                          ],
                        ),
                      ))
                ],
              ),
            ),
          );
  }
}
