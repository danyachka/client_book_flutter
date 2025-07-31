import 'package:client_book_flutter/core/model/app_database.dart';
import 'package:client_book_flutter/core/model/entities_extensions/client_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('phone format', () {
    test('short phone number text', () {
      String original = '123456789';
      String expected = '123456789';

      expect(_createClient(original).getFormattedPhoneNumber(), expected);
    });

    test('len = 10', () {
      String original = '1234567890';
      String expected = '(123) 456-78-90';

      expect(_createClient(original).getFormattedPhoneNumber(), expected);
    });

    test('len = 11', () {
      String original = '11234567890';
      String expected = '1 (123) 456-78-90';

      expect(_createClient(original).getFormattedPhoneNumber(), expected);
    });

    test('long phone number text', () {
      String original = '111234567890';
      String expected = '11 (123) 456-78-90';

      expect(_createClient(original).getFormattedPhoneNumber(), expected);
    });
  });

}

Client _createClient(String phone) => Client(id: 0, name: '', phoneNumber: phone, picturePath: '');