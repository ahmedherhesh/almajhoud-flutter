import 'package:flutter/material.dart';
import 'package:flutter_almajhoud/colors.dart';
import 'package:flutter_almajhoud/env.dart';
import 'package:flutter_almajhoud/functions.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

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
  bool canEdit;
  bool canDelete;
  final Function onTap;
  final Function editFunction;
  final Function deleteFunction;
  CustomListTile({
    super.key,
    required this.title,
    this.subTitle,
    required this.onTap,
    required this.editFunction,
    required this.deleteFunction,
    this.canEdit = true,
    this.canDelete = true,
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
        trailing: canEdit || canDelete
            ? PopupMenuButton(
                iconSize: 30,
                iconColor: Colors.black,
                color: Colors.white,
                itemBuilder: (context) {
                  return [
                    canEdit
                        ? const PopupMenuItem(
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
                          )
                        : const PopupMenuItem(
                            value: '',
                            child: SizedBox(),
                          ),
                    canDelete
                        ? const PopupMenuItem(
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
                          )
                        : const PopupMenuItem(
                            value: '',
                            child: SizedBox(),
                          ),
                  ];
                },
                onSelected: (value) {
                  if (value == 'edit') {
                    editFunction();
                  } else if (value == 'delete') {
                    customDialog(
                      title: 'تحذير',
                      middleText: 'هل انت متأكد من الحذف  ',
                      confirm: () {
                        deleteFunction();
                        Get.back();
                      },
                    );
                  }
                },
              )
            : const SizedBox(),
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
          onTap();
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
    return SafeArea(
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
            sessionUser!['permissions'].contains('عرض الضباط')
                ? drawerListTile(
                    title: 'الضباط',
                    icon: Icons.person,
                    listStyle: listStyle,
                    onTap: () => Get.toNamed('users'),
                  )
                : const SizedBox(),
            sessionUser!['permissions'].contains('عرض اجمالي المخالفات')
                ? drawerListTile(
                    title: 'إجمالي المخالفات',
                    icon: Icons.dangerous,
                    listStyle: listStyle,
                    onTap: () => Get.toNamed(
                      'all-violations',
                      arguments: {'title': 'إجمالي المخالفات'},
                    ),
                  )
                : const SizedBox(),
            sessionUser!['permissions'].contains('عرض عناوين المخالفات')
                ? drawerListTile(
                    title: 'عناوين المخالفات',
                    icon: Icons.dangerous,
                    listStyle: listStyle,
                    onTap: () => Get.toNamed('violations'),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

class CustomMultiSelect extends StatelessWidget {
  const CustomMultiSelect({
    super.key,
    required this.items,
    required this.title,
    required this.initialValue,
    required this.onConfirm,
  });

  final List<MultiSelectItem> items;
  final String title;
  final Function onConfirm;
  final List initialValue;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: MultiSelectDialogField(
        cancelText: const Text('إلغاء'),
        confirmText: const Text('موافق'),
        searchHint: 'بحث',
        searchHintStyle: const TextStyle(color: Colors.black),
        searchTextStyle: const TextStyle(color: Colors.black),
        chipDisplay: MultiSelectChipDisplay(
          alignment: Alignment.topRight,
          chipWidth: 40,
        ),
        searchIcon: const Icon(
          Icons.search,
          color: primaryColor,
        ),
        closeSearchIcon: const Icon(
          Icons.close,
          color: primaryColor,
        ),
        searchable: true,
        itemsTextStyle: const TextStyle(fontSize: 16, fontFamily: 'Cairo'),
        selectedItemsTextStyle:
            const TextStyle(fontSize: 16, fontFamily: 'Cairo'),
        items: items,
        title: Text(title),
        selectedColor: primaryColor,
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey)),
        ),
        buttonText: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        onConfirm: (results) {
          onConfirm(results);
        },
        initialValue: initialValue,
      ),
    );
  }
}
