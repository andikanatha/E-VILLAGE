import 'package:e_villlage/Ui/EventUi/event-detail_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color.fromARGB(255, 181, 226, 161),
            )),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Event",
          style: GoogleFonts.poppins(
              color: Color.fromARGB(255, 181, 226, 161),
              fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailEventScreen(),
                    ));
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      height: 128,
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 10, left: 10, top: 20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 6,
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(
                                      "Lomba antar RW",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    )),
                              ),
                              const Expanded(
                                  child: Text(
                                "10:00",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 181, 226, 161)),
                              )),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 10, bottom: 20),
                                width: 240,
                                child: const Text(
                                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam nec ultricies  velit.Maecenas volutpat est"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              color: Color.fromARGB(255, 181, 226, 161)),
                          child: const Text(
                            "Nama Pengguna",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: const InkWell(
                                    child: Icon(Icons.favorite_outline,
                                        size: 20,
                                        color:
                                            Color.fromARGB(255, 181, 226, 161)),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: const InkWell(
                                    child: Icon(Icons.share,
                                        size: 20,
                                        color:
                                            Color.fromARGB(255, 181, 226, 161)),
                                  ),
                                ),
                                const InkWell(
                                  child: Icon(Icons.reply_all,
                                      size: 20,
                                      color:
                                          Color.fromARGB(255, 181, 226, 161)),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
