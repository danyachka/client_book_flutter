

import 'package:client_book_flutter/utils/time_utils.dart';

class CalendarState {

  final DateTime mouth;

  final DateTime selectedDay;

  late final List<CalendarItem> list;

  CalendarState.generate({
    required int intYear, 
    required int intMonth, 
    required this.selectedDay
  }) : mouth = DateTime(intYear, intMonth, 1) {
    int fistDayInMonthWeekDay = mouth.weekday;

    final firstInList = mouth.subtract(Duration(days: fistDayInMonthWeekDay - 1));

    final lastMonthDay = mouth.getNextMonthStart().subtract(const Duration(days: 1));
    final lastDayInMonthWeekDay = lastMonthDay.weekday;

    final lastInList = lastMonthDay.add(Duration(days: 7 - lastDayInMonthWeekDay));

    int currentMonthInt = mouth.month;
    list = [CalendarItem(
      date: firstInList, 
      intMonth: currentMonthInt,
      selectedDay: selectedDay
    )];
    while (true) {
      final newDate = list.last.date.add(const Duration(days: 1));

      if (newDate.isAfter(lastInList)) break;

      list.add(CalendarItem(
        date: newDate, 
        intMonth: intMonth,
        selectedDay: selectedDay
      ));
    }
  }
}

class CalendarItem {
  final DateTime date;

  final bool sameMonth;

  final bool isSelectedDay;

  CalendarItem({
    required this.date,
    required int intMonth,
    DateTime? selectedDay
  }): sameMonth = date.month == intMonth, 
    isSelectedDay = (selectedDay == null)? false: selectedDay.isSameDay(date);
}