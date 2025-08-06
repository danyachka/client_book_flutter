

import 'package:client_book_flutter/core/model/app_database.dart';
import 'package:client_book_flutter/core/model/daos/appointment_dao.dart';
import 'package:client_book_flutter/core/model/daos/expenses_dao.dart';

class ExpenseListModel {

  final _dao = ExpensesDao(AppDatabase());
  final appointmentsDao = AppointmentDao(AppDatabase());

  Future<List<Expense>> getExpensesBetween(int from, int to) 
    => _dao.getBetween(from, to); 

  Future<List<Appointment>> getAppointmentsBetween(int from, int to) 
    => appointmentsDao.getAppointmentsBetween(from, to); 

  Future<void> removeExpense(Expense expense) => _dao.deleteExpense(expense);

}