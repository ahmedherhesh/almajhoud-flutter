import 'package:flutter/material.dart';
import 'package:flutter_almajhoud/custom_widgets.dart';
import 'package:flutter_almajhoud/api.dart';
import 'package:flutter_almajhoud/env.dart';
import 'package:flutter_almajhoud/functions.dart';
import 'package:get/get.dart';

class Units extends StatefulWidget {
  const Units({super.key});

  @override
  State<Units> createState() => _UnitsState();
}

class _UnitsState extends State<Units> {
  @override
  void initState() {
    checkPermission('عرض الوحدات');
    print(sessionUser);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'الوحدات'),
      drawer: const CustomDrawer(),
      body: FutureBuilder(
        future: API.get(path: 'units'),
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
                  var unit = data[index];
                  return CustomListTile(
                    title: '${unit['title']}',
                    subTitle: '${unit['officer']['name']}',
                    canEdit:
                        sessionUser!['permissions'].contains('تعديل الوحدات'),
                    canDelete:
                        sessionUser!['permissions'].contains('حذف الوحدات'),
                    unitViolationsFunction: () {
                      if (sessionUser!['permissions']
                          .contains('عرض مخالفات الوحدات')) {
                        Get.toNamed(
                          'unit-violations',
                          arguments: {
                            'unit_id': unit['id'],
                            'title': unit['title'],
                          },
                        );
                      }
                    },
                    editFunction: () async {
                      var result = await Get.toNamed('unit-edit', arguments: {
                        'unit_id': unit['id'],
                        'title': unit['title'],
                        'officer': unit['officer']['name']
                      });
                      if (result == 1) setState(() {});
                    },
                    deleteFunction: () async {
                      // if (API.loading) const CustomProgressIndicator();
                      await API.delete(path: 'units/${data[index]['id']}');
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
          sessionUser!['permissions'].contains('اضافة الوحدات')
              ? FloatingActionButton(
                  onPressed: () async {
                    var result = await Get.toNamed('unit-create');
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
