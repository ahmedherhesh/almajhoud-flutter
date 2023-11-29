import 'dart:convert';
import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

const mainUrl = 'http://192.168.43.90/almajhoud/public/api/v1';
SharedPreferences? sharedPreferences;
dynamic userInfo = sharedPreferences!.getString('user');
Map sessionUser = userInfo!.isNotEmpty ? jsonDecode(userInfo) : {};
TextStyle? labelStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
);
