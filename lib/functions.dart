import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// // import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:flutter/material.dart';

// AwesomeDialog awesomeDialog(context, body) {
//   body = jsonDecode(body);
//   return AwesomeDialog(
//     context: context,
//     dialogType: DialogType.ERROR,
//     animType: AnimType.SCALE,
//     title: 'Validation Error',
//     headerAnimationLoop: false,
//     titleTextStyle: const TextStyle(
//       color: Colors.red,
//       fontWeight: FontWeight.bold,
//       fontSize: 25,
//     ),
//     body: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: List.generate(
//         body.values.length,
//         (index) => Text(
//           '${body.values.toList()[index][0]}',
//           style: const TextStyle(
//             // fontWeight: FontWeight.bold,
//             fontSize: 18,
//           ),
//         ),
//       ),
//     ),
//     btnCancelOnPress: () {},
//     btnOkOnPress: () {},
//   );
// }

String validationMsgs(body) {
  String output = '';
  List msgs = jsonDecode(body);
  msgs.forEach((element) {
    output = output != '' ? '$output \n ${element[0]}' : element[0];
  });
  return output;
}

customDialog({String? title, String? middleText}) {
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
  );
}
