

import 'package:client_book_flutter/core/model/app_database.dart';

extension ClientMethods on Client {
  String getFormattedPhoneNumber() {
    if (phoneNumber.length < 10) return phoneNumber;

    final prefixEnd = phoneNumber.length - 10;
    final part = phoneNumber.substring(prefixEnd);

    return "${prefixEnd == 0? '' : "${phoneNumber.substring(0, prefixEnd)} "}(${part.substring(0, 3)}) "  
      "${part.substring(3, 6)}-${part.substring(6, 8)}-${part.substring(8)}";
  }
}