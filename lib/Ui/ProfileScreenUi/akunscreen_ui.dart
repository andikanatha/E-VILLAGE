import 'dart:ffi';
import 'dart:ui';
import 'dart:io';

import 'package:e_villlage/Data/Model/ApiResponse.dart';
import 'package:e_villlage/Data/Model/UserModel.dart';
import 'package:e_villlage/Data/Services/user_services.dart';
import 'package:e_villlage/Data/settings.dart';
import 'package:e_villlage/Ui/GetStarted/Login_ui.dart';
import 'package:e_villlage/Ui/Theme.dart';
import 'package:e_villlage/Ui/Widget/widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  UserModel? user;
  bool error = false;
  bool isload = true;
  File? _imageFile;
  final _picker = ImagePicker();
  String imgg = '';

  TextEditingController username = TextEditingController();
  TextEditingController name = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  void updateimgfun() async {
    ApiResponse response = await updateimg(image_profile: imgg);
    setState(() {
      isload = false;
      Navigator.pop(context);
    });
    if (response.error == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.data}')));
    } else if (response.error == unauthroized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  void getuser() async {
    ApiResponse response = await getuserdetail();
    if (response.data != null) {
      setState(() {
        error = false;
        user = response.data as UserModel;
        name.text = user!.name ?? "";
        username.text = user!.username ?? "";
        isload = false;
      });
    } else if (response.error != null) {
      isload = false;
      error = true;
    }
  }

  Future getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        imgg = getStringImage(_imageFile).toString();
      });
    }
  }

  @override
  void initState() {
    getuser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultappbar(
        title: "Akun",
        btncek: ModalRoute.of(context)?.canPop ?? false,
        ontap: () {
          Navigator.pop(context);
        },
        backgroundcolor: Theme.of(context).colorScheme.primary,
      ),
      backgroundColor: primarycolor,
      body: ListView(
        children: [
          Stack(
            children: [
              Container(
                color: Theme.of(context).colorScheme.primary,
                height: 200,
              ),
              Container(
                decoration: BoxDecoration(
                    color: primarycolor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: isload
                    ? Container(
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 80),
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 150,
                                      width: 150,
                                      decoration: BoxDecoration(
                                          image: _imageFile == null
                                              ? user!.image_user != null
                                                  ? DecorationImage(
                                                      image: NetworkImage(user!
                                                          .image_user
                                                          .toString()),
                                                      fit: BoxFit.cover)
                                                  : DecorationImage(
                                                      image: AssetImage(
                                                          "Asset/Image/default-image-user.png"),
                                                      fit: BoxFit.cover)
                                              : DecorationImage(
                                                  image: FileImage(
                                                      _imageFile ?? File('')),
                                                  fit: BoxFit.cover),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: defaultbgimg),
                                    ),
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            color: Color.fromARGB(
                                                255, 218, 236, 242)),
                                        child: IconButton(
                                            onPressed: () {
                                              getImage();
                                            },
                                            icon: Icon(
                                              Icons.edit,
                                              color: secondarycolorhigh,
                                            )),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 30),
                            padding: EdgeInsets.all(20),
                            child: Form(
                              key: formkey,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Nama",
                                        style: TextStyle(
                                            color: surfacecolor,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                      controller: username,
                                      validator: (val) => val!.isEmpty
                                          ? 'Mohon isi nama pengguna anda!'
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
                                          hintText: 'nama pengguna')),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Nama Lengkap",
                                        style: TextStyle(
                                            color: surfacecolor,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                      controller: name,
                                      validator: (val) => val!.isEmpty
                                          ? 'Mohon isi nama lengkap anda!'
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
                                          hintText: 'nama lengkap pengguna')),
                                  Container(
                                    margin: EdgeInsets.only(top: 100),
                                    child: longbtn(
                                        ontap: () {
                                          if (formkey.currentState!
                                              .validate()) {
                                            if (imgg == '') {
                                              setState(() {
                                                isload = true;
                                              });
                                            } else {
                                              setState(() {
                                                isload = true;
                                              });
                                              updateimgfun();
                                              print("IMGG :" + imgg);
                                            }
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
              )
            ],
          ),
        ],
      ),
    );
  }
}
