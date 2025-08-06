

import 'package:client_book_flutter/core/utils/app_font.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:client_book_flutter/core/utils/s.dart';
import 'package:client_book_flutter/core/widgets/app_clickable/clickable.dart';
import 'package:client_book_flutter/core/widgets/app_progress/app_progress.dart';
import 'package:client_book_flutter/features/expense_creation/view/expense_creation_page.dart';
import 'package:client_book_flutter/features/expense_list/view/expense_item.dart';
import 'package:client_book_flutter/features/expense_list/view/expense_stats_widget.dart';
import 'package:client_book_flutter/features/expense_list/viewmodel/expense_list_cubit.dart';
import 'package:client_book_flutter/features/main/fragments/list_fragment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseListView extends StatefulWidget {
  const ExpenseListView({super.key});

  @override
  State<ExpenseListView> createState() => _ExpenseListViewState();
}

class _ExpenseListViewState extends State<ExpenseListView> {

  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(children: [
          Expanded(child: Text(
              S.of(context).stats_title,
              style: const TextStyle(
                fontSize: 20,
                fontFamily: AppFont.m,
                fontWeight: FontWeight.bold,
                color: AppColors.accentText
              )
          )),

           Clickable(
              onClick: () {
                final bloc = context.read<ExpenseListCubit>();

                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ExpenseCreationPage(
                    callback: (expense) => bloc.onListUpdate(),
                  )
                ));
              },
              radius: 32,
              child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(Icons.add_rounded,
                      color: AppColors.primary, size: 26)))
        ]),
      ),
      const SizedBox(height: 12),

      Expanded(child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(listCordersRadius), 
          topRight: Radius.circular(listCordersRadius)
        ),
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            const SliverToBoxAdapter(child: AnimatedSize(
              duration: Duration(milliseconds: 200),
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: ExpenseStatsWidget(),
              )
            )),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
        
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(children: [
                    Expanded(child: Text(
                        S.of(context).expenses_title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: AppFont.m,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accentText
                        )
                      ))
                  ]),
              )
            ),
        
            BlocBuilder<ExpenseListCubit, ExpenseListState>(
              builder: (context, state) {
                if (state is LoadingExpenseListState) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Center(child: AppProgressWidget()),
                    )
                  );
                } 
                final readyState = state as ReadyExpenseListState;
            
                if (readyState.expenses.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Center(child: Text(
                          S.of(context).nothing_yet,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: AppFont.m,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accentText
                          )
                        )
                      ),
                    )
                  );
                }
            
                return SliverList.builder(
                  itemCount: readyState.expenses.length,
                  itemBuilder: (context, index) {
                    final expense = readyState.expenses[index];
            
                    return ExpenseItem(expense: expense); 
                  }
                );
              }
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 80))
          ],
        ),
      ))
    ]);
  }
}