
import 'package:client_book_flutter/blocks/appointment_list/appointment_list_block.dart';
import 'package:client_book_flutter/blocks/appointment_list/events/appointment_list_block_events.dart';
import 'package:client_book_flutter/blocks/appointment_list/states/appointment_list_block_states.dart';
import 'package:client_book_flutter/ui/app_progress/app_progress.dart';
import 'package:client_book_flutter/ui/appointment_list/appointment_widget.dart';
import 'package:client_book_flutter/utils/app_font.dart';
import 'package:client_book_flutter/utils/colors.dart';
import 'package:client_book_flutter/utils/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentListWidget extends StatelessWidget {

  final bool isClientList;

  const AppointmentListWidget({super.key, this.isClientList = false});

  @override
  Widget build(BuildContext context) {
    final AppointmentListBlock bloc = isClientList
    ? BlocProvider.of<SpecialClientAppointmentListBlock>(context)
    : BlocProvider.of<MainAppointmentListBlock>(context);
    
    return BlocBuilder(
      bloc: bloc,
      builder: (context, state) {
        if (state is! ListAppointmentListBlockState) {
          return ListView(children: const [
            Center(child: AppProgressWidget(strokeWidth: 5, size: 40))
          ]);
        }

        if (state.list.isEmpty) {
          return ListView(children: [
            Center(child: Text(
              S.of(context).nothing_yet,
              style: const TextStyle(
                fontSize: 20,
                fontFamily: AppFont.m,
                fontWeight: FontWeight.bold,
                color: AppColors.accentText
              )
            ))
          ]);
        }

        final nowTime = DateTime.now();

        return ListView.builder(
          itemCount: state.list.length,
          itemBuilder:(context, index) {
            final item = state.list[index];

            if (index == 0) {
              bloc.add(OldestScrolledAppointmentListBlockEvent(
                lastAppointmentTime: item.data.appointment.startTime)
              );
            } else if (index == state.list.length - 1) {
              bloc.add(NewestScrolledAppointmentListBlockEvent(
                newestAppointmentTime: item.data.appointment.startTime)
              );
            }
            
            item.key ??= GlobalKey();

            final previousItem = index == 0? null: state.list[index - 1].data; 

            return AppointmentWidget(
              key: item.key,
              nowTime: nowTime,
              appointmentClient: item.data,
              previousAppointmentClient: previousItem 
            );
          }
        );
      }
    );
  }
}