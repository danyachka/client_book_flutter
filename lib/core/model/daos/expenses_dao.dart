

import 'package:client_book_flutter/core/model/app_database.dart';
import 'package:client_book_flutter/core/model/models/expense/expenses.dart';
import 'package:drift/drift.dart';

part 'expenses_dao.g.dart'; // Generated code

@DriftAccessor(tables: [Expenses])
class ExpensesDao extends DatabaseAccessor<AppDatabase> with _$ExpensesDaoMixin {
  ExpensesDao(super.attachedDatabase);

  Future<int> insertExpense(ExpensesCompanion expense) async {
    return await into(expenses).insert(expense);
  }

  // Update method
  Future<void> updateExpense(Expense expense) async {
    await update(expenses).replace(expense);
  }

  // Delete method
  Future<void> deleteExpense(Expense expense) async {
    await delete(expenses).delete(expense);
  }

  Future<List<Expense>> getBetween(int startTime, int endTime) async {
    final query = (select(expenses)
      ..where((t) =>
          t.time.isSmallerThanValue(endTime) & t.time.isBiggerThanValue(startTime))
    );

    final result = await query.get();

    return result;
  }

}