import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

const String mainUrl = 'http://100.123.195.132/almajhoud/public/api/v1';
SharedPreferences? sharedPreferences;
dynamic userInfo = sharedPreferences!.getString('user');
Map? sessionUser;
TextStyle? labelStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
);
