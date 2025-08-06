

import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:flutter/services.dart';

SystemUiOverlayStyle getAppSystemOverlayStyle() => const SystemUiOverlayStyle(
  statusBarColor: AppColors.primaryDarkerLowTrans,
  statusBarBrightness: Brightness.dark
);