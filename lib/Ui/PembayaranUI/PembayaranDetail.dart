import 'package:e_villlage/Data/Formated/dayformated.dart';
import 'package:e_villlage/Data/Model/ApiResponse.dart';
import 'package:e_villlage/Data/Model/PembayaranDetailModel.dart';
import 'package:e_villlage/Data/Model/PembayaranModelGet.dart';
import 'package:e_villlage/Data/Services/pembayaran_services.dart';
import 'package:e_villlage/Data/settings.dart';
import 'package:e_villlage/Ui/GetStarted/Login_ui.dart';
import 'package:e_villlage/Ui/Theme.dart';
import 'package:e_villlage/Ui/Widget/ErrorWidget.dart';
import 'package:e_villlage/Ui/Widget/Navbar.dart';
import 'package:e_villlage/Ui/Widget/widget.dart';
import 'package:flutter/material.dart';

class Detailpembayaran extends StatefulWidget {
  Detailpembayaran({Key? key, required this.id}) : super(key: key);
  int id;

  @override
  State<Detailpembayaran> createState() => _DetailpembayaranState();
}

class _DetailpembayaranState extends State<Detailpembayaran> {
  String action = "";
  DetailTrx? detailTrx;
  bool error = false;
  bool isload = true;

  void getdata() async {
    ApiResponse response = await getdetailtrx(id: widget.id.toString());
    if (response.error == null) {
      setState(() {
        error = false;
        detailTrx = response.data as DetailTrx;
        if (detailTrx!.trx_name.toString() == "Pembayaran sampah") {
          setState(() {
            action = "Terima kasih telah membayar Sampah bulan ini...";
          });
        } else if (detailTrx!.trx_name.toString() == "Pembayaran PDAM") {
          setState(() {
            action = "Terima kasih telah membayar PDAM bulan ini...";
          });
        } else {
          action = "Transfer saldo telah berhasil";
        }
        isload = false;
      });
    } else if (response.error == unauthroized) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
          (route) => false);
    } else {
      setState(() {
        print(response.error);
        // isload = false;
        error = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
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
              title: " Struk Pembayaran",
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
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "Pembayaran Sukses!",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  Text(
                                    action,
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 196, 196, 196),
                                        fontSize: 11),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Serial-ID",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 121, 121, 121),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              detailTrx!.id.toString(),
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            Divider(
                              color: Colors.grey,
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Jenis Pembayaran",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 121, 121, 121),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              detailTrx!.trx_name.toString(),
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            Divider(
                              color: Colors.grey,
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Nama",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 121, 121, 121),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              detailTrx!.nameuser.toString(),
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            Divider(
                              color: Colors.grey,
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "tanggal pembayaran",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 121, 121, 121),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              formatTglIndo(
                                  date: detailTrx!.trx_date.toString()),
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            Divider(
                              color: Colors.grey,
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Waktu pembayaran",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 121, 121, 121),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              formatJamIndo(
                                  date: detailTrx!.trx_date.toString()),
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            Divider(
                              color: Colors.grey,
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Untuk Pembayaran Bulan apa?",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 121, 121, 121),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              formatBulanIndo(
                                  date: detailTrx!.datefor.toString()),
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            Divider(
                              color: Colors.grey,
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Keterangan",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 121, 121, 121),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              detailTrx!.description.toString(),
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            Divider(
                              color: Colors.grey,
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Nominal  ",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 121, 121, 121),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              detailTrx!.total_trx.toString(),
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            Divider(
                              color: Colors.grey,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 80,
                        ),
                        longbtn(
                            ontap: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NavBotBar(),
                                  ),
                                  (route) => false);
                            },
                            text: "Kembali ke home")
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }
}
