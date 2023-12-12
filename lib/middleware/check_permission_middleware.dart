import 'dart:convert';

// ignore: implementation_imports
import 'package:flutter/src/widgets/navigator.dart';
import 'package:flutter_almajhoud/functions.dart';
import 'package:get/get.dart';

class CheckPermissionMiddleware extends GetMiddleware {
  final String permission;
  CheckPermissionMiddleware(this.permission);
  @override
  RouteSettings? redirect(String? route) {
    
  }
}
