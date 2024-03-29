import 'package:flutter/material.dart';
import 'package:flutter_almajhoud/api.dart';
import 'package:flutter_almajhoud/colors.dart';
import 'package:flutter_almajhoud/custom_widgets.dart';
import 'package:flutter_almajhoud/functions.dart';
import 'package:get/get.dart';

class EditViolation extends StatefulWidget {
  const EditViolation({super.key});

  @override
  State<EditViolation> createState() => _EditViolationState();
}

class _EditViolationState extends State<EditViolation> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  var args = Get.arguments;
  Map data = {
    'title': '',
    'violation_id': '',
  };
  edit() async {
    var formValid = formState.currentState!.validate();
    if (formValid) {
      var response =
          await API.put(path: 'violations/${data['violation_id']}', body: data);
      if (response.containsKey('status') && response['status'] == 200) {
        Get.back(result: 1);
      }
    }
  }

  @override
  void initState() {
    checkPermission('تعديل عناوين المخالفات');
    data['title'] = args['title'].toString();
    data['violation_id'] = args['violation_id'].toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'تعديل عنوان المخالفة'),
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
                    TextFormField(
                      initialValue: data['title'],
                      validator: (val) {
                        if (val.toString().length < 3) {
                          return 'عنوان المخالفه  يجب أن يحتوى على ثلاثة أحرف أو أكثر';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'عنوان المخالفة',
                        contentPadding: EdgeInsets.only(top: 20, bottom: 20),
                        labelStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onChanged: (val) {
                        data['title'] = val.toString();
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        edit();
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
