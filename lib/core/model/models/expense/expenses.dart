
import 'package:drift/drift.dart';

class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withDefault(const Constant(''))();
  RealColumn get value => real().withDefault(const Constant(0))();
  IntColumn get time => integer()();
}