
import 'package:client_book_flutter/features/appointment_list/viewmodel/appointment_list_bloc.dart';
import 'package:client_book_flutter/features/appointment_list/viewmodel/states/appointment_list_bloc_states.dart';
import 'package:client_book_flutter/features/main/fragments/calendar_fragment.dart';
import 'package:client_book_flutter/features/main/fragments/list_fragment.dart';
import 'package:client_book_flutter/features/main/fragments/stats_fragment.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_list_view/flutter_list_view.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/web.dart';

class MainPage extends StatefulWidget {
  static const double mainPageNavigationBarHeight = 60;
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  late final PageController pageController;
  late final FlutterListViewController scrollController;

  final currentFragment = ValueNotifier(MainPageFragment.list);

  @override
  void initState() {
    pageController = PageController(initialPage: currentFragment.value.pageIndex);
    pageController.addListener(() {
      final page = (pageController.page?? 0).round();
      if (page == currentFragment.value.pageIndex) return;

      currentFragment.value = MainPageFragment.values[page];
    });

    scrollController = FlutterListViewController();

    final mainAppointmentListBlock = MainAppointmentListBloc(scrollToIndexInList);
    GetIt.I.registerSingleton(mainAppointmentListBlock);

    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();

    GetIt.I<MainAppointmentListBloc>().close();
    GetIt.I.reset();

    super.dispose();
  }

  Future<void> scrollToPage(MainPageFragment fragment) {
    return pageController.animateToPage(
      fragment.pageIndex, 
      duration: const Duration(milliseconds: 200), 
      curve: Curves.decelerate
    );
  }
  
  void scrollToIndexInList(int index, bool animate) async {
    final state = GetIt.I<MainAppointmentListBloc>().state;
    
    if (state is! ListAppointmentListBlocState) return;

    if (kDebugMode) {
      Logger().d("Scrolling to index $index");
    }

    await scrollToPage(MainPageFragment.list);
    if (animate) {
      scrollController.sliverController
        .animateToIndex(index, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    } else {
      scrollController.sliverController.jumpToIndex(index);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.darkBackground,
        extendBody: true,
        body: SafeArea(
          bottom: false,
          child: PageView(controller: pageController, children: [
            CalendarFragment(changeFragmentCallBack: scrollToPage),
            ListFragment(scrollController: scrollController),
            const StatsFragment()
          ]),
        ),
        bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            child: ValueListenableBuilder(
              valueListenable: currentFragment,
              builder: (context, value, child) => NavigationBar(
                height: MainPage.mainPageNavigationBarHeight,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
                indicatorColor: AppColors.primary,
                backgroundColor: AppColors.primaryDarkerLowTrans,
                shadowColor: Colors.transparent,
                animationDuration: const Duration(),
                // surfaceTintColor: AppColors.primary,к
                selectedIndex: currentFragment.value.pageIndex,
                onDestinationSelected: (int index) {
                  if (index == currentFragment.value.pageIndex) return;
    
                  final newFragment = MainPageFragment.values[index];
                  currentFragment.value = newFragment;
                  scrollToPage(newFragment);
                },
                destinations: const <Widget>[
                  _NavigationDestination(Icons.calendar_month_rounded),
                  _NavigationDestination(Icons.list_rounded),
                  _NavigationDestination(Icons.scatter_plot_rounded)
                ],
              ),
            ))
    );
  }
}

class _NavigationDestination extends StatelessWidget {

  final IconData icon;

  const _NavigationDestination(this.icon);

  @override
  Widget build(BuildContext context) {
    return NavigationDestination(
      icon: Icon(icon, color: AppColors.darkBackground, size: 30),
      selectedIcon: Icon(icon, color: AppColors.grayLight, size: 30),
      label: "",
    );
  }
}

typedef ChangeFragmentCallback = void Function(MainPageFragment);

enum MainPageFragment {
  calendar(0),

  list(1),

  stats(2);

  final int pageIndex;

  const MainPageFragment(this.pageIndex);
}
