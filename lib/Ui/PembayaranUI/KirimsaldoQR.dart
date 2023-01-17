import 'dart:convert';

import 'package:e_villlage/Data/Model/ApiResponse.dart';
import 'package:e_villlage/Data/Model/PembayaranModel.dart';
import 'package:e_villlage/Data/Model/UserSearchModel.dart';
import 'package:e_villlage/Data/Services/pembayaran_services.dart';
import 'package:e_villlage/Data/Services/user_services.dart';
import 'package:e_villlage/Data/settings.dart';
import 'package:e_villlage/Ui/GetStarted/Login_ui.dart';
import 'package:e_villlage/Ui/Theme.dart';
import 'package:e_villlage/Ui/Widget/LoadWidget.dart';
import 'package:e_villlage/Ui/Widget/Navbar.dart';
import 'package:e_villlage/Ui/Widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:http/http.dart' as http;

class KirimSaldoQR extends StatefulWidget {
  KirimSaldoQR({Key? key, required this.user}) : super(key: key);
  Users user;

  @override
  State<KirimSaldoQR> createState() => _KirimSaldoUIState();
}

class _KirimSaldoUIState extends State<KirimSaldoQR> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController nominal = TextEditingController();
  TextEditingController user = TextEditingController();
  TextEditingController keterangan = TextEditingController();
  bool isload = false;
  int nominalint = 0;
  String query = "`";
  String pin = "";
  int idusernow = 0;

  bool isloaduser = false;
  UserSearchModel? userSearchModel;

  void getpinn() async {
    final pinn = await getpin();
    setState(() {
      pin = pinn;
    });
  }

  void transferpost() async {
    ApiResponse response = await transfer(
      keterangan: keterangan.text,
      seconduser: query,
      transactiontotal: nominalint.toString(),
    );

    if (response.error == null) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NavBotBar(),
          ));
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

  @override
  void initState() {
    getpinn();
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
              title: "Kirim saldo ke " + widget.user.username.toString(),
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
                              padding: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                  color: inputtxtbg,
                                  borderRadius: BorderRadius.circular(20)),
                              child: ListTile(
                                title: Text(widget.user.username.toString(),
                                    style: TextStyle(color: surfacecolor)),
                                subtitle: Text(widget.user.name.toString(),
                                    style: TextStyle(color: surfacecolor)),
                                leading: Container(
                                  height: 40,
                                  width: 40,
                                  child: widget.user.imageUser != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: Image.network(
                                              widget.user.imageUser.toString()),
                                        )
                                      : SvgPicture.asset(
                                          "Asset/Svg/DefaultImg.svg"),
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(100)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
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
                                  maxLines: 3,
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
                                      hintStyle: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: hinttext,
                                      ),
                                      hintText: 'Keterangan')),
                            ),
                            SizedBox(
                              height: 200,
                            ),
                            longbtn(
                                ontap: () {
                                  if (widget.user.id == idusernow) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Oke"))
                                          ],
                                          title: Text("Perhatian"),
                                          content: Text(
                                              "User yang anda pilih merupakan diri anda sendiri, mohon memilih user dengan valid"),
                                        );
                                      },
                                    );
                                  } else {
                                    setState(() {
                                      query = widget.user.username.toString();
                                      if (formkey.currentState!.validate()) {
                                        if (query != "") {
                                          if (nominalint > 500) {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title:
                                                      Text("Masukkan Pin Anda"),
                                                  content: Form(
                                                      child: PinCodeTextField(
                                                    onCompleted: (value) {
                                                      if (value.toString() ==
                                                          pin) {
                                                        setState(() {
                                                          isload = true;
                                                        });
                                                        Navigator.pop(context);
                                                        transferpost();
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
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                        "Oke")),
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
                                                      activeFillColor:
                                                          Colors.grey,
                                                    ),
                                                    length: 4,
                                                    appContext: context,
                                                    onChanged: (value) {
                                                      setState(() {});
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
                                                                FontWeight
                                                                    .bold),
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
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Mohon untuk memilih user yang akan ditransfer saldo')));
                                        }
                                      }
                                    });
                                    ;
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
