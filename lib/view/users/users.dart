import 'package:flutter/material.dart';
import 'package:flutter_almajhoud/api.dart';
import 'package:flutter_almajhoud/custom_widgets.dart';
import 'package:flutter_almajhoud/env.dart';
import 'package:flutter_almajhoud/functions.dart';
import 'package:get/get.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  void initState() {
    checkPermission('عرض الضباط');
    super.initState();
  }

  bool cached = true;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 2));
        cached = false;
        setState(() => cached);
      },
      child: Scaffold(
        appBar: appBar(title: 'الضباط'),
        drawer: const CustomDrawer(),
        body: FutureBuilder(
          future: API.get(path: 'users', cached: cached),
          builder: (context, AsyncSnapshot snapshot) {
            List data = snapshot.hasData && snapshot.data.containsKey('data')
                ? snapshot.data['data']
                : [];
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CustomProgressIndicator();
            }
            if (data.isNotEmpty) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: List.generate(
                  data.length,
                  (index) {
                    var user = data[index];
                    return CustomListTile(
                      title: '${user['name']}',
                      image: 'assets/images/police.png',
                      canEdit:
                          sessionUser!['permissions'].contains('تعديل الضباط'),
                      canDelete:
                          sessionUser!['permissions'].contains('حذف الضباط'),
                      onTap: () => Get.toNamed(
                        'officer-violations',
                        arguments: {
                          'user_id': user['id'],
                          'title': user['name'],
                        },
                      ),
                      editFunction: () async {
                        var result = await Get.toNamed('user-edit', arguments: {
                          'user_id': user['id'],
                          'name': user['name'],
                          'email': user['email'],
                          'role': user['role'],
                          'status': user['status'],
                          'permissions': user['permissions'],
                        });
                        if (result == 1) setState(() {});
                      },
                      deleteFunction: () async {
                        // if (API.loading) const CustomProgressIndicator();
                        await API.delete(path: 'users/${user['id']}');
                        setState(() {});
                      },
                    );
                  },
                ),
              );
            }
            return const SizedBox();
          },
        ),
        floatingActionButton:
            sessionUser!['permissions'].contains('اضافة الضباط')
                ? FloatingActionButton(
                    onPressed: () async {
                      var result = await Get.toNamed('user-create');
                      if (result == 1) {
                        cached = false;
                        setState(() {});
                      }
                    },
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  )
                : null,
      ),
    );
  }
}
