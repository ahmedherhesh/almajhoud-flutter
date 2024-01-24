import 'package:flutter/material.dart';
import 'package:flutter_almajhoud/api.dart';
import 'package:flutter_almajhoud/custom_widgets.dart';
import 'package:flutter_almajhoud/env.dart';
import 'package:flutter_almajhoud/functions.dart';
import 'package:get/get.dart';

class Violations extends StatefulWidget {
  const Violations({super.key});

  @override
  State<Violations> createState() => _ViolationsState();
}

class _ViolationsState extends State<Violations> {
  @override
  void initState() {
    checkPermission('عرض عناوين المخالفات');
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
        appBar: appBar(title: 'عناوين المخالفات'),
        drawer: const CustomDrawer(),
        body: FutureBuilder(
          future: API.get(path: 'violations', cached: cached),
          builder: (context, AsyncSnapshot snapshot) {
            List data = snapshot.hasData && snapshot.data.containsKey('data')
                ? snapshot.data['data']
                : [];
            if (snapshot.connectionState == ConnectionState.waiting) {
              return  CustomProgressIndicator();
            }
            if (data.isNotEmpty) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: List.generate(
                  data.length,
                  (index) {
                    var violation = data[index];
                    return CustomListTile(
                      title: '${violation['title']}',
                      image: 'assets/images/logo.png',
                      canEdit: sessionUser!['permissions']
                          .contains('تعديل عناوين المخالفات'),
                      canDelete: sessionUser!['permissions']
                          .contains('حذف عناوين المخالفات'),
                      onTap: () => false,
                      editFunction: () async {
                        var result =
                            await Get.toNamed('violation-edit', arguments: {
                          'violation_id': violation['id'],
                          'title': violation['title'],
                        });
                        if (result == 1) setState(() {});
                      },
                      deleteFunction: () async {
                        // if (API.loading) const CustomProgressIndicator();
                        await API.delete(path: 'violations/${violation['id']}');
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
            sessionUser!['permissions'].contains('اضافة عناوين المخالفات')
                ? FloatingActionButton(
                    onPressed: () async {
                      var result = await Get.toNamed('violation-create');
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
