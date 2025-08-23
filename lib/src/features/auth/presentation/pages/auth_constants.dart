import 'package:flutter/material.dart';

abstract class AuthConstants {
  // Brand Colors
  static const Color backgroundColor = Color(0xFF0F1216);
  static const Color glassCardColor = Colors.white10;
  static const Color primaryTextColor = Colors.white;
  static const Color secondaryTextColor = Color(0xFF93A2B2);
  static const Color dividerColor = Colors.white24;
  static const Color socialIconColor = Colors.white54;
  static const Color buttonTextColor = Colors.black;

  // Gradients
  static const List<Color> gradientColors = [
    Color(0xFF22D3EE),
    Color(0xFF22C55E),
  ];
  static const Color gradientButtonShadowColor = Color(0x8022C55E);

  // Dimensions
  static const double maxWidth = 1100.0;
  static const double cardMaxWidth = 460.0;
  static const double primaryPadding = 20.0;
  static const double buttonHeight = 54.0;
  static const double segmentedControlHeight = 44.0;
  static const double socialIconSize = 48.0;

  // Spacing
  static const double spaceSmall = 8.0;
  static const double spaceMedium = 12.0;
  static const double spaceLarge = 18.0;
  static const double spaceExtraLarge = 24.0;
  static const double spaceBrandHeader = 22.0;
  static const double spaceWideLayout = 24.0;
  static const double spaceSocialIcons = 10.0;

  // Border & Radius
  static const double cardBorderRadius = 24.0;
  static const double inputBorderRadius = 16.0;
  static const double segmentedControlBorderRadius = 14.0;
  static const Color inputBorderColor = Colors.white12;
  static const Color focusedInputBorderColor = Colors.white30;
  static const Color iconColor = Colors.white70;
  static const Color inputFillColor = Color.fromARGB(15, 255, 255, 255);

  // Blur & Shadow
  static const double glassBlur = 16.0;
  static const double blobBlur = 40.0;
  static const double cardBoxShadowBlur = 30.0;
  static const double cardBoxShadowSpread = -10.0;
  static const double gradientButtonBoxShadowBlur = 16.0;

  // Blob Dimensions
  static const double blobSize1 = 260.0;
  static const double blobSize2 = 320.0;
  static const double blobTopPosition = -120.0;
  static const double blobLeftPosition = -80.0;
  static const double blobBottomPosition = -140.0;
  static const double blobRightPosition = -100.0;

  // Animations
  static const Duration formSwitchDuration = Duration(milliseconds: 250);
  static const Duration segmentedControlDuration = Duration(milliseconds: 220);

  // Text Styles
  static const double titleFontSize = 34.0;
  static const double subtitleFontSize = 14.0;
  static const double buttonFontSize = 16.0;
  static const double policyFontSize = 12.0;
  static const FontWeight titleFontWeight = FontWeight.w800;
  static const FontWeight buttonFontWeight = FontWeight.w800;

  // Text Strings (English)
  static const String brandTitle = 'Zest';
  static const String brandSubtitle =
      'Manage your diet, calories, and daily activities';
  static const String heroPanelText =
      'Build healthy habits and track your progress with beautiful cards.';
  static const String loginTab = 'Login';
  static const String signupTab = 'Sign Up';
  static const String loginButtonText = 'Login to Zest';
  static const String signupButtonText = 'Create Account';
  static const String dividerText = 'OR';
  static const String policyText =
      'By signing in, you agree to our Terms of Service and Privacy Policy.';
  static const String forgotPasswordText = 'Forgot Password?';
  static const String googleLabel = 'Google';
  static const String appleLabel = 'Apple';

  // Validation & Hints (English)
  static const String emailHint = 'Email';
  static const String passwordHint = 'Password';
  static const String nameHint = 'Full Name';
  static const String confirmPasswordHint = 'Confirm Password';
  static const String emailValidation = 'Please enter your email';
  static const String passwordValidation =
      'Password must be at least 6 characters';
  static const String nameValidation = 'Please enter a valid name';
  static const String confirmPasswordValidation = 'Passwords do not match';
}
