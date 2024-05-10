// ignore_for_file: file_names

import 'package:clean_arch_base/utils/strings/appStrings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final double width;
  final double? fontSize;
  final Color buttonColor;
  final Color textColor;
  final String? title;
  final double? height;
  final double? borderRadius;
  final VoidCallback? onpress;
  final Widget? customWidget;
  final FontWeight fontWeight;
  final String fontFamily;
  final BoxBorder? containerBorder;
  final List<BoxShadow>? boxShadow;
  final EdgeInsets? containerPadding;
  const CustomButton({
    Key? key,
    required this.width,
    required this.buttonColor,
    required this.textColor,
    this.title = '',
    this.fontFamily = AppStringsFonts.fontFamilyRegular,
    this.fontSize,
    this.borderRadius = 20,
    this.height,
    this.containerBorder,
    this.containerPadding,
    this.boxShadow,
    this.onpress,
    this.fontWeight = FontWeight.normal,
    this.customWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onpress ?? () {},
      child: Container(
          padding: containerPadding ?? const EdgeInsets.all(3),
          width: width,
          height: height ?? 40.h,
          decoration: BoxDecoration(
            color: buttonColor,
            border: containerBorder,
            borderRadius: BorderRadius.circular(borderRadius!),
            boxShadow: boxShadow,
          ),
          child: Center(
              child: customWidget ??
                  Text(title!,
                      style: TextStyle(
                        color: textColor,
                        fontSize: fontSize ?? 16.sp,
                        fontWeight: fontWeight,
                        fontFamily: fontFamily,
                      )))),
    );
  }
}
