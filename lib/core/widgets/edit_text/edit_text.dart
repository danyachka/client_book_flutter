
import 'package:client_book_flutter/core/utils/app_font.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:flutter/material.dart';

class AppEditTextWidget extends StatelessWidget {
  final TextEditingController controller;

  final String hint;

  final bool isPassword;

  final EdgeInsets contentPadding;

  final TextAlign textAlign;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final double fontSize;

  final FocusNode? focusNode;

  final int maxLines;

  final EdgeInsets scrollPadding;

  final void Function()? onTap;

  final TextCapitalization textCapitalization;

  const AppEditTextWidget({
    super.key,
    required this.controller,
    required this.hint,
    this.isPassword = false,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
    this.textAlign = TextAlign.center,
    this.prefixIcon,
    this.suffixIcon,
    this.fontSize = 16,
    this.maxLines = 1,
    this.focusNode,
    this.scrollPadding = const EdgeInsets.all(20),
    this.onTap,
    this.textCapitalization = TextCapitalization.none
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      textCapitalization: textCapitalization,
      onTap: onTap,
      scrollPadding: scrollPadding,
      minLines: 1,
      maxLines: maxLines,
      focusNode: focusNode,
      obscureText: isPassword,
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        disabledBorder: InputBorder.none,
        hintText: hint,
        hintStyle: TextStyle(
            color: AppColors.editTextHint,
            fontSize: fontSize,
            fontFamily: AppFont.m,
            fontWeight: FontWeight.bold),
        alignLabelWithHint: true,
        contentPadding: contentPadding,
      ),
      textAlign: textAlign,
      style: TextStyle(
          color: AppColors.white,
          fontSize: fontSize,
          fontFamily: AppFont.m,
          fontWeight: FontWeight.bold),
    );
  }
}
