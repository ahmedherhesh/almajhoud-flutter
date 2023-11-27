import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_almajhoud/env.dart';
import 'package:flutter_almajhoud/functions.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? email, password;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  loginProcess() async {
    var formValid = formState.currentState!.validate();
    if (formValid) {
      var url = Uri.parse('$mainUrl/login');
      var response =
          await http.post(url, body: {'email': email, 'password': password});
      if (response.statusCode == 422) {
        String text = validationMsgs(response.body);
        Get.defaultDialog(
          contentPadding: const EdgeInsets.only(right: 20, left: 20),
          title: 'خطأ في تسجيل الدخول',
          middleText: text,
          titleStyle: const TextStyle(
            color: Colors.red,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          middleTextStyle: const TextStyle(fontSize: 18),
          titlePadding: const EdgeInsets.all(10),
        );
      } else {
        var body = jsonDecode(response.body);
        if (body['status'] == 400) {
        } else {
          sharedPreferences!.setString('user', response.body);
          print(sharedPreferences!.getString('user'));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xffeeeeee),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Form(
                key: formState,
                child: Column(
                  children: [
                    Image.asset('assets/images/logo.png', width: 150),
                    TextFormField(
                      validator: (value) {
                        if (value.toString().length < 3) {
                          return 'اسم المستخدم يجب أن يحتوى على ثلاثة أحرف أو أكثر';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'الإيميل',
                        prefixIcon: Icon(Icons.person),
                      ),
                      onChanged: (val) {
                        email = val.toString();
                      },
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value.toString().length < 6) {
                          return 'كلمة السر  يجب أن يحتوى على ستة أحرف أو أكثر';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'كلمة السر',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      onChanged: (val) {
                        password = val.toString();
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 40),
                      width: double.infinity,
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await loginProcess();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(8),
                          ),
                          icon: const Icon(
                            Icons.arrow_circle_left_outlined,
                            size: 30,
                          ),
                          label: const Text(
                            'تسجيل الدخول',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
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
