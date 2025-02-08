

import 'package:client_book_flutter/blocs/appointment_list/appointment_list_bloc.dart';
import 'package:client_book_flutter/blocs/appointment_list/events/appointment_list_bloc_events.dart';
import 'package:client_book_flutter/ui/pages/main_page/main_page.dart';
import 'package:client_book_flutter/ui/widgets/calendar.dart/calendar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalendarFragment extends StatelessWidget {

  final ChangeFragmentCallback changeFragmentCallBack;

  const CalendarFragment({super.key, 
    required this.changeFragmentCallBack
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(bottom: false, child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), 
        child: Column(children: [
          CalendarWidget(
            onDatePicked:(pickedDate) async {
              BlocProvider.of<MainAppointmentListBloc>(context).add(
                ScrollToDateAppointmentListBlocEvent(time: pickedDate.millisecondsSinceEpoch)
              );
              changeFragmentCallBack(MainPageFragment.list);
            },
          ),

          const SizedBox(height: 8),

          // AppLargeButton(
          //   onTapped: () => Navigator.push(context, MaterialPageRoute(
          // builder:(context) => ClientCreationPage(mainAppointmentListBloc: mainAppointmentListBloc))), 
          //   text: text
          // )
        ])
      )
    );
  }
}