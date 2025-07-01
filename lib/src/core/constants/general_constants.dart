import 'package:flutter/material.dart';

class GeneralConstants {
  GeneralConstants._();

  // Spacing & Padding
  static const double kSmallSpacing = 4.0;
  static const double kMediumSpacing = 8.0;
  static const double kLargePadding = 16.0;

  // BorderRadius
  static const double kDefaultBorderRadius = 12.0;
  static const double kDesktopBorderRadius = 14.0;

  // Colors
  static const Color kPrimaryDarkColor = Color(0xff242424);
  static const Color kLightBorderColor = Color(0xFFE0E0E0);
  static const Color kSubtleTextColor = Color(0xFF9E9E9E);
  static const Color kPrimaryTextColorLight = Color(0xffF9FCFF);
  static const Color kSecondaryTextColorLight = Colors.white60;
  static const Color kPrimaryTextColorDark = Colors.black;

  // Text & FontWeights
  static const FontWeight kSemiBoldFontWeight = FontWeight.w600;

  // App Info
  static const String kAppTitle = 'Zest';
  static const String kAppVersion = '1.0.0';

  // Durations
  static const Duration kDefaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration kShortAnimationDuration = Duration(milliseconds: 150);

  // API
  static const String kApiBaseUrl = 'https://zest.com/v1/';
  static const Duration kApiTimeoutDuration = Duration(seconds: 30);

  // DB
  static const String dbName = 'zest.db';
  static const int dbVersion = 1;

  // Date Formats
  static const String dateFormatDisplay = 'yyyy-MM-dd';
  static const String dateTimeFormatDisplay = 'yyyy-MM-dd HH:mm';
  static const String timeFormatDisplay = 'HH:mm';
}
