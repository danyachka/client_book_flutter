import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:client_book_flutter/core/widgets/app_clickable/app_button.dart';
import 'package:flutter/material.dart';

class AppFloatingButton extends StatelessWidget {
  final void Function() onClick;

  const AppFloatingButton({super.key, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return AppButton(
        onClick: onClick,
        color: AppColors.primaryDarker,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        child:
            const Icon(Icons.check_rounded, size: 32, color: AppColors.darkBackground));
  }
}

class PositionedAppFloatingButton extends StatelessWidget {
  final void Function() onClick;
  const PositionedAppFloatingButton({super.key, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        right: 12, bottom: 24, child: AppFloatingButton(onClick: onClick));
  }
}
