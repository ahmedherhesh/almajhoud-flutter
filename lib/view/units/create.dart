import 'package:flutter/material.dart';
import 'package:flutter_almajhoud/api.dart';
import 'package:flutter_almajhoud/custom_widgets.dart';
import 'package:get/get.dart';

class CreateUnit extends StatefulWidget {
  const CreateUnit({super.key});

  @override
  State<CreateUnit> createState() => _CreateUnitState();
}

class _CreateUnitState extends State<CreateUnit> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  String? title;
  create() async {
    var formValid = formState.currentState!.validate();
    if (formValid) {
      var response = await API.post(path: 'units', body: {"title": title});
      if (response['status'] == 200) {
        Get.toNamed('units');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'اضافة وحدة جديدة'),
      body: Form(
        key: formState,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (val) {
                  if (val.toString().length < 3) {
                    return 'اسم المستخدم يجب أن يحتوى على ثلاثة أحرف أو أكثر';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'اسم الوحدة',
                ),
                onChanged: (val) {
                  title = val.toString();
                  print(title);
                },
              ),
              ElevatedButton(
                onPressed: () {
                  create();
                },
                child: const Text(
                  'اضافة',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
