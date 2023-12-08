import 'dart:convert';

import 'package:async_button_builder/async_button_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_almajhoud/colors.dart';
import 'package:flutter_almajhoud/custom_widgets.dart';
import 'package:flutter_almajhoud/env.dart';
import 'package:flutter_almajhoud/functions.dart';
import 'package:flutter_almajhoud/middleware/auth_middleware.dart';
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
      if (response.statusCode >= 500) {
        return customDialog(
            title: 'خطأ برمجي',
            middleText: "يرجى الانتظار حتى يقوم الدعم الفني بحل المشكلة");
      }

      if (response.statusCode == 422) {
        String text = validationMsgs(response.body);
        return customDialog(title: 'خطأ في تسجيل الدخول', middleText: text);
      } else {
        var body = jsonDecode(response.body);
        if (body['status'] == 400) {
        } else {
          sharedPreferences!.setString('user', response.body);
          return Get.offAndToNamed('login');
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
                // boxShadow: [
                //   BoxShadow(
                //     color: Color(0xffeeeeee),
                //     blurRadius: 6,
                //   ),
                // ],
              ),
              child: Form(
                key: formState,
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 60,
                      child: Image.asset(
                        'assets/images/logo.png',
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value.toString().length < 3) {
                          return 'اسم المستخدم يجب أن يحتوى على ثلاثة أحرف أو أكثر';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'الإيميل',
                        prefixIcon: Icon(Icons.email),
                        labelStyle: TextStyle(
                          color: primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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
                        labelStyle: TextStyle(
                          color: primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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
                        child: AsyncButtonBuilder(
                          loadingWidget: const CustomProgressIndicator(),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_circle_left_outlined,
                                size: 30,
                                color: Colors.white,
                              ),
                              Text(
                                'تسجيل الدخول',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ],
                          ),
                          onPressed: () async {
                            await loginProcess();
                          },
                          builder: (context, child, callback, _) {
                            return ElevatedButton(
                              onPressed: callback,
                              child: child,
                            );
                          },
                        ),
                      ),
                      // Directionality(
                      //     textDirection: TextDirection.ltr,
                      //     child: ElevatedButton.icon(
                      //       onPressed: () {
                      //         loginProcess();
                      //       },
                      //       icon: const Icon(
                      //         Icons.arrow_circle_left_outlined,
                      //         size: 30,
                      //         color: Colors.white,
                      //       ),
                      //       label: const Text(
                      //         'تسجيل الدخول',
                      //         style: TextStyle(
                      //           fontSize: 20,
                      //           color: Colors.white,
                      //         ),
                      //       ),
                      //     ),
                      //   )
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
