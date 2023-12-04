import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_almajhoud/api.dart';
import 'package:flutter_almajhoud/colors.dart';
import 'package:flutter_almajhoud/custom_widgets.dart';
import 'package:get/get.dart';

class CreateUnitViolation extends StatefulWidget {
  const CreateUnitViolation({super.key});

  @override
  State<CreateUnitViolation> createState() => _CreateUnitViolationState();
}

class _CreateUnitViolationState extends State<CreateUnitViolation> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  String? title;
  create() async {
    var formValid = formState.currentState!.validate();
    if (formValid) {
      // var response = await API.get(path: 'violations');
      // if (response['status'] == 200) {
      //   Get.back(result: 1);
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'تسجيل مخالفة'),
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
                    FutureBuilder(
                        future: API.get(path: 'violations'),
                        builder: (context, AsyncSnapshot snapshot) {
                          print(snapshot.data);
                          List data =
                              snapshot.hasData ? snapshot.data['data'] : [];
                          return DropdownButton(
                            items: List.generate(
                              data.length,
                              (index) {
                                var el = data[index];
                                return DropdownMenuItem(
                                  value: '${el['id']}',
                                  child: Text('${el['title']}'),
                                );
                              },
                            ),
                            onChanged: (val) {},
                          );
                        }),
                    TextFormField(
                      validator: (val) {
                        val = val.toString();
                        if (val.isEmpty) {
                          return 'هذا الحقل لا يجب ان يكون فارغاً';
                        }
                        int count = int.parse(val);
                        if (count < 1) {
                          return 'يجب ان يكون العدد اكبر من صفر';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'العدد',
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
