import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

const String mainUrl = 'http://192.168.1.8/almajhoud/public/api/v1';
SharedPreferences? sharedPreferences;
dynamic userInfo = sharedPreferences!.getString('user');
Map? sessionUser;
TextStyle? labelStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
);
