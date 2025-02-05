
import 'package:client_book_flutter/ui/widgets/appointment_list/appointment_list_widget.dart';
import 'package:client_book_flutter/utils/app_font.dart';
import 'package:client_book_flutter/utils/colors.dart';
import 'package:client_book_flutter/utils/s.dart';
import 'package:flutter/material.dart';

class ListFragment extends StatelessWidget {

  static const listCordersRadius = 26.0; 

  const ListFragment({super.key});

  void onPlusTapped() {
    // TODO: open bottomcheet to create clients or appointments
  }

  void onSettingsTapped() {
    // TODO: open setting to update db
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false, 
      child: Column(children: [
        Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), child: Row(children: [
          Text(
            S.of(context).title,
            style: const TextStyle(
              fontSize: 22,
              fontFamily: AppFont.m,
              fontWeight: FontWeight.bold,
              color: AppColors.accentText
            )
          ),

          const Spacer(),

          GestureDetector(
            onTap: onPlusTapped,
            child: const Icon(Icons.add_rounded, color: AppColors.primary, size: 26)
          ),

          const SizedBox(width: 6),

          GestureDetector(
            onTap: onSettingsTapped,
            child: const Icon(Icons.settings_rounded, color: AppColors.primary, size: 26)
          )
        ])),

        const Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(listCordersRadius), 
              topRight: Radius.circular(listCordersRadius)
            ),
            child: AppointmentListWidget(),
          ) 
        )
      ])
    );
  }
}
