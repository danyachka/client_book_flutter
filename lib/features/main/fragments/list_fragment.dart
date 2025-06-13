
import 'package:client_book_flutter/core/widgets/app_clickable/clickable.dart';
import 'package:client_book_flutter/features/main/other/creation_picker_bottom_sheet.dart';
import 'package:client_book_flutter/features/appointment_list/view/appointment_list_widget.dart';
import 'package:client_book_flutter/core/utils/app_font.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:client_book_flutter/core/utils/s.dart';
import 'package:flutter/material.dart';

class ListFragment extends StatelessWidget {

  static const listCordersRadius = 26.0; 

  const ListFragment({super.key});

  void onPlusTapped(BuildContext context) {
    showModalBottomSheet(
      context: context, 
      builder:(newContext) => const CreationPickerBottomSheet()
    );
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

          Clickable(
            onClick: () => onPlusTapped(context),
            rippleColor: AppColors.primaryDark,
            child: const Padding(
              padding: EdgeInsets.all(4), 
              child: Icon(Icons.add_rounded, color: AppColors.primary, size: 26)
            )
          ),

          const SizedBox(width: 4),

          Clickable(
            onClick: onSettingsTapped,
            rippleColor: AppColors.primaryDark,
            child: const Padding(
              padding: EdgeInsets.all(4), 
              child: Icon(Icons.settings_rounded, color: AppColors.primary, size: 26)
            )
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
