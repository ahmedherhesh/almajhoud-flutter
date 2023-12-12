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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'الضباط'),
      body: FutureBuilder(
        future: API.get(path: 'users'),
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
                    subTitle: user['unit']['title'],
                    canEdit:
                        sessionUser!['permissions'].contains('تعديل الضباط'),
                    canDelete:
                        sessionUser!['permissions'].contains('حذف الضباط'),
                    unitViolationsFunction: () => false,
                    editFunction: () async {
                      var result = await Get.toNamed('user-edit', arguments: {
                        'user_id': user['id'],
                        'name': user['name'],
                        'email': user['email'],
                        'role': user['role'],
                        'status': user['status'],
                        'permissions': user['permissions'],
                        'unit': user['unit'],
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
      floatingActionButton: sessionUser!['permissions'].contains('اضافة الضباط')
          ? FloatingActionButton(
              onPressed: () async {
                var result = await Get.toNamed('user-create');
                if (result == 1) setState(() {});
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          : null,
    );
  }
}
