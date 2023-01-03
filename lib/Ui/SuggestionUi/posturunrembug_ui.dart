import 'dart:ffi';
import 'dart:ui';
import 'dart:io';

import 'package:e_villlage/Data/Formated/formated.dart';
import 'package:e_villlage/Data/Model/ApiResponse.dart';
import 'package:e_villlage/Data/Services/rembug_services.dart';
import 'package:e_villlage/Data/Services/user_services.dart';
import 'package:e_villlage/Data/settings.dart';
import 'package:e_villlage/Ui/GetStarted/Login_ui.dart';
import 'package:e_villlage/Ui/Theme.dart';
import 'package:e_villlage/Ui/Widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class UrunRembugPostUI extends StatefulWidget {
  const UrunRembugPostUI({Key? key}) : super(key: key);

  @override
  State<UrunRembugPostUI> createState() => _UrunRembugPostUIState();
}

class _UrunRembugPostUIState extends State<UrunRembugPostUI> {
  File? _imageFile;
  bool isload = false;
  final _picker = ImagePicker();
  String imgg = '';
  Future getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        imgg = getStringImage(_imageFile).toString();
      });
    }
  }

  void _postrembug() async {
    ApiResponse response =
        await postrembug(deskripsi: deskripsi.text, image: imgg);

    if (response.error == null) {
      Navigator.pop(context);
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

  TextEditingController deskripsi = TextEditingController();

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: defaultappbar(
        btncek: ModalRoute.of(context)?.canPop ?? false,
        title: "Tambah Saran",
        ontap: () {
          Navigator.pop(context);
        },
        backgroundcolor: Theme.of(context).colorScheme.primary,
      ),
      body: isload
          ? Container(
              color: primarycolor,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
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
                  Form(
                    key: formkey,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width,
                          child: Form(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Gambar"),
                                InkWell(
                                  onTap: () {
                                    getImage();
                                  },
                                  child: Container(
                                    height: 180,
                                    width: MediaQuery.of(context).size.width,
                                    child: _imageFile == null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: SvgPicture.asset(
                                              "Asset/Svg/Assetpostimg.svg",
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Image.file(
                                              _imageFile ?? File(""),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: inputtxtbg),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text("*",
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.red)),
                                    Text(
                                      "Opsional, bisa menambahkan atau tidak",
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text("Saran Anda"),
                                TextFormField(
                                    controller: deskripsi,
                                    maxLines: 4,
                                    validator: (val) => val!.isEmpty
                                        ? 'Mohon Masukkan Saran Anda!'
                                        : null,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
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
                                        hintText: 'masukkan saran anda')),
                                Container(
                                  margin: EdgeInsets.only(top: 180),
                                  child: longbtn(
                                      ontap: () {
                                        if (formkey.currentState!.validate()) {
                                          setState(() {
                                            isload = true;
                                            _postrembug();
                                          });
                                        }
                                      },
                                      text: "Simpan"),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
