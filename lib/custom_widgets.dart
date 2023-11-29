import 'package:flutter/material.dart';
import 'package:flutter_almajhoud/colors.dart';
import 'package:flutter_almajhoud/env.dart';
import 'package:get/get.dart';

appBar({String? title}) {
  return AppBar(
    iconTheme: const IconThemeData(
      color: Colors.white,
      size: 30,
    ),
    title: Text(
      '$title',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 30,
      ),
    ),
    centerTitle: true,
    toolbarHeight: 70,
    elevation: 8,
    shadowColor: shadowColor,
    backgroundColor: primaryColor,
    actions: [
      PopupMenuButton(
        iconSize: 30,
        iconColor: Colors.white,
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
          if (value == 'changeMyPassword') {
            print("Settings menu is changeMyPassword.");
          } else if (value == 'logout') {
            sharedPreferences!.clear();
            Get.offAllNamed('login');
          }
        },
      ),
    ],
  );
}

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class CustomListTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final Function unitViolationsFunction;
  final Function editFunction;
  final Function deleteFunction;
  const CustomListTile({
    super.key,
    required this.title,
    required this.subTitle,
    required this.unitViolationsFunction,
    required this.editFunction,
    required this.deleteFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      margin: const EdgeInsets.only(bottom: margin),
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(color: primaryColor),
          bottom: BorderSide(color: primaryColor),
        ),
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(0),
        leading: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.cover,
        ),
        trailing: PopupMenuButton(
          iconSize: 30,
          iconColor: Colors.black,
          color: Colors.white,
          itemBuilder: (context) {
            return const [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.edit),
                    Text(
                      "تعديل",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.delete),
                    Text(
                      "حذف",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ];
          },
          onSelected: (value) {
            if (value == 'edit') {
              editFunction();
            } else if (value == 'delete') {
              deleteFunction();
            }
          },
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 20),
        ),
        subtitle: Text(
          subTitle,
          style: const TextStyle(fontSize: 18),
        ),
        onTap: () {
          unitViolationsFunction();
        },
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
