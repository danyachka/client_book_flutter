
import 'package:client_book_flutter/features/appointment_list/viewmodel/appointment_list_bloc.dart';
import 'package:client_book_flutter/features/appointment_list/viewmodel/states/appointment_list_bloc_states.dart';
import 'package:client_book_flutter/features/main/fragments/calendar_fragment.dart';
import 'package:client_book_flutter/features/main/fragments/list_fragment.dart';
import 'package:client_book_flutter/features/main/fragments/stats_fragment.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatefulWidget {
  static const double mainPageNavigationBarHeight = 60;
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  late final PageController pageController;

  late final MainAppointmentListBloc mainAppointmentListBlock;

  final currentFragment = ValueNotifier(MainPageFragment.list);

  @override
  void initState() {
    pageController = PageController(initialPage: currentFragment.value.pageIndex);
    pageController.addListener(() {
      final page = (pageController.page?? 0).round();
      if (page == currentFragment.value.pageIndex) return;

      currentFragment.value = MainPageFragment.values[page];
    });

    mainAppointmentListBlock = MainAppointmentListBloc(scrollToIndexInList);

    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();

    mainAppointmentListBlock.close();

    super.dispose();
  }

  void scrollToPage(MainPageFragment fragment) {
    pageController.animateToPage(
      fragment.pageIndex, 
      duration: const Duration(milliseconds: 200), 
      curve: Curves.decelerate
    );
  }
  
  void scrollToIndexInList(int index) {
    final state = mainAppointmentListBlock.state;
    
    if (state is! ListAppointmentListBlocState) return;

    final context = state.list[index].key?.currentContext;

    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      extendBody: true,
      body: BlocProvider.value(
        value: mainAppointmentListBlock,
        child: PageView(
          controller: pageController,
          children: [
            CalendarFragment(changeFragmentCallBack: scrollToPage),

            const ListFragment(),

            const StatsFragment()
          ]
        )
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        child: ValueListenableBuilder(
          valueListenable: currentFragment, 
          builder:(context, value, child) => NavigationBar(
            height: MainPage.mainPageNavigationBarHeight,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            indicatorColor: Colors.transparent,
            animationDuration: const Duration(milliseconds: 0),
            backgroundColor: AppColors.darkLighter,
            onDestinationSelected: (int index) {
              if (index == currentFragment.value.pageIndex) return;

              final newFragment = MainPageFragment.values[index];
              currentFragment.value = newFragment;
              scrollToPage(newFragment);
            },
            selectedIndex: currentFragment.value.pageIndex,
            destinations: const <Widget>[
              _NavigationDestination(
                  Icon(Icons.calendar_month_rounded, size: 30)),
              _NavigationDestination(
                  Icon(Icons.list_rounded, size: 30)),
              _NavigationDestination(
                  Icon(Icons.scatter_plot_rounded, size: 30))
            ],
          ),
        )
      )
    );
  }
}

class _NavigationDestination extends StatelessWidget {

  final Widget icon;

  const _NavigationDestination(this.icon);

  @override
  Widget build(BuildContext context) {
    return NavigationDestination(
      icon: ColorFiltered(
        colorFilter: const ColorFilter.mode(
          AppColors.grayLight,
          BlendMode.srcIn,
        ),
        child: icon,
      ),
      selectedIcon: ColorFiltered(
        colorFilter: const ColorFilter.mode(
          AppColors.white,
          BlendMode.srcIn,
        ),
        child: icon,
      ),
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
