import 'dart:convert';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:e_villlage/Data/Model/UserSearchModel.dart';
import 'package:e_villlage/Data/Services/user_services.dart';
import 'package:e_villlage/Data/settings.dart';
import 'package:e_villlage/Icons/navbar_icons_icons.dart';
import 'package:e_villlage/Ui/HomeScreenUi/homescreen_ui.dart';
import 'package:e_villlage/Ui/PembayaranUI/KirimsaldoQR.dart';
import 'package:e_villlage/Ui/PembayaranUI/PembayaranUI.dart';
import 'package:e_villlage/Ui/ProfileScreenUi/profile_ui.dart';
import 'package:e_villlage/Ui/RiwayatUi/riwayat_ui.dart';
import 'package:e_villlage/Ui/SuggestionUi/Urunrembug_ui.dart';
import 'package:e_villlage/Ui/Theme.dart';
import 'package:e_villlage/Ui/Widget/LoadWidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class NavBotBar extends StatefulWidget {
  const NavBotBar({Key? key}) : super(key: key);

  @override
  State<NavBotBar> createState() => _NavBotBarState();
}

class _NavBotBarState extends State<NavBotBar> {
  UserSearchModel? userSearchModel;
  bool isload = false;

  ScanResult? scanResult;
  int _index = 0;

  void _showModalSheet(int i) {
    showModalBottomSheet(
        backgroundColor: primarycolor,
        context: context,
        builder: (builder) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            height: 170,
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PembayaranUI(action: "sampah"),
                        ));
                  },
                  leading: Icon(
                    Icons.recycling,
                    color: accentcolor,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: accentcolor,
                  ),
                  title: Text(
                    "Pembayaran Sampah",
                    style: TextStyle(color: surfacecolor),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PembayaranUI(action: "PDAM"),
                        ));
                  },
                  leading: Icon(
                    Icons.water,
                    color: accentcolor,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: accentcolor,
                  ),
                  title: Text(
                    "Pembayaran PDAM",
                    style: TextStyle(color: surfacecolor),
                  ),
                )
              ],
            ),
          );
        });
  }

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
      if (scanResult!.rawContent == baseurl_evillageapi.toString()) {
        _index = _index + 1;
        _showModalSheet(_index);
      } else if (scanResult!.rawContent == "") {
      } else {
        String token = await getToken();

        final responsegetuser = await http.get(
            Uri.parse(baseurl_evillageapi +
                "/api/user/get/" +
                scanResult!.rawContent.toString()),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token'
            });

        userSearchModel = UserSearchModel.fromJson(
            json.decode(responsegetuser.body.toString()));

        if (userSearchModel!.users!.length > 0) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Perhatian"),
                content: Text("Apa kamu yakin untuk kirim saldo ke " +
                    userSearchModel!.users![0].username.toString() +
                    "?"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Tidak")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => KirimSaldoQR(
                                  user: userSearchModel!.users![0]),
                            ));
                      },
                      child: Text("Ya"))
                ],
              );
            },
          );
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
    return isload
        ? isloadingwidget()
        : Scaffold(
            body: screen[_screenindex],
            floatingActionButton: FloatingActionButton(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(
                  NavbarIcons.scan,
                  color: Colors.white,
                ),
                onPressed: () {
                  _scan();
                }),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              shape: CircularNotchedRectangle(),
              child: BottomNavigationBar(
                backgroundColor: primarycolor,
                type: BottomNavigationBarType.fixed,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(NavbarIcons.home),
                    label: "Beranda",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(NavbarIcons.people),
                    label: "Saran",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(NavbarIcons.history),
                    label: "Riwayat",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(NavbarIcons.profile),
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
