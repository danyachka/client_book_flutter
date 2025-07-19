

import 'package:client_book_flutter/core/utils/s.dart';
import 'package:client_book_flutter/core/widgets/app_clickable/app_button.dart';
import 'package:client_book_flutter/features/appointment_list/viewmodel/appointment_list_bloc.dart';
import 'package:client_book_flutter/features/appointment_list/viewmodel/events/appointment_list_bloc_events.dart';
import 'package:client_book_flutter/features/client_search/view/clients_list_page.dart';
import 'package:client_book_flutter/features/main/page/main_page.dart';
import 'package:client_book_flutter/features/calendar/view/calendar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class CalendarFragment extends StatefulWidget {

  final ChangeFragmentCallback changeFragmentCallBack;

  const CalendarFragment({super.key, 
    required this.changeFragmentCallBack
  });


  @override
  State<CalendarFragment> createState() => _CalendarFragmentState();
}

class _CalendarFragmentState extends State<CalendarFragment> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(bottom: false, child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), 
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          CalendarWidget(
            onDatePicked:(pickedDate) async {
              GetIt.I<MainAppointmentListBloc>().add(
                ScrollToDateAppointmentListBlocEvent(time: pickedDate.millisecondsSinceEpoch)
              );
              widget.changeFragmentCallBack(MainPageFragment.list);
            },
          ),

          const SizedBox(height: 12),

          AppTextButton(
            onClick: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const ClientsListPage() 
              ));
            }, 
            text: S.of(context).find_client
          )
        ])
      )
    );
  }
}