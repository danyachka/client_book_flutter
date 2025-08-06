

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const primary = Color.fromARGB(255, 172, 116, 218);
  static const primaryTrans = Color.fromARGB(170, 172, 116, 218);

  static const primaryDarker = Color.fromARGB(255, 151, 108, 187);
  static const primaryDarkerLowTrans = Color.fromARGB(240, 151, 108, 187);
  static const primaryDark = Color.fromARGB(255, 150, 107, 185);
  static const primaryDarkTrans = Color.fromARGB(120, 164, 116, 204);

  static const primaryLighter = Color.fromARGB(255, 215, 172, 255);
  static const primaryLight = Color.fromARGB(255, 238, 224, 252);
  static const primaryLightTrans = Color.fromARGB(170, 238, 224, 252);

  static const cardBackground = primaryLight;
  static const overlayBackground = primaryLight;


  static const accentText = primary;
  static const accentTextLight = primary;
  static const accentTextLighter = primaryLighter;
  static const accentTextDarker = primaryDarker;
  static const editTextHint = accentTextLighter;

  static const white = Colors.white;
  static const red = Colors.red;
  static const orange = Color.fromARGB(255, 244, 216, 54);

  static const darkBackground = Color.fromARGB(255, 252, 252, 252);
  static const darkLighter = Color.fromARGB(255, 250, 250, 250);
  
  static const darkTrans = Color.fromARGB(221, 42, 42, 42);
  static const grayTrans = Color.fromARGB(113, 105, 105, 105);
  static const grayLightTrans = Color.fromARGB(200, 255, 255, 255);

  static const gray = Color(0xFF868686);
  static const grayLight = Color.fromARGB(255, 200, 200, 200);
  static const mediumDarkerGray = Color(0xFF343434);
  static const mediumDarkerGrayTrans = Color.fromARGB(230, 52, 52, 52);
  static const grayDarker = Color(0xFF2E2E2E);
  static const darkGray = Color(0xFF1E1E1E);
}