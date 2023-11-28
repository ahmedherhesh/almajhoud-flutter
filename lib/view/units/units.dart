import 'package:flutter/material.dart';
import 'package:flutter_almajhoud/custom_widgets.dart';
import 'package:flutter_almajhoud/api.dart';
import 'package:get/get.dart';

class Units extends StatefulWidget {
  const Units({super.key});

  @override
  State<Units> createState() => _UnitsState();
}

class _UnitsState extends State<Units> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'الوحدات'),
      drawer: const CustomDrawer(),
      body: FutureBuilder(
        future: API.get(path: 'units'),
        builder: (context, AsyncSnapshot snapshot) {
          List data = snapshot.hasData ? snapshot.data['data'] : [];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (data.isNotEmpty) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: List.generate(
                data.length,
                (index) => CustomListTile(
                    title: '${data[index]['title']}',
                    subTitle: '${data[index]['user']}'),
              ),
            );
          }
          return SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('unit-create'),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
