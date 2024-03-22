
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:questionnaire/utils/strings/hex_color_strings.dart';

class TextQuestion extends StatefulWidget {
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
  Color fillColor;
  int? maxLength;
  int? maxLines;
  int? minLines;

  EdgeInsets? contentPadding;
  final String? Function(String?)? fieldValidator;

  bool isPassword;
  List<TextInputFormatter>? inputFormatters;
  TextQuestion({
    Key? key,
    required this.textEditingController,
    required this.keyboardType,
    this.onChanged,
    this.hint,
    this.textAlign = TextAlign.start,
    this.isPassword = false,
    required this.fieldValidator,
    this.hintFontSize,
    this.maxLength,
    this.contentPadding,
    this.hintFontFamily,
    this.fillColor = Colors.white,
    this.hintTextColor,
    this.isEnabled = true,
    this.borderRadius = 20,
    this.isReadOnly = false,
    this.onTap,
    this.suffixWidget,
    this.prefixWidget,
    this.maxLines,
    this.minLines,
    this.inputFormatters,
  }) : super(key: key);

  @override
  State<TextQuestion> createState() => _TextQuestionState();
}

class _TextQuestionState extends State<TextQuestion> {
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
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        onChanged: widget.onChanged,
        onTap: widget.onTap ?? () {},
        inputFormatters: widget.inputFormatters,
        obscureText: widget.isPassword
            ? visible
            ? true
            : false
            : false,
        readOnly: widget.isReadOnly,
        decoration: InputDecoration(
          enabled: widget.isEnabled,
          filled: true,
          fillColor: widget.fillColor,
          prefixIcon: widget.prefixWidget,
          suffixIcon: widget.suffixWidget,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(
              color: HexColor('#707070'),
            ), //<-- SEE HERE
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(
              color: HexColor('#707070'),
            ),
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
              color: HexColor('#707070'),
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
          ),
        ),
      ),
    );
  }
}
