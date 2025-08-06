

import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:flutter/material.dart';

class CardBackground extends StatelessWidget {
  final Widget child;
  const CardBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24)
      ),
      child: child
    );
  }
}

class LargeCardBackground extends StatelessWidget {
  final Widget child;
  const LargeCardBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: AppColors.cardBackground
        ),
        child: child
    );
  }
}