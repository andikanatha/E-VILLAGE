import 'package:e_villlage/Ui/Theme.dart';
import 'package:e_villlage/Ui/Widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondarycolor,
      appBar: defaultappbar(
          title: "Notifikasi",
          ontap: () {
            Navigator.pop(context);
          },
          backgroundcolor: Theme.of(context).colorScheme.primary,
          btncek: ModalRoute.of(context)?.canPop ?? false),
      body: Stack(
        children: [
          Container(
            height: 200,
            color: secondarycolor,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: primarycolor),
            constraints:
                BoxConstraints(minHeight: MediaQuery.of(context).size.height),
            child: ListView(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(37, 0, 0, 0),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          color: boxcolor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          title: Text(
                            "Pembayaran Sampah",
                            style: TextStyle(
                                color: surfacecolor,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "Hore, pembayaran sampah bulan ini sukses!",
                            style: TextStyle(color: surfacecolor),
                          ),
                          trailing: Column(
                            children: [
                              Text(
                                "10:00",
                                style: TextStyle(color: surfacecolor),
                              )
                            ],
                          ),
                          leading: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 218, 236, 242),
                                  borderRadius: BorderRadius.circular(7)),
                              height: 60,
                              width: 60,
                              child: Center(
                                child: Icon(Icons.report),
                              )),
                        ));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
