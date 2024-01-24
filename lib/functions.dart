import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_almajhoud/env.dart';
import 'package:get/get.dart';

Future checkPermission(permission) async {
  // var res = await API.get(path: 'user', showDialog: false);
  // if (res.containsKey('data') && res['data'].containsKey('permissions')) {
  //   if (!res['data']['permissions'].contains(permission)) {
  //     String userData = jsonEncode(res['data']);
  //     sharedPreferences!.setString('user', userData);
  //     userInfo = sharedPreferences!.getString('user');
  //     sessionUser = res['data'];
  //     return Get.back();
  //   }
  //   return null;
  // }
  userInfo = sharedPreferences!.getString('user');
  sessionUser = userInfo != null ? jsonDecode(userInfo) : {};
  if (userInfo != null && !sessionUser!['permissions'].contains(permission)) {
    sharedPreferences!.remove('user');
    return Get.offAllNamed('login');
  }
  return null;
}

String validationMsgs(body) {
  String output = '';
  List msgs = jsonDecode(body);
  for (var msg in msgs) {
    output = output != '' ? '$output \n ${msg[0]}' : msg[0];
  }
  return output;
}

customDialog({String? title, String? middleText, confirm, cancel}) {
  Get.defaultDialog(
    contentPadding: const EdgeInsets.only(right: 20, left: 20),
    title: '$title',
    middleText: "$middleText",
    titleStyle: const TextStyle(
      color: Colors.red,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    middleTextStyle: const TextStyle(fontSize: 18),
    titlePadding: const EdgeInsets.all(10),
    confirm: confirm != null
        ? ElevatedButton(
            onPressed: confirm,
            child: const Text(
              'نعم',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          )
        : confirm,
    cancel: confirm != null
        ? ElevatedButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              'لا',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          )
        : confirm,
  );
}
