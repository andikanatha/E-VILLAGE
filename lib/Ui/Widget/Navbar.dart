import 'package:e_villlage/Ui/HomeScreenUi/homescreen_ui.dart';
import 'package:e_villlage/Ui/ProfileScreenUi/profile_ui.dart';
import 'package:e_villlage/Ui/RiwayatUi/riwayat_ui.dart';
import 'package:e_villlage/Ui/SuggestionUi/suggestion_ui.dart';
import 'package:flutter/material.dart';

class NavBotBar extends StatefulWidget {
  const NavBotBar({Key? key}) : super(key: key);

  @override
  State<NavBotBar> createState() => _NavBotBarState();
}

class _NavBotBarState extends State<NavBotBar> {
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
      floatingActionButton: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.white,
        ),
        child: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Icon(Icons.card_giftcard),
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                    height: 200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: InkWell(
                              onTap: () {},
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            title: Text("Kirim Saldo"),
                          ),
                          ListTile(
                            leading: InkWell(
                              onTap: () {},
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            title: Text("Kirim Saldo"),
                          ),
                          ListTile(
                            leading: InkWell(
                              onTap: () {},
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            title: Text("Kirim Saldo"),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 2,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
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
