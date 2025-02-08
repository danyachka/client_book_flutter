
import 'package:client_book_flutter/utils/app_font.dart';
import 'package:client_book_flutter/utils/colors.dart';
import 'package:flutter/material.dart';

class ErrorTextWidget extends StatelessWidget {

  final String text;

  const ErrorTextWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: const TextStyle(
        color: AppColors.red,
        fontSize: 12,
        fontFamily: AppFont.m,
        fontWeight: FontWeight.bold
      ),
    );
  }
}