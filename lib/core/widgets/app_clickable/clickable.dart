

import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:flutter/material.dart';

class Clickable extends StatelessWidget {

  final void Function() onClick;
  final Color rippleColor;
  final double radius;
  final Widget child;

  const Clickable({
    super.key, 
    required this.onClick,
    this.rippleColor = AppColors.primaryDarkTrans, 
    this.radius = 32, 
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(radius);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onClick,
        hoverColor: rippleColor,
        splashColor: rippleColor,
        highlightColor: rippleColor,
        focusColor: rippleColor,
        borderRadius: borderRadius,
        child: child
      )
    );
  }
}

class BackgroundClickable extends StatelessWidget {

  final void Function() onClick;
  final Color rippleColor;
  final Color color;
  final double radius;
  final Widget child;

  const BackgroundClickable({
    super.key, 
    required this.onClick,
    this.rippleColor = AppColors.primary, 
    this.color = AppColors.primary, 
    this.radius = 32, 
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(radius);
    return InkWell(
      onTap: onClick,
      hoverColor: rippleColor,
      splashColor: rippleColor,
      highlightColor: rippleColor,
      focusColor: rippleColor,
      borderRadius: borderRadius,
      child: Material(
        color: color,
        borderRadius: borderRadius,
        child: child,
      )
    );
  }
}

