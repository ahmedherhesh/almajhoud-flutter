import 'dart:convert';

// ignore: implementation_imports
import 'package:flutter/src/widgets/navigator.dart';
import 'package:flutter_almajhoud/env.dart';
import 'package:flutter_almajhoud/functions.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    userInfo = sharedPreferences!.getString('user');
    if (sharedPreferences!.getString('user') != null) {
      sessionUser = userInfo!.isNotEmpty ? jsonDecode(userInfo) : {};
      if (sessionUser!['role'] == 'admin') {
        return const RouteSettings(name: 'units');
      }
      if (sessionUser!['unit'] == null) {
        return customDialog(
            title: 'عفوا انت لست رئيس لأي وحدة',
            middleText: 'برجاء الرجوع للأدمن في ذلك');
      }
      return RouteSettings(
        name: 'unit-violations',
        arguments: {
          'unit_id': sessionUser!['unit']['id'],
          'title': sessionUser!['unit']['title'],
        },
      );
    }
    return null;
  }
}
