import 'package:e_villlage/Data/Formated/dayformated.dart';
import 'package:e_villlage/Data/Model/RembugModel.dart';
import 'package:e_villlage/Data/Services/rembug_services.dart';
import 'package:e_villlage/Ui/Theme.dart';
import 'package:e_villlage/Ui/Widget/ErrorWidget.dart';
import 'package:e_villlage/Ui/Widget/widget.dart';
import 'package:flutter/material.dart';

class KelolaUrunRembugUI extends StatefulWidget {
  KelolaUrunRembugUI({Key? key}) : super(key: key);

  @override
  State<KelolaUrunRembugUI> createState() => _KelolaUrunRembugUIState();
}

class _KelolaUrunRembugUIState extends State<KelolaUrunRembugUI> {
  bool isload = true;
  bool error = false;
  RembugData? rembugData;
  String img = "";
  @override
  Widget build(BuildContext context) {
    return error
        ? iserror(ontap: () {
            setState(() {
              isload = true;
              getallrembug();
            });
          })
        : isload
            ? Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Scaffold(
                backgroundColor: Theme.of(context).colorScheme.primary,
                appBar: defaultappbar(
                  btncek: ModalRoute.of(context)?.canPop ?? false,
                  title: "Urun rembug",
                  ontap: () {
                    Navigator.pop(context);
                  },
                  backgroundcolor: Theme.of(context).colorScheme.primary,
                ),
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
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(20),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                Container(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: rembugData!.rembug!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        margin: const EdgeInsets.only(
                                          top: 15,
                                        ),
                                        padding: EdgeInsets.all(20),
                                        width: 315,
                                        decoration: BoxDecoration(
                                          boxShadow: const [
                                            BoxShadow(
                                              color:
                                                  Color.fromARGB(37, 0, 0, 0),
                                              spreadRadius: 2,
                                              blurRadius: 7,
                                              offset: Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 35,
                                                    child: Expanded(
                                                      child: Container(
                                                        height: 35,
                                                        width: 35,
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                                image: NetworkImage(
                                                                    rembugData!
                                                                        .rembug![
                                                                            index]
                                                                        .users!
                                                                        .imageUser
                                                                        .toString()),
                                                                fit: BoxFit
                                                                    .cover),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            color: Colors.grey),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 7,
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 10),
                                                      child: Text(
                                                        rembugData!
                                                            .rembug![index]
                                                            .users!
                                                            .username
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          "Hari ini",
                                                          style: TextStyle(
                                                              fontSize: 8,
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Text(
                                                rembugData!
                                                    .rembug![index].deskripsi
                                                    .toString(),
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ),
                                            rembugData!.rembug![index].image !=
                                                    null
                                                ? Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 20),
                                                    height: 135,
                                                    width: 300,
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                rembugData!
                                                                    .rembug![
                                                                        index]
                                                                    .image
                                                                    .toString()),
                                                            fit: BoxFit.cover),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.grey),
                                                  )
                                                : Container(),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 20),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 5),
                                                          child: InkWell(
                                                            onTap: () {},
                                                            child: Icon(
                                                              Icons
                                                                  .favorite_outline,
                                                              size: 18,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primary,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 5),
                                                          child: InkWell(
                                                            onTap: () {},
                                                            child: Icon(
                                                              Icons.share,
                                                              size: 18,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primary,
                                                            ),
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {},
                                                          child: Icon(
                                                            Icons.reply_all,
                                                            size: 18,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          formatJamIndo(
                                                              date: rembugData!
                                                                  .rembug![
                                                                      index]
                                                                  .createdAt
                                                                  .toString()),
                                                          style: TextStyle(
                                                              fontSize: 8,
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
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
