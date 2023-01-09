import 'package:e_villlage/Ui/Theme.dart';
import 'package:e_villlage/Ui/Widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FAQBANTUANUI extends StatefulWidget {
  const FAQBANTUANUI({Key? key}) : super(key: key);

  @override
  State<FAQBANTUANUI> createState() => _FAQBANTUANUIState();
}

class _FAQBANTUANUIState extends State<FAQBANTUANUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: defaultappbar(
        title: "FAQ dan Bantuan",
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
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                SvgPicture.asset("Asset/Svg/helpassets.svg"),
                SizedBox(
                  height: 50,
                ),
                text(
                    head: "Tentang aplikasi ini",
                    body:
                        'Aplikasi ini adalah aplikasi yang dipergunakan untuk desa menjadi mandi dan modern.'),
                text(
                    head: "Apa saja fitur aplikasi ini?",
                    body:
                        'Aplikasi ini dapat dioperasikan dengan mudah dan dapat mempermudah pembayaran sampah / PDAM, Memberi saran antar pengguna, dan Lapor Kades'),
                text(
                    head: "Bagaimana cara bayar di aplikasi ini?",
                    body:
                        'Cara untuk membayar pada aplikasi ini cukup mudah. Pengguna dapat scan barcode yang sudah tersedia, lalu pengguna dapat memasukan nominal dan keterangan setelah itu pengguna dapat membayar transaksi tersebut.'),
                text(
                    head: "Kenapa harus menggunakan aplikasi ini?",
                    body:
                        'Karena aplikasi ini dapat mempermudah pekerjaan dalam pembayaran dan meminimalisasikan oknum yang ingin korupsi. Dan menjadikan desa yang modern, mandiri, dan desa anti korupsi.')
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget text({required String head, required String body}) {
    return ExpansionTile(
      iconColor: surfacecolor,
      trailing: Icon(
        Icons.add,
        color: surfacecolor,
      ),
      collapsedIconColor: surfacecolor,
      collapsedBackgroundColor: primarycolor,
      backgroundColor: primarycolor,
      title: Container(
        width: MediaQuery.of(context).size.width,
        child: Text(
          head,
          style: TextStyle(
              fontSize: 14, color: surfacecolor, fontWeight: FontWeight.bold),
        ),
      ),
      children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 21),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                body,
                style: TextStyle(fontSize: 12, color: surfacecolor),
              ),
            ))
      ],
    );
  }
}
