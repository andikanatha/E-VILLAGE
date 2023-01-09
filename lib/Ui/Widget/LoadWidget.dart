import 'package:e_villlage/Ui/Theme.dart';
import 'package:flutter/material.dart';

Widget isloadingwidget() {
  return Container(
    color: primarycolor,
    child: Center(child: CircularProgressIndicator()),
  );
}
