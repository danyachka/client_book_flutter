
import 'package:client_book_flutter/core/utils/app_font.dart';
import 'package:client_book_flutter/core/widgets/app_system_overlay/app_system_overlay.dart';
import 'package:client_book_flutter/features/main/page/main_page.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:client_book_flutter/core/utils/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: AppColors.accentTextDarker,
        systemNavigationBarColor: AppColors.accentTextDarker,
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: S.supportedLocales,
      localizationsDelegates: S.localizationDelegates,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        primaryColorDark: AppColors.primaryDarker,
        scaffoldBackgroundColor: AppColors.darkBackground,
        focusColor: AppColors.primary,
        highlightColor: AppColors.primary,
        splashColor: AppColors.primary,
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
          systemOverlayStyle: getAppSystemOverlayStyle()
        ),
        timePickerTheme: TimePickerThemeData(
          backgroundColor: AppColors.darkBackground,
          hourMinuteTextColor: AppColors.primary,
          dayPeriodTextColor: AppColors.primary,
          dialHandColor: AppColors.primary,
          dialBackgroundColor: AppColors.primary.withAlpha(25),
          hourMinuteColor: AppColors.primary.withAlpha(25),
          dayPeriodColor: AppColors.primary.withAlpha(25),
          entryModeIconColor: AppColors.primary,
          dayPeriodTextStyle: const TextStyle(color: AppColors.accentTextDarker, fontSize: 24, fontWeight: FontWeight.w600, fontFamily: AppFont.m),
          helpTextStyle: const TextStyle(color: AppColors.accentTextDarker, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: AppFont.m),
          dialTextStyle: const TextStyle(color: AppColors.accentTextDarker, fontSize: 14, fontWeight: FontWeight.w600, fontFamily: AppFont.m),
          dialTextColor: AppColors.accentTextDarker,
          hourMinuteTextStyle: const TextStyle(color: AppColors.accentTextDarker, fontSize: 24, fontWeight: FontWeight.w600, fontFamily: AppFont.m),
          confirmButtonStyle: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(AppColors.accentText), // Text color
            textStyle:  WidgetStateProperty.all(
              const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: AppFont.m),
            )
          ),
          cancelButtonStyle: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(AppColors.accentText), // Text color
            textStyle:  WidgetStateProperty.all(
              const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: AppFont.m),
            )
          )
        ),
        
      ),
      themeMode: ThemeMode.dark,
      home: const MainPage()
    );
  }
}
