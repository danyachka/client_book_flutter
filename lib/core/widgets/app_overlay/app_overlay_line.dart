

import 'package:client_book_flutter/core/utils/app_font.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:client_book_flutter/core/widgets/app_clickable/clickable.dart';
import 'package:flutter/material.dart';

class AppOverlayLine extends StatelessWidget {
  final String text;
  final IconData iconData;
  final void Function() onClick;
  
  const AppOverlayLine({super.key, required this.iconData, required this.text, required this.onClick});

  @override
  Widget build(BuildContext context) {
    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(iconData, size: 24, color: AppColors.accentTextDarker),

        const SizedBox(width: 12),

        Text(
          text,
          maxLines: 1,
          style: const TextStyle(
                  fontSize: 13,
                  overflow: TextOverflow.ellipsis,
                  fontFamily: AppFont.m,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accentTextDarker)
        ),
      ]
    );

    return Clickable(onClick: onClick, child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: row
    ));
  }
}