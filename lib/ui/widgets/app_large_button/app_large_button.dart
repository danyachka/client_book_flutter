

import 'package:client_book_flutter/utils/app_font.dart';
import 'package:client_book_flutter/utils/colors.dart';
import 'package:flutter/material.dart';

class AppLargeButton extends StatelessWidget {

  final void Function() onTapped;
  final String text;

  const AppLargeButton({super.key, 
    required this.onTapped, 
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapped, 
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(24)
        ),
        child: Row(children: [
          Text(text,
            style: const TextStyle(
              color: AppColors.accentTextDarker,
              fontFamily: AppFont.m,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis
            )
          ),

          const Spacer(),


          const Icon(
            Icons.arrow_forward,
            color: AppColors.accentTextDarker,
            size: 28
          )
        ])
      )
    );
  }
}