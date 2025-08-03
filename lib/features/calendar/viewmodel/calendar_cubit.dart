

import 'package:client_book_flutter/features/calendar/viewmodel/calendar_state.dart';
import 'package:client_book_flutter/core/utils/time_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class CalendarCubit extends Cubit<CalendarState> {

  final DateTime selectedDay;
  
  CalendarCubit(this.selectedDay)
  : super(CalendarState.generate(
    intYear: DateTime.now().year, 
    intMonth: DateTime.now().month, 
    selectedDay: selectedDay
  ));

  void goToNextMonth() async {
    if (kDebugMode) Logger().i("goToNextMonth called");
    final nextMonth = state.month.getNextMonthStart();

    final nextState = CalendarState.generate(
      intYear: nextMonth.year, 
      intMonth: nextMonth.month,
      selectedDay: selectedDay
    );

    emit(nextState);
  }

  void goToPreviousMonth() async {
    if (kDebugMode) Logger().i("goToPreviousMonth called");
    final nextMonth = state.month.getPreviousMonthStart();

    final nextState = CalendarState.generate(
      intYear: nextMonth.year, 
      intMonth: nextMonth.month,
      selectedDay: selectedDay
    );

    emit(nextState);
  }

}