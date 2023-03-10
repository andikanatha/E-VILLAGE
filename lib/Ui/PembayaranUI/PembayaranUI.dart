import 'dart:ffi';
import 'dart:io';

import 'package:e_villlage/Data/Formated/formated.dart';
import 'package:e_villlage/Data/Model/ApiResponse.dart';
import 'package:e_villlage/Data/Model/PembayaranModel.dart';
import 'package:e_villlage/Data/Services/pembayaran_services.dart';
import 'package:e_villlage/Data/Services/user_services.dart';
import 'package:e_villlage/Data/settings.dart';
import 'package:e_villlage/Ui/GetStarted/Login_ui.dart';
import 'package:e_villlage/Ui/Theme.dart';
import 'package:e_villlage/Ui/Widget/LoadWidget.dart';
import 'package:e_villlage/Ui/Widget/Navbar.dart';
import 'package:e_villlage/Data/Formated/dayformated.dart';
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
  //FINGERR

  bool avaliablefinger = false;
  bool isauthen = false;

  //FINGERR

  void get() async {
    String getpinvar = await getpin();
    setState(() {
      pin = getpinvar;
    });
  }

  String currentText = "";
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController month = TextEditingController();
  TextEditingController nominal = TextEditingController();
  TextEditingController keterangan = TextEditingController();
  bool isload = false;

  String datefor = "";
  int nominalint = 0;
  String pin = "";

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
      datefor: datefor,
      keterangan: keterangan.text,
      name: widget.action.toString(),
      transactiontotal: nominalint.toString(),
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
    get();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isload
        ? isloadingwidget()
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
            backgroundColor: secondarycolor,
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
                                  style: TextStyle(color: surfacecolor),
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
                                        month.text = formatBulanIndo(
                                            date: selectedmonth.toString());
                                        datefor = selectedmonth.toString();
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
                                        color: hinttext,
                                      ),
                                      hintText: 'Bulan')),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: TextFormField(
                                  style: TextStyle(color: surfacecolor),
                                  onChanged: (value) {
                                    setState(() {
                                      nominalint = int.parse(value);
                                    });
                                  },
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
                                        color: hinttext,
                                      ),
                                      hintText: 'Nominal')),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Masukkan hanya angka, jangan memasukan simbol lain",
                                  style: TextStyle(
                                      fontSize: 10, color: surfacecolor),
                                ),
                                Text("!",
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.red)),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: TextFormField(
                                  style: TextStyle(color: surfacecolor),
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
                                        color: hinttext,
                                      ),
                                      hintText: 'Keterangan')),
                            ),
                            SizedBox(
                              height: 300,
                            ),
                            longbtn(
                                ontap: () {
                                  if (formkey.currentState!.validate()) {
                                    if (nominalint > 500) {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text("Masukkan Pin Anda"),
                                            content: Form(
                                                child: PinCodeTextField(
                                              onCompleted: (value) {
                                                if (value.toString() == pin) {
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
                                                              child:
                                                                  Text("Oke")),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                }
                                              },
                                              keyboardType:
                                                  TextInputType.number,
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
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Mohon masukkan nominal dengan sesuai, minimal trx adalah Rp.500')));
                                    }
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
