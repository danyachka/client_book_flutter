
import 'package:client_book_flutter/core/model/app_database.dart';
import 'package:client_book_flutter/core/utils/time_utils.dart';
import 'package:client_book_flutter/features/expense_list/model/expense_list_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

abstract class ExpenseListState {
  final DateTime startMonthTime;

  ExpenseListState({required this.startMonthTime});
}

class LoadingExpenseListState extends ExpenseListState {
  LoadingExpenseListState({required super.startMonthTime});
}

class ReadyExpenseListState extends ExpenseListState {
  final List<Expense> expenses;
  
  final double totalExpenses;
  final double pastValue;
  final double futureValue;

  ReadyExpenseListState({
    required this.expenses, 
    required this.totalExpenses, 
    required this.pastValue, 
    required this.futureValue, 
    required super.startMonthTime
  });
}

class ExpenseListCubit extends Cubit<ExpenseListState> {

  final ExpenseListModel model;

  ExpenseListCubit({required this.model, required DateTime startDate}) : super(LoadingExpenseListState(startMonthTime: startDate)) {
    goToNewMonth(startDate, setLoading: false);
  }

  void goToNewMonth(DateTime newDate, {bool setLoading=true}) async {
    if (setLoading) emit(LoadingExpenseListState(startMonthTime: newDate));
    final start = newDate.getMonthStart();

    final from = start.millisecondsSinceEpoch;
    final to = start.getNextMonthStart().millisecondsSinceEpoch;

    final expenses = await model.getExpensesBetween(from, to);
    final appointments = await model.getAppointmentsBetween(from, to);

    int currentTime = DateTime.now().millisecondsSinceEpoch;
    double pastValue = 0;
    double futureValue = 0;
    for (final expense in appointments) {
      if (expense.startTime < currentTime) {
        pastValue += expense.value;
      } else {
        futureValue += expense.value;
      }
    }

    double totalExpenses = 0;
    for (final expense in expenses) {
      totalExpenses += expense.value;
    }

    Logger().i("Emitting new ReadyExpenseListState state");

    emit(ReadyExpenseListState(
      startMonthTime: start,
      expenses: expenses,
      pastValue: pastValue,
      futureValue: futureValue,
      totalExpenses: totalExpenses
    ));
  }

  void onListUpdate() async {
    goToNewMonth(state.startMonthTime);
  }

  void onExpenseRemove(Expense expense) async {
    await model.removeExpense(expense);

    onListUpdate();
  }
  
}