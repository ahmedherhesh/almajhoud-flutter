import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_almajhoud/api.dart';
import 'package:flutter_almajhoud/colors.dart';
import 'package:flutter_almajhoud/custom_widgets.dart';
import 'package:flutter_almajhoud/functions.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:get/get.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({super.key});

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  Map data = {
    'name': '',
    'email': '',
    'password': '',
    'role': '',
    'permissions': [],
  };
  List allPermissions = [];
  create() async {
    var formValid = formState.currentState!.validate();
    if (formValid) {
      var response = await API.post(path: 'register', body: data);
      print(data);
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
    checkPermission('اضافة الضباط');
    permissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'اضافة ضابط'),
      body: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
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
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onChanged: (val) {
                          data['name'] = val.toString();
                        },
                      ),
                      TextFormField(
                        validator: (value) =>
                            EmailValidator.validate(value.toString())
                                ? null
                                : "يرجى كتابة ايميل صحيح",
                        decoration: const InputDecoration(
                          labelText: 'الايميل',
                          contentPadding: EdgeInsets.only(top: 20, bottom: 20),
                          labelStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onChanged: (val) {
                          data['email'] = val.toString();
                        },
                      ),
                      TextFormField(
                        validator: (val) {
                          if (val.toString().length < 3) {
                            return 'كلمة السر يجب أن تحتوى على 6 أحرف أو أكثر';
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'كلمة السر',
                          contentPadding: EdgeInsets.only(top: 20, bottom: 20),
                          labelStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onChanged: (val) {
                          data['password'] = val.toString();
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30, bottom: 10),
                        child: DropdownButtonFormField(
                          hint: const Text(
                            'دور المستخدم',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
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
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: allPermissions.isNotEmpty
                            ? CustomMultiSelect(
                                title: 'الصلاحيات',
                                items: List.generate(allPermissions.length,
                                    (index) {
                                  return MultiSelectItem(
                                    allPermissions[index],
                                    allPermissions[index],
                                  );
                                }),
                                initialValue: [],
                                onConfirm: (results) {
                                  data['permissions'] = results;
                                },
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
      ),
    );
  }
}
