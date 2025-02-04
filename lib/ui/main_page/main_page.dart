
import 'package:client_book_flutter/blocks/appointment_list/appointment_list_block.dart';
import 'package:client_book_flutter/blocks/appointment_list/states/appointment_list_block_states.dart';
import 'package:client_book_flutter/ui/main_page/fragments/calendar_fragment.dart';
import 'package:client_book_flutter/ui/main_page/fragments/list_fragment.dart';
import 'package:client_book_flutter/ui/main_page/fragments/stats_fragment.dart';
import 'package:client_book_flutter/utils/colors.dart';
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

  late final ScrollController mainListScrollController;

  late final MainAppointmentListBlock mainAppointmentListBlock;

  final currentFragment = ValueNotifier(MainPageFragment.list);

  @override
  void initState() {
    pageController = PageController();
    pageController.jumpToPage(currentFragment.value.pageIndex);
    mainListScrollController = ScrollController();

    mainAppointmentListBlock = MainAppointmentListBlock(scrollToIndexInList);

    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    mainListScrollController.dispose();

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
    
    if (state is! ListAppointmentListBlockState) return;

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

            ListFragment(scrollController: mainListScrollController),

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
            onDestinationSelected: (int index) => currentFragment.value = MainPageFragment.values[index],
            selectedIndex: currentFragment.value.pageIndex,
            destinations: const <Widget>[
              _NavigationDestination(
                  Icon(Icons.calendar_month_rounded, size: 22)),
              _NavigationDestination(
                  Icon(Icons.list_rounded, size: 22)),
              _NavigationDestination(
                  Icon(Icons.scatter_plot_rounded, size: 22))
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
          AppColors.white,
          BlendMode.srcIn,
        ),
        child: icon,
      ),
      selectedIcon: ColorFiltered(
        colorFilter: const ColorFilter.mode(
          AppColors.grayLight,
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
