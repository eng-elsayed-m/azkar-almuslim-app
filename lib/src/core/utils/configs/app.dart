import 'package:azkar/src/core/utils/configs/app_theme.dart';
import 'package:azkar/src/core/utils/configs/configs.dart';
import 'package:flutter/material.dart';

class App {
  static bool? isLtr;
  static bool showAds = false;

  static init(BuildContext context) {
    UI.init(context);
    AppDimensions.init();
    AppTheme.init(context);
    UIProps.init();
    Space.init();
    AppText.init();
    isLtr = Directionality.of(context) == TextDirection.ltr;
  }
}