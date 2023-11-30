import 'package:flutter/material.dart';
import 'package:flutter_almajhoud/colors.dart';
import 'package:flutter_almajhoud/env.dart';
import 'package:flutter_almajhoud/home.dart';
import 'package:flutter_almajhoud/view/auth/login.dart';
import 'package:flutter_almajhoud/view/unit_violations/unit_violations.dart';
import 'package:flutter_almajhoud/view/unit_violations/units_violations.dart';
import 'package:flutter_almajhoud/view/units/create.dart';
import 'package:flutter_almajhoud/view/units/edit.dart';
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
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateColor.resolveWith(
              (states) => primaryColor,
            ),
          ),
        ),
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
      // home: sessionUser.isNotEmpty ? const Home() : const Login(),
      initialRoute: '/login',
      getPages: [
        GetPage(
          name: '/login',
          page: () => const Login(),
          middlewares: [],
        ),
        GetPage(
          name: '/units',
          page: () => const Units(),
          middlewares: [],
        ),
        GetPage(
          name: '/unit-create',
          page: () => const CreateUnit(),
          middlewares: [],
        ),
        GetPage(
          name: '/unit-edit',
          page: () => const EditUnit(),
          middlewares: [],
        ),
        GetPage(
          name: '/unit-violations',
          page: () => const UnitViolations(),
          middlewares: [],
        ),
        GetPage(
          name: '/units-violations',
          page: () => const UnitsViolations(),
          middlewares: [],
        ),
      ],
    );
  }
}
