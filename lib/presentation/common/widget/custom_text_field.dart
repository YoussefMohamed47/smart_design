import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../utils/strings/images.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final TextInputType keyboardType;
  final Widget? suffixWidget;
  final Widget? prefixWidget;
  final ValueChanged<String>? onChanged;
  Function()? onTap;
  final String? hint;
  TextAlign? textAlign;
  double? hintFontSize;
  bool isEnabled;
  bool isReadOnly;
  Color? hintTextColor = Colors.black;
  String? hintFontFamily;
  double borderRadius;
  Color? borderColor;
  Color? unFocusedBorderColor;
  Color fillColor;
  Color? counterColor;
  int? maxLines;
  int? maxLength;
  FontWeight? hintFontWeight;

  EdgeInsets? contentPadding;
  final String? Function(String?)? fieldValidator;

  bool isPassword;

  CustomTextField({
    Key? key,
    required this.textEditingController,
    required this.keyboardType,
    this.onChanged,
    this.hintFontWeight,
    this.borderColor,
    this.unFocusedBorderColor,
    this.hint,
    this.textAlign = TextAlign.start,
    this.isPassword = false,
    required this.fieldValidator,
    this.hintFontSize,
    this.maxLines,
    this.maxLength,
    this.contentPadding,
    this.counterColor,
    this.hintFontFamily,
    this.fillColor = Colors.white,
    this.hintTextColor,
    this.isEnabled = true,
    this.borderRadius = 20,
    this.isReadOnly = false,
    this.onTap,
    this.suffixWidget,
    this.prefixWidget,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool visible = true;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: TextFormField(
        controller: widget.textEditingController,
        textAlign: widget.textAlign!,
        keyboardType: widget.keyboardType,
        validator: widget.fieldValidator,
        maxLength: widget.maxLength,
        onChanged: widget.onChanged,
        onTap: widget.onTap ?? () {},
        maxLines: widget.maxLines ?? 1,
        obscureText: widget.isPassword
            ? visible
                ? true
                : false
            : false,
        readOnly: widget.isReadOnly,
        decoration: InputDecoration(
          enabled: widget.isEnabled,
          counterStyle: TextStyle(
            color: widget.counterColor,
            fontFamily: widget.hintFontFamily,
            fontSize: 15.sp,
          ),
          filled: true,
          isDense: true,
          fillColor: widget.fillColor,
          prefixIcon: widget.prefixWidget,
          suffixIcon: widget.isPassword && widget.suffixWidget == null
              ? InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    setState(() {
                      visible = !visible;
                    });
                  },
                  child: widget.suffixWidget == null
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 8.h),
                          child: !visible
                              ? Icon(
                                  Icons.visibility_rounded,
                                  color: HexColor('#FF6600'),
                                  size: 28.h,
                                )
                              : Padding(
                                  padding: EdgeInsets.zero,
                                  child: SvgPicture.asset(
                                    AppImagesPath.passwordEyeIcon,
                                    width: 28.w,
                                    height: 28.h,
                                  ),
                                ),
                        )
                      : Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4.0, vertical: 2.h),
                              child: !visible
                                  ? const Icon(
                                      Icons.visibility_rounded,
                                      color: Colors.grey,
                                    )
                                  : SvgPicture.asset(
                                      AppImagesPath.passwordEyeIcon),
                            ),
                            widget.suffixWidget ?? const SizedBox()
                          ],
                        ))
              : widget.suffixWidget,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(
              color: HexColor('#FF6600'),
              width: 1,
            ), //<-- SEE HERE
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(
              color: HexColor('#707070'),
            ),
          ),
          errorStyle: TextStyle(
            color: Colors.red,
            fontSize: 12.sp,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(
              color: Colors.red,
            ), //<-- SEE HERE
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(
              color: Colors.red,
            ), //<-- SEE HERE
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(
              color: widget.unFocusedBorderColor ?? Colors.transparent,
            ), //<-- SEE HERE
          ),
          hintText: widget.hint ?? "",
          contentPadding: widget.contentPadding ??
              const EdgeInsets.symmetric(
                horizontal: 16,
              ),
          hintStyle: TextStyle(
            color: widget.hintTextColor,
            fontSize: widget.hintFontSize,
            fontFamily: widget.hintFontFamily,
            fontWeight: widget.hintFontWeight,
          ),
        ),
      ),
    );
  }
}
