import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF051A4E);
  static const Color accentColor = Color(0xFFF9AA33);
  static const Color backgroundColor = Color(0xFFF9F9F9);
  static const Color cardColor = Colors.white;
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF388E3C);
  static const Color warningColor = Color(0xFFF57C00);
  static const Color infoColor = Color(0xFF1976D2);

  static const Color textColorPrimary = Color(0xFF212121);
  static const Color textColorSecondary = Color(0xFF757575);
  static const Color textColorLight = Color(0xFFFFFFFF);

  static const double fontSizeSmall = 12.0;
  static const double fontSizeRegular = 14.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 18.0;
  static const double fontSizeExtraLarge = 22.0;
}

extension OpacityToAlpha on double {
  int toAlpha() => (this * 255).toInt();
}
