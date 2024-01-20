import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_almajhoud/api.dart';
import 'package:flutter_almajhoud/colors.dart';
import 'package:flutter_almajhoud/custom_widgets.dart';
import 'package:flutter_almajhoud/functions.dart';
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
  Map formData = {
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
          await API.put(path: 'users/${args['user_id']}', body: formData);
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
    checkPermission('تعديل الضباط');
    formData['name'] = args['name'].toString();
    formData['email'] = args['email'].toString();
    formData['role'] = args['role'].toString();
    formData['status'] = args['status'].toString();
    formData['permissions'] = args['permissions'];
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
                        initialValue: formData['name'],
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
                          formData['name'] = val.toString();
                        },
                      ),
                      TextFormField(
                        initialValue: formData['email'],
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
                          formData['email'] = val.toString();
                        },
                      ),
                      DropdownButtonFormField(
                        hint: Text(
                            formData['role'] == 'admin' ? 'أدمن' : 'مستخدم'),
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
                          formData['role'] = val.toString();
                        },
                      ),
                      DropdownButtonFormField(
                        hint: Text(
                            formData['status'] == 'active' ? 'مفعل' : 'محظور'),
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
                          print(formData['status']);
                          formData['status'] = val.toString();
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: allPermissions.isNotEmpty
                            ? CustomMultiSelect(
                                title: 'الصلاحيات',
                                data: allPermissions,
                                initialValue: formData['permissions'],
                                onConfirm: (results) {
                                  formData['permissions'] = results;
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
                          formData['permissions'] =
                              jsonEncode(formData['permissions']);
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
      ),
    );
  }
}

