import 'package:flutter/material.dart';
import 'package:zest/src/core/constants/general_constants.dart';

class HomeConstants {
  HomeConstants._();

  static const Size kDayCounterBoxSize = Size(48, 54);
  static const int kPastDaysCount = 3;
  static const int kFutureDaysCount = 25;
  static const double kTabletSizeMultiplier = 1.25;
  static const double kDesktopSizeMultiplier = 1.5;
  static const List<BoxShadow> kTodayBoxShadow = [
    BoxShadow(spreadRadius: 0.1, blurRadius: 3, color: Colors.black26),
  ];
  static const EdgeInsetsDirectional kDayCounterPadding =
      EdgeInsetsDirectional.only(
        start: GeneralConstants.kLargePadding,
        end: GeneralConstants.kMediumSpacing,
        top: GeneralConstants.kSmallSpacing,
        bottom: GeneralConstants.kSmallSpacing,
      );
}
