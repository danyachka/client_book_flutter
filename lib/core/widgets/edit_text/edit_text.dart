
import 'package:client_book_flutter/core/utils/app_font.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppEditTextWidget extends StatelessWidget {
  final TextEditingController controller;

  final String hint;

  final bool isPassword;

  final EdgeInsets contentPadding;
  
  final double radius;

  final Color? backgroundColor;

  final TextAlign textAlign;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final double fontSize;

  final FocusNode? focusNode;

  final int maxLines;

  final EdgeInsets scrollPadding;

  final void Function()? onTap;

  final TextCapitalization textCapitalization;

  final bool digitsOnly;

  final bool expands;

  const AppEditTextWidget({
    super.key,
    required this.controller,
    required this.hint,
    this.isPassword = false,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
    this.radius = 20,
    this.backgroundColor,
    this.textAlign = TextAlign.center,
    this.prefixIcon,
    this.suffixIcon,
    this.fontSize = 14,
    this.maxLines = 1,
    this.focusNode,
    this.scrollPadding = const EdgeInsets.all(20),
    this.onTap,
    this.textCapitalization = TextCapitalization.none,
    this.expands = false,
    this.digitsOnly = false
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      textCapitalization: textCapitalization,
      onTap: onTap,
      scrollPadding: scrollPadding,
      minLines: expands? null: 1,
      maxLines: expands? null: maxLines,
      focusNode: focusNode,
      obscureText: isPassword,
      controller: controller,
      expands: expands,
      
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius), 
          borderSide: const BorderSide(color: AppColors.white)
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius), 
          borderSide: const BorderSide(color: AppColors.accentTextLighter)
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: AppColors.accentText)
        ),
        fillColor: backgroundColor,
        filled: backgroundColor != null,
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
          color: AppColors.accentText,
          fontSize: fontSize,
          fontFamily: AppFont.m,
          fontWeight: FontWeight.bold),
      inputFormatters: digitsOnly? [FilteringTextInputFormatter.digitsOnly] : null,
    );
  }
}
