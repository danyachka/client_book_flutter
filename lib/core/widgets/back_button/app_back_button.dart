

import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:client_book_flutter/core/widgets/app_clickable/clickable.dart';
import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Clickable(
        onClick: () => Navigator.pop(context),
        radius: 32,
        child: const Padding(
            padding: EdgeInsets.all(6),
            child: Icon(Icons.arrow_back_rounded, color: AppColors.primary, size: 26)
        )
    );
  }
}