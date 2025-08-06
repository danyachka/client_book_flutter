

import 'package:client_book_flutter/core/utils/app_font.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:flutter/material.dart';

class HintText extends StatelessWidget {

  final String text;
  final IconData? icon;

  const HintText({super.key, required this.text, this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      if (icon != null) Icon(icon, size: 24, color: AppColors.primary),
      if (icon != null) const SizedBox(width: 8),

      Text(text,
        style: const TextStyle(
          color: AppColors.accentTextLight,
          fontSize: 14,
          fontFamily: AppFont.m,
          fontWeight: FontWeight.bold
        ),
      )
    ]);
  }
}