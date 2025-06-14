

import 'package:client_book_flutter/core/utils/app_font.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {

  final void Function() onClick;

  final double radius;
  final Color color;
  final EdgeInsets? padding;
  final Alignment alignment;

  final Widget child;
  
  const AppButton({super.key, 
    required this.onClick, 
    this.radius = 32, 
    this.color = AppColors.primaryLight, 
    this.padding, 
    this.alignment = Alignment.centerLeft,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onClick,
      style: ElevatedButton.styleFrom(
        backgroundColor: color, // Background color
        alignment: alignment,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius), // Corner radius
        ),
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16), // Button padding
        elevation: 0,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size.zero
      ),
      child: child
    );

  }
}

class AppTextButton extends StatelessWidget {

  final void Function() onClick;

  final String text;

  final IconData? icon;

  const AppTextButton({super.key, 
    required this.onClick, 
    required this.text, 
    this.icon
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
        onClick: onClick,
        color: AppColors.primaryLight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (icon != null) Icon(icon, size: 24, color: AppColors.primaryDarker),

            if (icon != null) const SizedBox(width: 8),

            Text(text,
                style: const TextStyle(
                    color: AppColors.accentTextDarker,
                    fontFamily: AppFont.m,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis
                )
            )
          ]
        )
    );
  }
}