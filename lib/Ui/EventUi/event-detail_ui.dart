import 'package:flutter/material.dart';

class DetailEventScreen extends StatefulWidget {
  const DetailEventScreen({Key? key}) : super(key: key);

  @override
  State<DetailEventScreen> createState() => _DetailEventScreenState();
}

class _DetailEventScreenState extends State<DetailEventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 340,
            decoration: const BoxDecoration(
                color: Colors.grey,
                image: DecorationImage(
                    image: NetworkImage(
                        "https://superyou.co.id/blog/wp-content/webpc-passthru.php?src=https://superyou.co.id/blog/wp-content/uploads/2022/08/Sudah-Mau-Hari-Kemerdekaan-Sudah-Tau-Lomba-17-Agustus-yang-Ingin-Diikuti-780x519.jpg&nocache=1"),
                    fit: BoxFit.cover)),
          ),
          ListView(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 280),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                width: double.infinity,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          height: 5,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20)),
                        )
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          const Text(
                            "Lomba 17 an",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(
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
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 20, left: 20),
                          width: 240,
                          child: const Text(
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur "),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 80,
                          child: const Icon(Icons.date_range,
                              color: Color.fromARGB(255, 181, 226, 161)),
                        ),
                        const Text(
                          "10/08/2022",
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 80,
                          child: const Icon(Icons.timelapse_rounded,
                              color: Color.fromARGB(255, 181, 226, 161)),
                        ),
                        const Text(
                          "08:00",
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 80,
                          child: const Icon(Icons.pin_drop,
                              color: Color.fromARGB(255, 181, 226, 161)),
                        ),
                        const Text(
                          "Lapangan",
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          Container(
              margin: const EdgeInsets.only(left: 10, top: 40),
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 25,
                    color: Colors.white,
                  ))),
        ],
      ),
    );
  }
}
