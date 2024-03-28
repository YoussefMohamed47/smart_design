// ignore_for_file: file_names

import 'package:flutter/material.dart';

class AppColors {
  static const Color appColor = Color(0xff3376BD);
  static const Color appGrey = Color(0xffDFE0F3);
  static const Color textColor = Color(0xff000000);
  static const Color whiteColor = Colors.white;
  static const Color greyColor = Color(0xff695C5C);
  static const Color orangeColor = Color(0xffF19035);
  static const LinearGradient buttonBlue = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      appColor,
      appColor,
    ],
  );
  static const LinearGradient buttonGreen = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xff0BB02F),
      Color(0xff0BB02F),
    ],
  );
}
