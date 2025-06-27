enum UserRole { admin, assistant, teacher, parent }

extension UserRoleExtension on UserRole {
  String get name {
    switch (this) {
      case UserRole.admin:
        return 'admin';
      case UserRole.assistant:
        return 'assistant';
      case UserRole.teacher:
        return 'teacher';
      case UserRole.parent:
        return 'parent';
    }
  }

  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.assistant:
        return 'Assistant';
      case UserRole.teacher:
        return 'Teacher';
      case UserRole.parent:
        return 'Parent';
    }
  }
}

enum AttendanceStatus { present, absentExcused, absentUnexcused }

extension AttendanceStatusExtension on AttendanceStatus {
  String get name {
    switch (this) {
      case AttendanceStatus.present:
        return 'present';
      case AttendanceStatus.absentExcused:
        return 'excused';
      case AttendanceStatus.absentUnexcused:
        return 'unexcused';
    }
  }

  String get displayName {
    switch (this) {
      case AttendanceStatus.present:
        return 'Present';
      case AttendanceStatus.absentExcused:
        return 'Excused';
      case AttendanceStatus.absentUnexcused:
        return 'Unexcused';
    }
  }
}

enum Gender { male, female, other }

extension GenderExtension on Gender {
  String get name {
    switch (this) {
      case Gender.male:
        return 'male';
      case Gender.female:
        return 'female';
      case Gender.other:
        return 'other';
    }
  }

  String get displayName {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.other:
        return 'Other';
    }
  }
}

class AppSizes {
  static const double homeBannerRatio = 3;
  static const double homeQuickAccessBoxRatio = 3.5;
  static const double homeStudentTileRatio = .9;
  static const double homeChartTileRatio = 1.3;

  /// Radius
  /// Pages Radius
  static const double pagesMiniRadius = 8;
  static const double pagesLowRadius = 12;
  static const double pagesNormalRadius = 16;
  static const double pagesMediumRadius = 24;
  static const double pagesCircleRadius = 100;

  /// Paddings
  /// Pages Paddings
  static const double pagesSmallPadding = 4;
  static const double pagesLowPadding = 8;
  static const double pagesNormalPadding = 16;
  static const double pagesMediumPadding = 24;

  /// Global Paddings
  static const double normalPadding = 16;
}

class AppConstants {
  static const String appName = 'Maktabi Sho';
  static const String appVersion = '1.0.0';

  // Shared Preferences Keys
  static const String prefKeyUser = 'user';
  static const String prefKeyToken = 'token';
  static const String prefKeyLanguage = 'language';
  static const String prefKeyTheme = 'theme';
  static const String prefKeyFirstRun = 'firstRun';

  // Database Settings
  static const String dbName = 'maktabi_sho.db';
  static const int dbVersion = 1;
  static const String baseUrl = 'https://google.com/';

  // Date Formats
  static const String dateFormatDisplay = 'yyyy-MM-dd';
  static const String dateTimeFormatDisplay = 'yyyy-MM-dd HH:mm';
  static const String timeFormatDisplay = 'HH:mm';
}
