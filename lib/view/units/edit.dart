import 'package:flutter/material.dart';
import 'package:flutter_almajhoud/api.dart';
import 'package:flutter_almajhoud/colors.dart';
import 'package:flutter_almajhoud/custom_widgets.dart';
import 'package:get/get.dart';

class EditUnit extends StatefulWidget {
  const EditUnit({super.key});

  @override
  State<EditUnit> createState() => _EditUnitState();
}

class _EditUnitState extends State<EditUnit> {
  GlobalKey<FormState> officerFormState = GlobalKey<FormState>();
  GlobalKey<FormState> unitFormState = GlobalKey<FormState>();
  var args = Get.arguments;
  String? unitOfficer;
  Map data = {
    'title': '',
    'unit_id': '',
  };
  Map unitOfficerData = {
    'title': '',
    'unit_id': '',
  };

  setUnitOfficer() async {
    var response =
        await API.post(path: 'set-unit-officer', body: unitOfficerData);
    if (response['status'] == 200) {
      Get.back(result: 1);
    }
  }

  editUnit() async {
    var formValid = unitFormState.currentState!.validate();
    if (formValid) {
      var response =
          await API.put(path: 'units/${data['unit_id']}', body: data);
      if (response['status'] == 200) {
        Get.back(result: 1);
      }
    }
  }

  @override
  void initState() {
    data['title'] = args['title'].toString();
    data['unit_id'] = args['unit_id'].toString();
    unitOfficerData['unit_id'] = args['unit_id'].toString();
    unitOfficer = args['officer'].toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'تعديل بيانات الوحدة'),
      body: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                border: Border.all(color: primaryColor),
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: Form(
                key: officerFormState,
                child: Column(
                  children: [
                    Text(
                      'رئيس الوحدة : $unitOfficer',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    FutureBuilder(
                      future: API.get(path: 'users'),
                      builder: (context, AsyncSnapshot snapshot) {
                        List users = snapshot.hasData &&
                                snapshot.data.containsKey('data')
                            ? snapshot.data['data']
                            : [];
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CustomProgressIndicator();
                        }
                        if (users.isNotEmpty) {
                          return DropdownButtonFormField(
                            hint: const Text('الضباط'),
                            items: List.generate(
                              users.length,
                              (index) {
                                return DropdownMenuItem(
                                  value: users[index]['id'],
                                  child: Text('${users[index]['name']}'),
                                );
                              },
                            ),
                            onChanged: (val) {
                              unitOfficerData['user_id'] = val.toString();
                            },
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setUnitOfficer();
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
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: primaryColor),
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: Form(
                key: unitFormState,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: data['title'],
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
                        data['title'] = val.toString();
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        editUnit();
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
