import 'dart:ffi';
import 'dart:ui';
import 'dart:io';

import 'package:e_villlage/Data/Formated/formated.dart';
import 'package:e_villlage/Data/Model/ApiResponse.dart';
import 'package:e_villlage/Data/Model/UserModel.dart';
import 'package:e_villlage/Data/Services/user_services.dart';
import 'package:e_villlage/Data/settings.dart';
import 'package:e_villlage/Ui/GetStarted/Login_ui.dart';
import 'package:e_villlage/Ui/Theme.dart';
import 'package:e_villlage/Ui/Widget/ErrorWidget.dart';
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

  void _updateuser() async {
    ApiResponse response = await updateuser(name: name.text);

    if (response.error == null) {
      if (username.text == user!.username) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${response.data}')));
      } else {
        ApiResponse res = await updateusername(username: username.text);
        if (res.error == null) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${res.data}')));
        } else if (res.error == unauthroized) {
          logout().then((value) => {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false)
              });
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${res.error}')));
        }
      }
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
    } else if (response.error == unauthroized) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
          (route) => false);
    } else {
      setState(() {
        isload = false;
        error = true;
      });
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
    return isload
        ? Container(
            color: Theme.of(context).colorScheme.primary,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : error
            ? iserror(ontap: () {
                setState(() {
                  getuser();
                  isload = true;
                });
              })
            : Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: defaultappbar(
                  title: "Akun",
                  btncek: ModalRoute.of(context)?.canPop ?? false,
                  ontap: () {
                    Navigator.pop(context);
                  },
                  backgroundcolor: Theme.of(context).colorScheme.primary,
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
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
                      isload
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
                                                            image: NetworkImage(
                                                                user!.image_user
                                                                    .toString()),
                                                            fit: BoxFit.cover)
                                                        : DecorationImage(
                                                            image: AssetImage(
                                                                "Asset/Image/default-image-user.png"),
                                                            fit: BoxFit.cover)
                                                    : DecorationImage(
                                                        image: FileImage(
                                                            _imageFile ??
                                                                File('')),
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
                                                      BorderRadius.circular(
                                                          100),
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
                                                hintText:
                                                    'nama lengkap pengguna')),
                                        Container(
                                          margin: EdgeInsets.only(top: 100),
                                          child: longbtn(
                                              ontap: () {
                                                if (formkey.currentState!
                                                    .validate()) {
                                                  if (imgg == '') {
                                                    setState(() {
                                                      isload = true;
                                                      _updateuser();
                                                    });
                                                  } else {
                                                    setState(() {
                                                      isload = true;
                                                    });
                                                    updateimg(
                                                        image_profile: imgg);
                                                    _updateuser();
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
                    ],
                  ),
                ),
              );
  }
}
