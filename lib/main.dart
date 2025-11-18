import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zest/src/application.dart';

bool loggedIn = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(); // Loads .env from the project root
  final pref = await SharedPreferences.getInstance();
  loggedIn = pref.getBool('loggedIn') ?? false;
  runApp(const Application());
}
