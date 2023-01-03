import 'package:e_villlage/Data/Model/LaporModel.dart';
import 'package:e_villlage/Ui/Theme.dart';
import 'package:e_villlage/Ui/Widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:e_villlage/Ui/RiwayatUi/riwayat_ui.dart';

class Detaillaporan extends StatefulWidget {
  Detaillaporan({Key? key, required this.dataTransaksi}) : super(key: key);
  DataTransaksi? dataTransaksi;

  @override
  State<Detaillaporan> createState() => _DetaillaporanState();
}

class _DetaillaporanState extends State<Detaillaporan> {
  TextEditingController deskripsi = TextEditingController();
  TextEditingController tempat_kejadian = TextEditingController();

  @override
  void initState() {
    deskripsi.text = widget.dataTransaksi!.deskripsi.toString();
    tempat_kejadian.text = widget.dataTransaksi!.tempatKejadian.toString();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: defaultappbar(
        title: "Lapor kades",
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
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: ListView(
          children: [
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // widget.dataTransaksi!.image.toString() != ""
                      //     ? Container(
                      //         height: 180,
                      //         width: MediaQuery.of(context).size.width,
                      //         child: ClipRRect(
                      //             borderRadius: BorderRadius.circular(20),
                      //             child: Image.network(
                      //                 widget.dataTransaksi!.image.toString())),
                      //         decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(20),
                      //             color: inputtxtbg),
                      //       )
                      //     : SizedBox(),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      Text("Deskripsi Laporan"),
                      TextFormField(
                          readOnly: true,
                          controller: deskripsi,
                          maxLines: 4,
                          validator: (val) => val!.isEmpty
                              ? 'Mohon Masukkan Deskripsi Laporan Anda!'
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
                              ),
                              hintText: 'masukkan deskripsi laporan anda')),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Tempat Kejadian"),
                      TextFormField(
                          readOnly: true,
                          controller: tempat_kejadian,
                          maxLines: 2,
                          validator: (val) => val!.isEmpty
                              ? 'Mohon Masukkan Tempat Kejadian!'
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
                              ),
                              hintText: 'Tempat kejadian perkara')),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
