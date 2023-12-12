import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_almajhoud/api.dart';
import 'package:flutter_almajhoud/colors.dart';
import 'package:flutter_almajhoud/custom_widgets.dart';
import 'package:flutter_almajhoud/env.dart';
import 'package:flutter_almajhoud/functions.dart';
import 'package:get/get.dart';

class UnitViolations extends StatefulWidget {
  const UnitViolations({super.key});

  @override
  State<UnitViolations> createState() => _UnitViolationsState();
}

class _UnitViolationsState extends State<UnitViolations> {
  var args = Get.arguments;
  Map request = {'from': '', 'to': ''};
  @override
  void initState() {
    checkPermission('عرض مخالفات الوحدات');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: args['title']),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 30),
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: DateTimeFormField(
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        hintStyle: TextStyle(color: Colors.black45),
                        errorStyle: TextStyle(color: Colors.redAccent),
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.event_note),
                        labelText: 'من تاريخ',
                      ),
                      mode: DateTimeFieldPickerMode.date,
                      autovalidateMode: AutovalidateMode.always,
                      onDateSelected: (DateTime value) {
                        String val = "$value".split(' ')[0];
                        request['from'] = val;
                        setState(() => request);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: DateTimeFormField(
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        hintStyle: TextStyle(color: Colors.black45),
                        errorStyle: TextStyle(color: Colors.redAccent),
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.event_note),
                        labelText: 'إلى تاريخ',
                      ),
                      mode: DateTimeFieldPickerMode.date,
                      autovalidateMode: AutovalidateMode.always,
                      onDateSelected: (DateTime value) {
                        String val = "$value".split(' ')[0];
                        request['to'] = val;
                        setState(() => request);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: API.get(
                path:
                    'units/${args['unit_id']}?unit_id=${args['unit_id']}&from=${request['from']}&to=${request['to']}',
              ),
              builder: (context, AsyncSnapshot snapshot) {
                List data =
                    snapshot.hasData && snapshot.data.containsKey('data')
                        ? snapshot.data['data']
                        : [];
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CustomProgressIndicator();
                }
                if (data.isNotEmpty) {
                  bool canEdit = sessionUser!['permissions']
                      .contains('تعديل مخالفات الوحدات');
                  bool canDelete = sessionUser!['permissions']
                      .contains('حذف مخالفات الوحدات');
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          // boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 6)],
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Table(
                          border: TableBorder.all(
                            color: Colors.grey,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                          ),
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.top,
                          children: [
                            const TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text(
                                    'المخالفة',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text(
                                    'العدد',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text(
                                    '',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                            ...List.generate(
                              data.length,
                              (index) {
                                var el = data[index];
                                return TableRow(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Text(
                                        '${el['violation']}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Text(
                                        '${el['count']}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    canEdit || canDelete
                                        ? Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                sessionUser!['permissions']
                                                        .contains(
                                                            'تعديل مخالفات الوحدات')
                                                    ? IconButton(
                                                        onPressed: () async {
                                                          var result =
                                                              await Get.toNamed(
                                                            'unit-violation-update',
                                                            arguments: {
                                                              'unit_id':
                                                                  '${args['unit_id']}',
                                                              'violation_id':
                                                                  '${el['id']}',
                                                              'count':
                                                                  '${el['count']}',
                                                            },
                                                          );
                                                          if (result == 1)
                                                            setState(() {});
                                                        },
                                                        icon: const Icon(
                                                          Icons.edit_square,
                                                          color: primaryColor,
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                                sessionUser!['permissions']
                                                        .contains(
                                                            'حذف مخالفات الوحدات')
                                                    ? IconButton(
                                                        onPressed: () async {
                                                          customDialog(
                                                            title: 'تحذير',
                                                            middleText:
                                                                'هل انت متأكد من حذف هذه المخالفة',
                                                            confirm: () async {
                                                              var response =
                                                                  await API.delete(
                                                                      path:
                                                                          'unit-violations/${el['id']}');
                                                              if (response[
                                                                      'status'] ==
                                                                  200) {
                                                                setState(() {});
                                                                Get.back();
                                                              }
                                                            },
                                                          );
                                                        },
                                                        icon: const Icon(
                                                          Icons.delete,
                                                          color: primaryColor,
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                              ],
                                            ),
                                          )
                                        : const Text(
                                            '---',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                  ],
                                );
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
      floatingActionButton:
          sessionUser!['permissions'].contains('اضافة مخالفات الوحدات')
              ? FloatingActionButton(
                  onPressed: () async {
                    var result = await Get.toNamed(
                      'unit-violation-create',
                      arguments: {
                        'unit_id': '${args['unit_id']}',
                      },
                    );
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
