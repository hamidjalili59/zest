import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zest/src/application.dart';

bool loggedIn = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final pref = await SharedPreferences.getInstance();
  loggedIn = pref.getBool('loggedIn') ?? false;
  runApp(const Application());
}
