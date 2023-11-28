import 'package:flutter/material.dart';
import 'package:flutter_almajhoud/colors.dart';
import 'package:flutter_almajhoud/custom_widgets.dart';
import 'package:flutter_almajhoud/env.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'الوحدات'),
      drawer: const CustomDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          CustomListTile(
            title: 'وحدة',
            subTitle: 'ضابط',
          ),
          CustomListTile(
            title: 'وحدة',
            subTitle: 'ضابط',
          ),
          CustomListTile(
            title: 'وحدة',
            subTitle: 'ضابط',
          ),
          CustomListTile(
            title: 'وحدة',
            subTitle: 'ضابط',
          ),
          CustomListTile(
            title: 'وحدة',
            subTitle: 'ضابط',
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
