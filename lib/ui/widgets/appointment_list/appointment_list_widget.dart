
import 'package:client_book_flutter/blocs/appointment_list/appointment_list_bloc.dart';
import 'package:client_book_flutter/blocs/appointment_list/events/appointment_list_bloc_events.dart';
import 'package:client_book_flutter/blocs/appointment_list/states/appointment_list_bloc_states.dart';
import 'package:client_book_flutter/ui/widgets/app_progress/app_progress.dart';
import 'package:client_book_flutter/ui/widgets/appointment_list/appointment_widget.dart';
import 'package:client_book_flutter/utils/app_font.dart';
import 'package:client_book_flutter/utils/colors.dart';
import 'package:client_book_flutter/utils/s.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class AppointmentListWidget extends StatelessWidget {

  static const _topInfoPadding = 200.0;

  final bool isClientList;

  const AppointmentListWidget({super.key, this.isClientList = false});

  @override
  Widget build(BuildContext context) {
    final AppointmentListBloc bloc = isClientList
    ? BlocProvider.of<SpecialClientAppointmentListBloc>(context)
    : BlocProvider.of<MainAppointmentListBloc>(context);
    
    return BlocBuilder(
      bloc: bloc,
      builder: (context, state) {
        if (kDebugMode) Logger().i("Rebuilding list with $state");

        if (state is! ListAppointmentListBlocState) {
          return ListView(padding: const EdgeInsets.only(top: _topInfoPadding), children: const [
            Center(child: AppProgressWidget(strokeWidth: 5, size: 40))
          ]);
        }

        if (state.list.isEmpty) {
          return ListView(padding: const EdgeInsets.only(top: 200), children: [
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
              bloc.add(OldestScrolledAppointmentListBlocEvent(
                lastAppointmentTime: item.data.appointment.startTime)
              );
            } else if (index == state.list.length - 1) {
              bloc.add(NewestScrolledAppointmentListBlocEvent(
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