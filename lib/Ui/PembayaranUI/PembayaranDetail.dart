import 'package:e_villlage/Data/Formated/dayformated.dart';
import 'package:e_villlage/Data/Formated/formated.dart';
import 'package:e_villlage/Data/Model/ApiResponse.dart';
import 'package:e_villlage/Data/Model/PembayaranDetailModel.dart';
import 'package:e_villlage/Data/Model/PembayaranModelGet.dart';
import 'package:e_villlage/Data/Services/pembayaran_services.dart';
import 'package:e_villlage/Data/Services/user_services.dart';
import 'package:e_villlage/Data/settings.dart';
import 'package:e_villlage/Ui/Admin/HomescreenAdminUI.dart';
import 'package:e_villlage/Ui/GetStarted/Login_ui.dart';
import 'package:e_villlage/Ui/Theme.dart';
import 'package:e_villlage/Ui/Widget/ErrorWidget.dart';
import 'package:e_villlage/Ui/Widget/LoadWidget.dart';
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
  String role = "";
  DetailTrx? detailTrx;
  bool error = false;
  bool isload = true;

  void getdata() async {
    String akses = await getUserrole();
    ApiResponse response = await getdetailtrx(id: widget.id.toString());
    if (response.error == null) {
      setState(() {
        role = akses;
        error = false;
        detailTrx = response.data as DetailTrx;
        if (detailTrx!.trxName.toString() == "Pembayaran sampah") {
          setState(() {
            action = "Pembayaran Sampah bulan " +
                formatBulanIndo(date: detailTrx!.datefor.toString()) +
                detailTrx!.status.toString();
          });
        } else if (detailTrx!.trxName.toString() == "Pembayaran PDAM") {
          setState(() {
            action = "Pembayaran PDAM bulan " +
                formatBulanIndo(date: detailTrx!.datefor.toString()) +
                detailTrx!.status.toString();
          });
        } else {
          action = "transfer saldo " + detailTrx!.status.toString();
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
        ? isloadingwidget()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: defaultappbar(
              title: "Struk Pembayaran",
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
                                    "Pembayaran " +
                                        detailTrx!.status!.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: surfacecolor),
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
                                  color: surfacecolor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
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
                              detailTrx!.trxName.toString(),
                              style: TextStyle(
                                  color: surfacecolor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
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
                              "Nama Pengirim",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 121, 121, 121),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              detailTrx!.users!.name.toString(),
                              style: TextStyle(
                                  color: surfacecolor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
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
                                  date: detailTrx!.trxDate.toString()),
                              style: TextStyle(
                                  color: surfacecolor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
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
                                  date: detailTrx!.trxDate.toString()),
                              style: TextStyle(
                                  color: surfacecolor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            Divider(
                              color: Colors.grey,
                            )
                          ],
                        ),
                        detailTrx!.jenis.toString() == "pembayaran"
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Untuk Pembayaran Bulan",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 121, 121, 121),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    formatBulanIndo(
                                        date: detailTrx!.datefor.toString()),
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: surfacecolor),
                                    textAlign: TextAlign.left,
                                  ),
                                  Divider(
                                    color: Colors.grey,
                                  )
                                ],
                              )
                            : SizedBox(),
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
                                  color: surfacecolor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
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
                              Idrcvt.convertToIdr(
                                  count:
                                      int.parse(detailTrx!.totalTrx.toString()),
                                  decimalDigit: 2),
                              style: TextStyle(
                                  color: surfacecolor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            Divider(
                              color: Colors.grey,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        longbtn(
                            ontap: () {
                              if (role == "admin") {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeScreenAdmin(),
                                    ),
                                    (route) => false);
                              } else {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NavBotBar(),
                                    ),
                                    (route) => false);
                              }
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
