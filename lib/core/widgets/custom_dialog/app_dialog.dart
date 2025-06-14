

import 'package:client_book_flutter/core/utils/app_font.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:flutter/material.dart';

class _AppDialog extends StatelessWidget {

  final String title;
  final Widget child;

  const _AppDialog({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
            style: const TextStyle(
              color: AppColors.accentTextDarker,
              fontSize: 14,
              fontFamily: AppFont.m,
              fontWeight: FontWeight.bold
            ),
          ),

          const SizedBox(height: 8),

          child
        ]
      ),
    );
  }
}

void showAppDialog(BuildContext context, {
    required String title,
    required Widget child
}) {
   showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: AppColors.darkBackground,
        child: _AppDialog(
          title: title,
          child: child
        )
      );
    }
   );
}