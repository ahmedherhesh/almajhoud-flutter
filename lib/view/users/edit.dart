import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_almajhoud/api.dart';
import 'package:flutter_almajhoud/colors.dart';
import 'package:flutter_almajhoud/custom_widgets.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
// import 'package:toggle_switch/toggle_switch.dart';

import 'package:get/get.dart';

class EditUser extends StatefulWidget {
  const EditUser({super.key});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  var args = Get.arguments;
  Map data = {
    'name': '',
    'email': '',
    'role': '',
    'status': '',
    'permissions': [],
  };
  List allPermissions = [];
  edit() async {
    var formValid = formState.currentState!.validate();
    if (formValid) {
      var response =
          await API.put(path: 'users/${args['user_id']}', body: data);
      if (response.containsKey('status') && response['status'] == 200) {
        Get.back(result: 1);
      }
    }
  }

  permissions() async {
    var response = await API.get(path: 'permissions');
    allPermissions = response['data'];
    setState(() {});
  }

  @override
  void initState() {
    data['name'] = args['name'].toString();
    data['email'] = args['email'].toString();
    data['role'] = args['role'].toString();
    data['status'] = args['status'].toString();
    data['permissions'] = args['permissions'];
    permissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'تعديل بيانات الضابط'),
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
                      initialValue: data['name'],
                      validator: (val) {
                        if (val.toString().length < 3) {
                          return 'اسم الضابط يجب أن يحتوى على ثلاثة أحرف أو أكثر';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'الإسم',
                        contentPadding: EdgeInsets.only(top: 20, bottom: 20),
                        labelStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onChanged: (val) {
                        data['name'] = val.toString();
                      },
                    ),
                    TextFormField(
                      initialValue: data['email'],
                      validator: (value) =>
                          EmailValidator.validate(value.toString())
                              ? null
                              : "يرجى كتابة ايميل صحيح",
                      decoration: const InputDecoration(
                        labelText: 'الايميل',
                        contentPadding: EdgeInsets.only(top: 20, bottom: 20),
                        labelStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onChanged: (val) {
                        data['email'] = val.toString();
                      },
                    ),
                    DropdownButtonFormField(
                      hint: Text(data['role'] == 'admin' ? 'أدمن' : 'مستخدم'),
                      items: const [
                        DropdownMenuItem(
                          value: 'user',
                          child: Text('مستخدم'),
                        ),
                        DropdownMenuItem(
                          value: 'admin',
                          child: Text('أدمن'),
                        ),
                      ],
                      onChanged: (val) {
                        data['role'] = val.toString();
                      },
                    ),
                    DropdownButtonFormField(
                      hint: Text(data['status'] == 'active' ? 'مفعل' : 'محظور'),
                      items: const [
                        DropdownMenuItem(
                          value: 'active',
                          child: Text('تفعيل'),
                        ),
                        DropdownMenuItem(
                          value: 'block',
                          child: Text('حظر'),
                        ),
                      ],
                      onChanged: (val) {
                        print(data['status']);
                        data['status'] = val.toString();
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: allPermissions.isNotEmpty
                          ? MultiSelectDialogField(
                              items: List.generate(
                                allPermissions.length,
                                (index) => MultiSelectItem(
                                  allPermissions[index],
                                  allPermissions[index],
                                ),
                              ),
                              title: const Text("الصلاحيات"),
                              selectedColor: primaryColor,
                              decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.grey)),
                              ),
                              buttonText: const Text(
                                "الصلاحيات",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                              onConfirm: (results) {
                                data['permissions'] = results;
                              },
                              initialValue: data['permissions'],
                            )
                          : Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(bottom: 8),
                              decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.grey)),
                              ),
                              child: const Text(
                                'الصلاحيات',
                                style: TextStyle(
                                  fontSize: 16,
                                  // fontWeight: FontWeight.bold,
                                ),
                              )),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        data['permissions'] = jsonEncode(data['permissions']);
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
