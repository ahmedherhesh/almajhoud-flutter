import 'package:flutter/material.dart';
import 'package:flutter_almajhoud/api.dart';
import 'package:flutter_almajhoud/colors.dart';
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
      if (response.containsKey('status') && response['status'] == 200) {
        Get.back(result: 1);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'اضافة وحدة جديدة'),
      body: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: primaryColor),
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: Form(
                key: formState,
                child: Column(
                  children: [
                    // Container(
                    //   padding: const EdgeInsets.all(12),
                    //   decoration: BoxDecoration(
                    //     border: Border.all(color: primaryColor),
                    //     borderRadius: const BorderRadius.only(
                    //       bottomRight: Radius.circular(20),
                    //       topLeft: Radius.circular(20),
                    //     ),
                    //   ),
                    //   child: const Text(
                    //     'وحدة جديدة',
                    //     style: TextStyle(
                    //         fontSize: 25, fontWeight: FontWeight.bold),
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    TextFormField(
                      validator: (val) {
                        if (val.toString().length < 3) {
                          return 'اسم الوحدة يجب أن يحتوى على ثلاثة أحرف أو أكثر';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'اسم الوحدة',
                        contentPadding: EdgeInsets.only(top: 20, bottom: 20),
                        labelStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onChanged: (val) {
                        title = val.toString();
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        create();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.only(
                          right: 40,
                          left: 40,
                          top: 10,
                          bottom: 10,
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.save,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'حفظ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
