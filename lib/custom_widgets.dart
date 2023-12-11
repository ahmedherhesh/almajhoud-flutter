import 'package:flutter/material.dart';
import 'package:flutter_almajhoud/colors.dart';
import 'package:flutter_almajhoud/env.dart';
import 'package:get/get.dart';

appBar({String? title, bool showTabBar = false, tabBar}) {
  return AppBar(
    iconTheme: const IconThemeData(
      color: Colors.white,
      size: 30,
    ),
    title: Text(
      '$title',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 25,
      ),
    ),
    bottom: showTabBar ? tabBar : null,
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
              value: 'change-password',
              child: Text(
                "تغيير الباسورد",
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
        onSelected: (value) async {
          if (value == 'change-password') {
            Get.toNamed('change-password');
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
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomListTile extends StatelessWidget {
  final String title;
  String? subTitle;
  final Function unitViolationsFunction;
  final Function editFunction;
  final Function deleteFunction;
  CustomListTile({
    super.key,
    required this.title,
    this.subTitle,
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
        subtitle: subTitle != null
            ? Text(
                '$subTitle',
                style: const TextStyle(fontSize: 18),
              )
            : null,
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
  drawerListTile({title, IconData? icon, listStyle, onTap}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey))),
        child: ListTile(
          leading: Icon(
            icon,
            size: 30,
          ),
          title: Text(
            "$title",
            style: listStyle,
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle listStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
    return SizedBox(
      height: 440,
      child: SafeArea(
        child: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(
                  "${sessionUser!['name']}",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                accountEmail: Text(
                  "${sessionUser!['email']}",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                currentAccountPicture: const CircleAvatar(
                  backgroundImage: AssetImage(
                    "assets/images/logo.png",
                  ),
                ),
                decoration: const BoxDecoration(color: primaryColor),
              ),
              drawerListTile(
                title: 'الوحدات',
                icon: Icons.home,
                listStyle: listStyle,
                onTap: () => Get.toNamed('units'),
              ),
              drawerListTile(
                title: 'الضباط',
                icon: Icons.person,
                listStyle: listStyle,
                onTap: () => Get.toNamed('users'),
              ),
              drawerListTile(
                title: 'مخالفات الوحدات',
                icon: Icons.dangerous,
                listStyle: listStyle,
                onTap: () => Get.toNamed(
                  'units-violations',
                  arguments: {'title': 'إجمالي المخالفات'},
                ),
              ),
              drawerListTile(
                title: 'المخالفات',
                icon: Icons.dangerous,
                listStyle: listStyle,
                onTap: () => Get.toNamed('violations'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
