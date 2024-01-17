import 'package:flutter/material.dart';
import 'package:flutter_almajhoud/colors.dart';
import 'package:flutter_almajhoud/env.dart';
import 'package:flutter_almajhoud/middleware/auth_middleware.dart';
import 'package:flutter_almajhoud/view/auth/change_password.dart';
import 'package:flutter_almajhoud/view/auth/login.dart';
import 'package:flutter_almajhoud/view/officer_violations/all_violations.dart';
import 'package:flutter_almajhoud/view/officer_violations/officer_violations.dart';
import 'package:flutter_almajhoud/view/users/create.dart';
import 'package:flutter_almajhoud/view/users/edit.dart';
import 'package:flutter_almajhoud/view/users/users.dart';
import 'package:flutter_almajhoud/view/violations/create.dart';
import 'package:flutter_almajhoud/view/violations/edit.dart';
import 'package:flutter_almajhoud/view/violations/violations.dart';
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
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: primaryColor,
            ),
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
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/users',
          page: () => const Users(),
          middlewares: [],
        ),
        GetPage(
          name: '/user-create',
          page: () => const CreateUser(),
          middlewares: [],
        ),
        GetPage(
          name: '/user-edit',
          page: () => const EditUser(),
          middlewares: [],
        ),
        GetPage(
          name: '/change-password',
          page: () => const ChangePassword(),
          middlewares: [],
        ),
        GetPage(
          name: '/all-violations',
          page: () => const AllViolations(),
          middlewares: [],
        ),
        GetPage(
          name: '/officer-violations',
          page: () => const OfficerViolations(),
          middlewares: [],
        ),
        GetPage(
          name: '/violations',
          page: () => const Violations(),
          middlewares: [],
        ),
        GetPage(
          name: '/violation-create',
          page: () => const CreateViolation(),
          middlewares: [],
        ),
        GetPage(
          name: '/violation-edit',
          page: () => const EditViolation(),
          middlewares: [],
        ),
      ],
    );
  }
}
