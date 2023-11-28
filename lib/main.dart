import 'package:flutter/material.dart';
import 'package:flutter_almajhoud/colors.dart';
import 'package:flutter_almajhoud/env.dart';
import 'package:flutter_almajhoud/view/auth/login.dart';
import 'package:flutter_almajhoud/view/units/units.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        fontFamily: 'Cairo',
        scaffoldBackgroundColor: Colors.white,
        primaryColor: primaryColor,
        primarySwatch: Colors.grey,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primaryColor,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: Colors.white,
        ),
      ),
      textDirection: TextDirection.rtl,
      debugShowCheckedModeBanner: false,
      title: 'Almajhoud',
      home: const Login(),
      getPages: [
        GetPage(name: '/login', page: () => const Login()),
        GetPage(name: '/units', page: () => const Units()),
      ],
    );
  }
}
