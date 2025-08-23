// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get day => 'Day';

  @override
  String get appTitle => 'Zest';

  @override
  String get welcome => 'Welcome to Zest';

  @override
  String get home_today_activity => 'Today Activities';

  @override
  String get home_calories => 'Calories';

  @override
  String get home_remind => 'Remind';

  @override
  String get home_calorie_burned => 'Calories Burned';

  @override
  String get home_show_previous_week => 'Show Previous Week';
}
