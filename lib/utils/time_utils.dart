

import 'package:client_book_flutter/utils/s.dart';
import 'package:flutter/material.dart';

extension AppDateTime on DateTime {

  bool isSameDay(DateTime other) {
    if (year != other.year) return false;
    if (month != other.month) return false;
    if (day != other.day) return false;

    return true;
  }

  DateTime getNextMonthStart() {
    if (month == 12) {
      return DateTime(year + 1, 1);
    }

    return DateTime(year, month + 1);
  }

  DateTime getPreviousMonthStart() {
    if (month == 1) {
      return DateTime(year - 1, 12);
    }

    return DateTime(year, month - 1);
  }

  String getMonthName(BuildContext context) {
    switch (month) {
      case 1:
        return S.of(context).january;
      case 2:
        return S.of(context).february;
      case 3:
        return S.of(context).march;
      case 4:
        return S.of(context).april;
      case 5:
        return S.of(context).may;
      case 6:
        return S.of(context).june;
      case 7:
        return S.of(context).july;
      case 8:
        return S.of(context).august;
      case 9:
        return S.of(context).september;
      case 10:
        return S.of(context).october;
      case 11:
        return S.of(context).november;
      case 12:
        return S.of(context).december;
      default:
        return ''; // Return an empty string or handle invalid input as needed
    }
  }

  String getDayName(BuildContext context) => getDayNameByNumber(context, weekday);

  String getDayShortName(BuildContext context) => getDayShortNameByNumber(context, weekday);

  Duration getTodayTimeInDuration() {
    return Duration(hours: hour, minutes: minute, seconds: second);
  }
}


extension AppDuration on Duration {
  String getFormattedTime() {
    return "$inHours:$inMinutes";
  }
}

String getDayNameByNumber(BuildContext context, int weekday) {
  switch (weekday) {
    case 1:
      return S.of(context).monday;
    case 2:
      return S.of(context).tuesday;
    case 3:
      return S.of(context).wednesday;
    case 4:
      return S.of(context).thursday;
    case 5:
      return S.of(context).friday;
    case 6:
      return S.of(context).saturday;
    case 7:
      return S.of(context).sunday;
    default:
      return ''; // Return an empty string or handle invalid input as needed
  }
}

String getDayShortNameByNumber(BuildContext context, int weekday) {
  switch (weekday) {
    case 1:
      return S.of(context).monday_short;
    case 2:
      return S.of(context).tuesday_short;
    case 3:
      return S.of(context).wednesday_short;
    case 4:
      return S.of(context).thursday_short;
    case 5:
      return S.of(context).friday_short;
    case 6:
      return S.of(context).saturday_short;
    case 7:
      return S.of(context).sunday_short;
    default:
      return ''; // Return an empty string or handle invalid input as needed
  }
}
