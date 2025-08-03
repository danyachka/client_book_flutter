
import 'package:client_book_flutter/features/expense_list/model/expense_list_model.dart';
import 'package:client_book_flutter/features/expense_list/view/expense_list_view.dart';
import 'package:client_book_flutter/features/expense_list/viewmodel/expense_list_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatsFragment extends StatelessWidget {
  const StatsFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (context) => ExpenseListCubit(model: ExpenseListModel(), startDate: DateTime.now()),
        child: const ExpenseListView(),
      ),
    );
  }
}