import 'dart:ffi';

import 'package:e_villlage/Ui/Theme.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget defaultappbar(
    {required String title,
    required Function()? ontap,
    required Color backgroundcolor,
    required bool btncek}) {
  return AppBar(
    backgroundColor: backgroundcolor,
    elevation: 0,
    centerTitle: true,
    title: Text(
      title,
      style: appbartitlestyle,
    ),
    leading: btncek == true
        ? IconButton(
            onPressed: ontap,
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ))
        : null,
    automaticallyImplyLeading: false,
  );
}

Widget longbtn({
  required Function()? ontap,
  required String text,
}) {
  return Container(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
        onPressed: ontap,
        child: Text(
          text,
          style: TextStyle(color: primarycolor, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 0,
            primary: secondarycolorhigh)),
  );
}
