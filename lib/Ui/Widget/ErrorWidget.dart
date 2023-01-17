import 'package:e_villlage/Ui/Theme.dart';
import 'package:flutter/material.dart';

Widget iserror({required Function()? ontap}) {
  return Container(
    color: primarycolor,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Ada masalah dengan jaringan kamu nih!"),
          IconButton(onPressed: ontap, icon: Icon(Icons.refresh))
        ],
      ),
    ),
  );
}
