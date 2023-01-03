import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:e_villlage/Ui/HomeScreenUi/homescreen_ui.dart';
import 'package:e_villlage/Ui/ProfileScreenUi/profile_ui.dart';
import 'package:e_villlage/Ui/RiwayatUi/riwayat_ui.dart';
import 'package:e_villlage/Ui/SuggestionUi/Urunrembug_ui.dart';
import 'package:e_villlage/Ui/Theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NavBotBar extends StatefulWidget {
  const NavBotBar({Key? key}) : super(key: key);

  @override
  State<NavBotBar> createState() => _NavBotBarState();
}

class _NavBotBarState extends State<NavBotBar> {
  ScanResult? scanResult;
  String qr = "3268";

  Future<void> _scan() async {
    try {
      final result = await BarcodeScanner.scan(
        options: ScanOptions(
          strings: {
            'cancel': "Cancel",
            'flash_on': "Flash on",
            'flash_off': "Flash off",
          },
          restrictFormat: selectedFormats,
          useCamera: -1,
          autoEnableFlash: false,
          android: AndroidOptions(
            aspectTolerance: 0.00,
            useAutoFocus: true,
          ),
        ),
      );
      setState(() => scanResult = result);
    } on PlatformException catch (e) {
      setState(() {
        scanResult = ScanResult(
          type: ResultType.Error,
          format: BarcodeFormat.unknown,
          rawContent: e.code == BarcodeScanner.cameraAccessDenied
              ? 'The user did not grant the camera permission!'
              : 'Unknown error: $e',
        );
      });
    }

    if (scanResult != null) {
      if (scanResult!.rawContent == qr) {
        showDialog(
          context: context,
          builder: (context) {
            return Container(
              child: Column(
                children: [
                  Text(scanResult!.rawContent),
                ],
              ),
            );
          },
        );
      } else if (scanResult!.rawContent == "") {
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Kode Qr Tidak Sesuai"),
              content: Text(
                  "Mohon maaf, kode qr tidak sesuai, harap scan qrcode dengan sesuai dan coba lagi!"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Tutup")),
                TextButton(
                    onPressed: () {
                      _scan();
                      Navigator.pop(context);
                    },
                    child: Text("Coba lagi")),
              ],
            );
          },
        );
      }
    }
  }

  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);

  List<BarcodeFormat> selectedFormats = [..._possibleFormats];

  @override
  void initState() {
    super.initState();
  }

  int _screenindex = 0;
  final screen = [
    const HomeScreen(),
    SugestionScreen(),
    const RiwayatScreen(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen[_screenindex],
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Icon(Icons.card_giftcard),
          onPressed: () {
            _scan();
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 5,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          backgroundColor: primarycolor,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Beranda",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.help),
              label: "Saran",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: "Riwayat",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_sharp),
              label: "Profile",
            ),
          ],
          currentIndex: _screenindex,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          onTap: (value) {
            setState(() {
              _screenindex = value;
            });
          },
        ),
      ),
    );
  }
}
