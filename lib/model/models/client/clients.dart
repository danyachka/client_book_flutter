
import 'package:drift/drift.dart';

class Clients extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get phoneNumber => text().withDefault(const Constant(''))();
  TextColumn get picturePath => text().withDefault(const Constant(''))();
}
