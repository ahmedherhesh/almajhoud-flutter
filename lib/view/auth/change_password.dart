import 'package:async_button_builder/async_button_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_almajhoud/api.dart';
import 'package:flutter_almajhoud/colors.dart';
import 'package:flutter_almajhoud/custom_widgets.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  Map data = {
    'old_password': '',
    'password': '',
    'password_confirmation': '',
  };
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  changePasswordProcess() async {
    var formValid = formState.currentState!.validate();
    if (formValid) {
      var response = await API.post(path: 'change-my-password', body: data);
      if (response.containsKey('status') && response['status'] == 200) {
        Get.back(result: 1);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'تغيير كلمة السر'),
      body: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value.toString().length < 6) {
                          return 'كلمة السر يجب أن تكون ستة أحرف أو أكثر';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'كلمة السر القديمة',
                        prefixIcon: Icon(Icons.lock),
                        labelStyle: TextStyle(
                          color: primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onChanged: (val) {
                        data['old_password'] = val.toString();
                      },
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value.toString().length < 6) {
                          return 'كلمة السر يجب أن تكون ستة أحرف أو أكثر';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'كلمة السر الجديدة',
                        prefixIcon: Icon(Icons.lock),
                        labelStyle: TextStyle(
                          color: primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onChanged: (val) {
                        data['password'] = val.toString();
                      },
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value.toString().length < 6) {
                          return 'كلمة السر يجب أن تكون ستة أحرف أو أكثر';
                        }
                        if (data['password_confirmation'] != data['password']) {
                          return 'كلمة السر والتأكيد غير متطابقين';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'تأكيد كلمة السر',
                        prefixIcon: Icon(Icons.lock),
                        labelStyle: TextStyle(
                          color: primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onChanged: (val) {
                        data['password_confirmation'] = val.toString();
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 40),
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: AsyncButtonBuilder(
                          loadingWidget:  CustomProgressIndicator(),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'حفظ',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                              Icon(
                                Icons.save,
                                size: 30,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          onPressed: () async {
                            await changePasswordProcess();
                          },
                          builder: (context, child, callback, _) {
                            return ElevatedButton(
                              onPressed: callback,
                              child: child,
                            );
                          },
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
