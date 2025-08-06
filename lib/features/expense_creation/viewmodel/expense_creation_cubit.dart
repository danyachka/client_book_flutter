

import 'package:client_book_flutter/core/model/app_database.dart';
import 'package:client_book_flutter/core/model/daos/expenses_dao.dart';
import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ExpenseCreationState {}
class DoneExpenseCreationState extends ExpenseCreationState {
  final Expense expense;
  DoneExpenseCreationState({required this.expense});
}

class LoadingExpenseCreationState extends ExpenseCreationState {}
class CreationExpenseCreationState extends ExpenseCreationState {
  final bool hasCheckedName;
  final bool hasCheckedValue;
  final bool hasUnknownError;
  CreationExpenseCreationState({this.hasCheckedName = true, this.hasCheckedValue = true, this.hasUnknownError = false});
}

class ExpenseCreationCubit extends Cubit<ExpenseCreationState> {

  final ExpensesDao _dao = ExpensesDao(AppDatabase());

  final int? editExpenseId;
  ExpenseCreationCubit({this.editExpenseId}) : super(LoadingExpenseCreationState());

  void onCreateClicked(String name, double? value, DateTime time) async {
    final checkedName = name.isNotEmpty;
    final checkedValue = value != null && value >= 0;

    if (!checkedName || !checkedValue) {
      emit(CreationExpenseCreationState(hasCheckedName: checkedName, hasCheckedValue: checkedValue));
      return;
    }

    try {
      Expense expense;
      if (editExpenseId != null) {
        expense = await _update(name, value, time.millisecondsSinceEpoch);
      } else {
        expense = await __insert(name, value, time.millisecondsSinceEpoch);
      }

      emit(DoneExpenseCreationState(expense: expense));
    } catch(e) {
      emit(CreationExpenseCreationState(hasUnknownError: true));
    }
  }

  Future<Expense> _update(String name, double value, int time) async {
    final expense = Expense(
      id: editExpenseId!, 
      name: name, 
      value: value, 
      time: time
    );

    await _dao.updateExpense(expense);

    return expense;
  }

  Future<Expense> __insert(String name, double value, int time) async {
    final expense = ExpensesCompanion.insert(
      name: Value(name), 
      value: Value(value), 
      time: time
    );

    final id = await _dao.insertExpense(expense);

    return Expense(
      id: id, 
      name: name, 
      value: value, 
      time: time
    );
  }

}