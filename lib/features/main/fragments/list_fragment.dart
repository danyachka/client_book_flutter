
import 'package:client_book_flutter/core/widgets/app_clickable/clickable.dart';
import 'package:client_book_flutter/features/main/other/creation_picker_bottom_sheet.dart';
import 'package:client_book_flutter/features/appointment_list/view/appointment_list_widget.dart';
import 'package:client_book_flutter/core/utils/app_font.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:client_book_flutter/core/utils/s.dart';
import 'package:client_book_flutter/features/settings_page/view/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_list_view/flutter_list_view.dart';

const listCordersRadius = 24.0; 

class ListFragment extends StatefulWidget {

  final FlutterListViewController scrollController;

  const ListFragment({super.key, required this.scrollController});

  @override
  State<ListFragment> createState() => _ListFragmentState();
}

class _ListFragmentState extends State<ListFragment> with AutomaticKeepAliveClientMixin {


  @override
  bool get wantKeepAlive => true;

  void onPlusTapped(BuildContext context) {
    showModalBottomSheet(
      context: context, 
      builder:(newContext) => const CreationPickerBottomSheet()
    );
  }

  void onSettingsTapped(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => const SettingsPage() 
    ));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      bottom: false, 
      child: Column(children: [
        Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), child: Row(children: [
          Text(
            S.of(context).title,
            style: const TextStyle(
              fontSize: 20,
              fontFamily: AppFont.m,
              fontWeight: FontWeight.bold,
              color: AppColors.accentText
            )
          ),

          const Spacer(),

          Clickable(
            onClick: () => onPlusTapped(context),
            child: const Padding(
              padding: EdgeInsets.all(4), 
              child: Icon(Icons.add_rounded, color: AppColors.primary, size: 26)
            )
          ),

          const SizedBox(width: 4),

          Clickable(
            onClick: () => onSettingsTapped(context),
            child: const Padding(
              padding: EdgeInsets.all(4), 
              child: Icon(Icons.settings_rounded, color: AppColors.primary, size: 26)
            )
          )
        ])),

        Expanded(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(listCordersRadius), 
              topRight: Radius.circular(listCordersRadius)
            ),
            child: AppointmentListWidget(scrollController: widget.scrollController),
          ) 
        )
      ])
    );
  }
}
