import 'package:e_villlage/Ui/Theme.dart';
import 'package:e_villlage/Ui/Widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({Key? key}) : super(key: key);

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  child: TabBarView(children: [pembayaranui(), pelaporanui()])),
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
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                margin: EdgeInsets.only(top: 15),
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
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("19-10-2022"),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 2,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(37, 0, 0, 0),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(
                                "Laporan 1",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text("12-12-2022"),
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
                },
              ),
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
          itemCount: 10,
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
                title: Text(
                  "Laporan 1",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("12-12-2022"),
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
