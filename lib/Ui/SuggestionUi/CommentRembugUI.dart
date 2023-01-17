import 'dart:convert';

import 'package:e_villlage/Data/Formated/dayformated.dart';
import 'package:e_villlage/Data/Model/ApiResponse.dart';
import 'package:e_villlage/Data/Model/RembugModel.dart';
import 'package:e_villlage/Data/Model/commentrembugmodel.dart';
import 'package:e_villlage/Data/Services/Comment_Service.dart';
import 'package:e_villlage/Data/Services/user_services.dart';
import 'package:e_villlage/Data/settings.dart';
import 'package:e_villlage/Ui/GetStarted/Login_ui.dart';
import 'package:e_villlage/Ui/Theme.dart';
import 'package:e_villlage/Ui/Widget/LoadWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class CommentUrunRembugUI extends StatefulWidget {
  CommentUrunRembugUI({Key? key, required this.rembug}) : super(key: key);
  Rembug rembug;

  @override
  State<CommentUrunRembugUI> createState() => _CommentUrunRembugUIState();
}

class _CommentUrunRembugUIState extends State<CommentUrunRembugUI> {
  bool isload = true;
  bool error = false;
  RembugData? rembugData;
  String img = "";
  String? datenow;
  String? datenow2;
  int daynow = 0;
  int? userid;
  CommentRembugModel? commentRembugModel;

  TextEditingController comment = TextEditingController();
  TextEditingController commentupdate = TextEditingController();

  void upatecomment({required String? commentid}) async {
    ApiResponse response = await updatecommentt(
        id: commentid.toString(), comment: commentupdate.text);

    if (response.data != null) {
      setState(() {
        isload = false;
        getdata();
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Berhasil memperbarui comment')));
    } else if (response.error == unauthroized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false)
          });
    } else {
      setState(() {
        isload = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  void deletecomment({required String? commentid}) async {
    ApiResponse response = await deletecommentt(id: commentid.toString());

    if (response.data != null) {
      setState(() {
        isload = false;

        getdata();
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Berhasil menghapus comment')));
    } else if (response.error == unauthroized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false)
          });
    } else {
      setState(() {
        isload = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  void _postrembug() async {
    ApiResponse response = await commentpost(
        comment: comment.text, idpost: widget.rembug.id.toString());

    if (response.data != null) {
      setState(() {
        isload = false;
        comment.text = "";
        getdata();
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Berhasil Posting')));
    } else if (response.error == unauthroized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false)
          });
    } else {
      setState(() {
        isload = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  void getdata() async {
    int iduser = await getUserid();
    String token = await getToken();
    final res = await http.get(
        Uri.parse(baseurl_evillageapi +
            "/api/user/rembug/comment/" +
            widget.rembug.id.toString()),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    commentRembugModel =
        CommentRembugModel.fromJson(json.decode(res.body.toString()));

    DateTime dt = DateTime.parse(DateTime.now().toString());
    String daynoww = DateFormat('dd').format(dt);

    String datenoww = formatTglIndo(date: DateTime.now().toString());
    String datenoww2 = formatBulanIndo(date: DateTime.now().toString());

    setState(() {
      error = false;
      datenow = datenoww;
      daynow = int.parse(daynoww);
      datenow2 = datenoww2;
      userid = iduser;
      isload = false;
    });
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return isload
        ? isloadingwidget()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Padding(
              padding: isKeyboardOpen
                  ? EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom)
                  : const EdgeInsets.all(1.0),
              child: SizedBox(
                height: 48,
                child: TextFormField(
                  style: TextStyle(color: surfacecolor),
                  controller: comment,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                      color: hinttext,
                    ),
                    hintText: "Tambah komentar",
                    fillColor: inputtxtbg,
                    filled: true,
                    suffixIcon: InkWell(
                      onTap: () {
                        if (comment.text != "") {
                          setState(() {
                            isload = true;
                            _postrembug();
                          });
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Perhatian"),
                                content: Text("Komentar tidak boleh kosong!"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Oke"))
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: SizedBox(
                          height: 20,
                          width: 20,
                          child: Icon(
                            Icons.send_outlined,
                            color: surfacecolor,
                          )),
                    ),
                  ),
                ),
              ),
            ),
            backgroundColor: primarycolor,
            appBar: AppBar(
              backgroundColor: primarycolor,
              elevation: 0,
              centerTitle: true,
              title: Text(
                "Komentar",
                style: TextStyle(color: accentcolor),
              ),
              automaticallyImplyLeading: false,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios_new_rounded,
                      color: accentcolor)),
            ),
            body: Container(
              margin: EdgeInsets.only(bottom: 40),
              child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
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
                                            image: NetworkImage(widget
                                                .rembug.users!.imageUser
                                                .toString()),
                                            fit: BoxFit.cover),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: Colors.grey),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                    widget.rembug.users!.username.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: surfacecolor),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      formatTglIndo(
                                                  date: widget
                                                      .rembug.createdDate
                                                      .toString()) ==
                                              datenow.toString()
                                          ? "Hari ini"
                                          : daykmrin(
                                                              date: widget
                                                                  .rembug
                                                                  .createdDate
                                                                  .toString())
                                                          .toString() +
                                                      formatBulanIndo(
                                                          date: widget.rembug
                                                              .createdDate
                                                              .toString()) ==
                                                  daynow.toString() +
                                                      datenow2.toString()
                                              ? "Kemarin"
                                              : formatTglIndo(
                                                  date: widget
                                                      .rembug.createdDate
                                                      .toString()),
                                      style: TextStyle(
                                          fontSize: 8,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            widget.rembug.deskripsi.toString(),
                            style: TextStyle(fontSize: 12, color: surfacecolor),
                          ),
                        ),
                        widget.rembug.image != null
                            ? Container(
                                margin: const EdgeInsets.only(top: 20),
                                height: 175,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            widget.rembug.image.toString()),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Text("Komentar",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: surfacecolor)),
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: commentRembugModel!.comments!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          child: ListTile(
                        trailing: commentRembugModel!.comments![index].idUser
                                    .toString() ==
                                userid.toString()
                            ? PopupMenuButton(
                                icon: Icon(
                                  Icons.more_vert_rounded,
                                  color: surfacecolor,
                                ),
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem<int>(
                                      value: 0,
                                      child: Text("Edit"),
                                    ),
                                    PopupMenuItem<int>(
                                      value: 1,
                                      child: Text("Delete"),
                                    ),
                                  ];
                                },
                                onSelected: (value) {
                                  if (value == 0) {
                                    setState(() {
                                      commentupdate.text = commentRembugModel!
                                          .comments![index].comment
                                          .toString();
                                    });
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Edit Comment"),
                                          content: TextFormField(
                                            controller: commentupdate,
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Batal")),
                                            TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    Navigator.pop(context);
                                                    isload = true;
                                                    upatecomment(
                                                        commentid:
                                                            commentRembugModel!
                                                                .comments![
                                                                    index]
                                                                .id
                                                                .toString());
                                                  });
                                                },
                                                child: Text("Update"))
                                          ],
                                        );
                                      },
                                    );
                                  } else if (value == 1) {
                                    setState(() {
                                      isload = true;
                                      deletecomment(
                                          commentid: commentRembugModel!
                                              .comments![index].id
                                              .toString());
                                    });
                                  }
                                })
                            : null,
                        leading: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(commentRembugModel!
                                      .comments![index].users!.imageUser
                                      .toString()),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.grey),
                        ),
                        title: Text(
                          commentRembugModel!.comments![index].users!.username
                              .toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: surfacecolor),
                        ),
                        subtitle: Text(
                          commentRembugModel!.comments![index].comment
                              .toString(),
                          style: TextStyle(fontSize: 12, color: surfacecolor),
                        ),
                      ));
                    },
                  ),
                ],
              ),
            ),
          );
  }
}
