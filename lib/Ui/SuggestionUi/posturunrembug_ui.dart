import 'dart:ffi';
import 'dart:ui';
import 'dart:io';

import 'package:e_villlage/Data/Formated/formated.dart';
import 'package:e_villlage/Ui/Theme.dart';
import 'package:e_villlage/Ui/Widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class UrunRembugPostUI extends StatefulWidget {
  const UrunRembugPostUI({Key? key}) : super(key: key);

  @override
  State<UrunRembugPostUI> createState() => _UrunRembugPostUIState();
}

class _UrunRembugPostUIState extends State<UrunRembugPostUI> {
  File? _imageFile;
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
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Gambar/Video"),
                        InkWell(
                          onTap: () {
                            getImage();
                          },
                          child: Container(
                            height: 180,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                image: _imageFile == null
                                    ? null
                                    : DecorationImage(
                                        image:
                                            FileImage(_imageFile ?? File('')),
                                        fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(20),
                                color: inputtxtbg),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text("Saran Anda"),
                        TextFormField(
                            maxLines: 4,
                            validator: (val) => val!.isEmpty
                                ? 'Mohon Masukkan Saran Anda!'
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
                                hintText: 'masukkan saran anda')),
                        Container(
                          margin: EdgeInsets.only(top: 180),
                          child: longbtn(
                              ontap: () {
                                if (formkey.currentState!.validate()) {}
                              },
                              text: "Simpan"),
                        )
                      ],
                    ),
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
