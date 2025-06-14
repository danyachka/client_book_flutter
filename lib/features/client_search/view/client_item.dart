

import 'package:client_book_flutter/core/model/app_database.dart';
import 'package:client_book_flutter/core/utils/app_font.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:client_book_flutter/core/widgets/app_clickable/clickable.dart';
import 'package:flutter/material.dart';

class ClientItem extends StatelessWidget {

  final void Function() onClick;
  final Client client;
  
  const ClientItem({super.key, required this.client, required this.onClick});

  @override
  Widget build(BuildContext context) {
    final row = Row(children: [
      SizedBox(
        height: 48,
        child: AspectRatio(aspectRatio: 1, child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.grayDarker
          ),
          child: const Icon(Icons.person_rounded, color: AppColors.white, size: 30),
        )
      )),

      const SizedBox(width: 12),

      Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(client.name,
            style: const TextStyle(
                fontFamily: AppFont.m,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.accentText)),

        const SizedBox(height: 3),

        Text(client.phoneNumber,
            style: const TextStyle(
                fontFamily: AppFont.m,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.accentTextDarker))
      ])

    ]);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Clickable(
        onClick: onClick,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: row
        )
      ),
    );
  }
}