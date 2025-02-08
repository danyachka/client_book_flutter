

import 'package:client_book_flutter/model/app_database.dart';
import 'package:client_book_flutter/utils/app_font.dart';
import 'package:client_book_flutter/utils/colors.dart';
import 'package:flutter/material.dart';

class ClientItem extends StatelessWidget {

  final Client client;
  
  const ClientItem({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    final column = Row(children: [
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

      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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

    return GestureDetector(
      onTap: () {
        // TODO: open client page
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: column
      )
    );
  }
}