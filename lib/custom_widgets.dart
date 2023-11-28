import 'package:flutter/material.dart';
import 'package:flutter_almajhoud/colors.dart';
import 'package:flutter_almajhoud/env.dart';
import 'package:get/get.dart';

appBar({String? title}) {
  return AppBar(
    title: Text(
      '$title',
      style: const TextStyle(color: Colors.white, fontSize: 30),
    ),
    toolbarHeight: 70,
    elevation: 8,
    shadowColor: shadowColor,
    backgroundColor: primaryColor,
    actions: [
      PopupMenuButton(
        // add icon, by default "3 dot" icon
        // icon: Icon(Icons.book)
        color: Colors.white,
        itemBuilder: (context) {
          return const [
            PopupMenuItem(
              value: 'profile',
              child: Text(
                "الملف الشخصي",
                style: TextStyle(fontSize: 20),
              ),
            ),
            PopupMenuItem(
              value: 'logout',
              child: Text(
                "تسجيل الخروج",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ];
        },
        onSelected: (value) {
          if (value == 0) {
            print("My account menu is selected.");
          } else if (value == 1) {
            print("Settings menu is selected.");
          } else if (value == 'logout') {
            sharedPreferences!.clear();
            Get.offAllNamed('login');
          }
        },
      ),
    ],
  );
}

class CustomListTile extends StatelessWidget {
  final String title;
  final String subTitle;
  const CustomListTile({
    super.key,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      margin: const EdgeInsets.only(bottom: margin),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 4,
          ),
        ],
      ),
      child: ListTile(
        leading: Image.asset('assets/images/logo.png'),
        title: Text(
          title,
          style: const TextStyle(fontSize: 20),
        ),
        subtitle: Text(
          subTitle,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const TextStyle listStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
    return SafeArea(
      child: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("${sessionUser['name']}"),
              accountEmail: Text("${sessionUser['email']}"),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage(
                  "assets/images/logo.png",
                ),
              ),
              decoration: const BoxDecoration(color: primaryColor),
            ),
            ListTile(
              leading: const Icon(
                Icons.person,
                size: 30,
              ),
              title: const Text(
                "الضباط",
                style: listStyle,
              ),
              onTap: () => Get.toNamed('units'),
            ),
            ListTile(
              leading: const Icon(
                Icons.home,
                size: 30,
              ),
              title: const Text(
                "الوحدات",
                style: listStyle,
              ),
              onTap: () => Get.toNamed('home'),
            ),
            ListTile(
              leading: const Icon(
                Icons.dangerous,
                size: 30,
              ),
              title: const Text(
                "مخالفات الوحدات",
                style: listStyle,
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(
                Icons.dangerous,
                size: 30,
              ),
              title: const Text(
                "المخالفات",
                style: listStyle,
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
