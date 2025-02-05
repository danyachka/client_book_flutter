
import 'package:client_book_flutter/utils/colors.dart';
import 'package:flutter/material.dart';

class AppProgressWidget extends StatelessWidget {

  final double? strokeWidth; 
  final double? size;
  final Color? color;

  const AppProgressWidget({
    super.key, 
    this.strokeWidth,
    this.size,
    this.color
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size, 
      height: size, 
      child: CircularProgressIndicator(
        color: color??AppColors.primary,
        strokeWidth: strokeWidth??4,
        strokeCap: StrokeCap.round,
    ));
  }
}