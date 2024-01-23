import 'dart:convert';
import 'dart:io';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_almajhoud/api.dart';
import 'package:flutter_almajhoud/custom_widgets.dart';
import 'package:flutter_almajhoud/env.dart';
import 'package:flutter_almajhoud/functions.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class AllViolations extends StatefulWidget {
  const AllViolations({super.key});

  @override
  State<AllViolations> createState() => _AllViolationsState();
}

class _AllViolationsState extends State<AllViolations> {
  var args = Get.arguments;
  Map request = {'from': '', 'to': ''};
  List initialValue = [];
  List exceptInitialValue = [];
  var violations;
  void getViolations() async {
    violations = await API.get(path: 'violations');
    setState(() => violations);
  }

  void downloadFile() async {
    var time = DateTime.now().millisecondsSinceEpoch;
    var path = '/storage/emulated/0/Download/$time.jpg';
    var file = File(path);
    var res = await get(Uri.parse(
        'http://www.shadowsphotography.co/wp-content/uploads/2017/12/photography-01-800x400.jpg'));
    file.writeAsBytes(res.bodyBytes);
  }

  @override
  void initState() {
    getViolations();
    checkPermission('عرض اجمالي المخالفات');
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
            height: 110,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
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
                              suffixIcon: Icon(Icons.event_note),
                              labelText: 'من تاريخ',
                              enabledBorder: OutlineInputBorder(),
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
                              hintStyle: TextStyle(color: Colors.black),
                              errorStyle: TextStyle(color: Colors.redAccent),
                              suffixIcon: Icon(Icons.event_note),
                              labelText: 'إلى تاريخ',
                              enabledBorder: OutlineInputBorder(),
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
                  violations != null
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CustomMultiSelect(
                                title: 'المخالفات',
                                items: List.generate(violations['data'].length,
                                    (index) {
                                  return MultiSelectItem(
                                    violations['data'][index]['id'],
                                    violations['data'][index]['title'],
                                  );
                                }),
                                initialValue: initialValue,
                                onConfirm: (results) {
                                  initialValue = results;
                                  request['inList'] = jsonEncode(results);
                                  setState(() => request);
                                  print(results);
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CustomMultiSelect(
                                title: 'المخالفات ما عدا',
                                items: List.generate(violations['data'].length,
                                    (index) {
                                  return MultiSelectItem(
                                    violations['data'][index]['id'],
                                    violations['data'][index]['title'],
                                  );
                                }),
                                initialValue: exceptInitialValue,
                                onConfirm: (results) {
                                  exceptInitialValue = results;
                                  request['notInList'] = jsonEncode(results);
                                  setState(() => request);
                                  print(results);
                                },
                              ),
                            )
                          ],
                        )
                      : const SizedBox()
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: API.get(
                path:
                    'all-violations?from=${request['from']}&to=${request['to']}&inList=${request['inList']}&notInList=${request['notInList']}',
              ),
              builder: (context, AsyncSnapshot snapshot) {
                List data =
                    snapshot.hasData && snapshot.data.containsKey('data')
                        ? snapshot.data['data']
                        : [];
                if (snapshot.connectionState == ConnectionState.waiting &&
                    data.isEmpty) {
                  return const CustomProgressIndicator();
                }
                if (data.isNotEmpty) {
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
                              ],
                            ),
                            ...List.generate(
                              data.length,
                              (index) {
                                return TableRow(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Text(
                                        '${data[index]['violation']}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Text(
                                        '${data[index]['count']}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 20),
                                      ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var now = DateTime.now();
          var path = '/storage/emulated/0/Download/$now.pdf';
          var file = File(path);
          var res = await get(
              Uri.parse(
                  '${mainUrl}/all-violations?from=${request['from']}&to=${request['to']}&inList=${request['inList']}&notInList=${request['notInList']}'),
              headers: {'Authorization': 'Bearer ${sessionUser!['token']}'});
          await file.writeAsBytes(res.bodyBytes);
        },
        child: const Icon(
          Icons.download,
          color: Colors.white,
        ),
      ),
    );
  }
}
