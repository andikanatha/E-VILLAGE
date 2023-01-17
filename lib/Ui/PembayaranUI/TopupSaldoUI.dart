import 'package:e_villlage/Data/Model/ApiResponse.dart';
import 'package:e_villlage/Data/Services/Topupsaldo_services.dart';
import 'package:e_villlage/Data/Services/user_services.dart';
import 'package:e_villlage/Data/settings.dart';
import 'package:e_villlage/Ui/GetStarted/Login_ui.dart';
import 'package:e_villlage/Ui/Theme.dart';
import 'package:e_villlage/Ui/Widget/LoadWidget.dart';
import 'package:e_villlage/Ui/Widget/Navbar.dart';
import 'package:e_villlage/Ui/Widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class TopupSaldoUI extends StatefulWidget {
  const TopupSaldoUI({Key? key}) : super(key: key);

  @override
  State<TopupSaldoUI> createState() => _TopupSaldoUIState();
}

class _TopupSaldoUIState extends State<TopupSaldoUI> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController nominal = TextEditingController();
  TextEditingController catatan = TextEditingController();

  void posttopup() async {
    ApiResponse response =
        await topupsaldo(deskripsi: catatan.text, nominal: nominal.text);

    if (response.error == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Berhasil Mengirim Permintaan Topup Saldo"),
            content: Text(
                "Permintaan topup saldo sebesar 1000 telah berhasil dikirimkan, mohon menunggu konfirmasi, dan saldo akan masuk ke akun anda"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NavBotBar(),
                      ));
                },
                child: Text(
                  "Oke",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          );
        },
      );
    } else if (response.error == unauthroized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false)
          });
    } else {
      setState(() {
        isload = false;
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${response.error}')));
      });
    }
  }

  bool isload = false;
  int nominalint = 0;
  @override
  Widget build(BuildContext context) {
    return isload
        ? isloadingwidget()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: defaultappbar(
              title: "Top-up saldo",
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
                                        color: hinttext,
                                        fontSize: 12,
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
                              height: 20,
                            ),
                            Container(
                              child: TextFormField(
                                  style: TextStyle(color: surfacecolor),
                                  controller: catatan,
                                  validator: (val) => val!.isEmpty
                                      ? 'Mohon Isi Catatan!'
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
                                        color: hinttext,
                                        fontSize: 12,
                                      ),
                                      hintText: 'Catatan')),
                            ),
                            SizedBox(
                              height: 400,
                            ),
                            longbtn(
                                ontap: () {
                                  if (formkey.currentState!.validate()) {
                                    setState(() {
                                      isload = true;
                                      posttopup();
                                    });
                                  }
                                },
                                text: "Kirim")
                          ],
                        ),
                      ))
                ],
              ),
            ),
          );
  }
}
