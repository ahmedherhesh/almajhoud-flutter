import 'package:flutter/material.dart';
import 'package:flutter_almajhoud/api.dart';
import 'package:flutter_almajhoud/custom_widgets.dart';
import 'package:get/get.dart';

class UnitViolations extends StatefulWidget {
  const UnitViolations({super.key});

  @override
  State<UnitViolations> createState() => _UnitViolationsState();
}

class _UnitViolationsState extends State<UnitViolations> {
  var args = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: args['title']),
      body: FutureBuilder(
          future: API.get(path: 'units/${args['unit_id']}'),
          builder: (context, AsyncSnapshot snapshot) {
            return Text('${snapshot.data}');
          }),
    );
  }
}
