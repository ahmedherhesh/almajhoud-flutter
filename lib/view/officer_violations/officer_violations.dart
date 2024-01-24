import 'dart:convert';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_almajhoud/api.dart';
import 'package:flutter_almajhoud/colors.dart';
import 'package:flutter_almajhoud/custom_widgets.dart';
import 'package:flutter_almajhoud/env.dart';
import 'package:flutter_almajhoud/functions.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class OfficerViolations extends StatefulWidget {
  const OfficerViolations({super.key});

  @override
  State<OfficerViolations> createState() => _OfficerViolationsState();
}

class _OfficerViolationsState extends State<OfficerViolations> {
  var args = Get.arguments;
  Map request = {
    'from': '',
    'to': '',
    'inList': '',
    'notInList': '',
    'inUsers': ''
  };
  List initialValue = [];
  List exceptInitialValue = [];
  dynamic violations;
  void getViolations() async {
    violations = await API.get(path: 'violations', cached: cached);
    setState(() => violations);
  }

  onRefresh() async {
    cached = false;
    setState(() => cached);
  }

  @override
  void initState() {
    checkPermission('عرض مخالفات');
    getViolations();
    super.initState();
  }

  bool cached = true;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        onRefresh();
      },
      child: Scaffold(
        appBar: appBar(
          title: args['title'] ?? sessionUser!['name'],
          onRefresh: () async {
            onRefresh();
          },
        ),
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
                    violations != null
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: CustomMultiSelect(
                                  title: 'المخالفات',
                                  items: List.generate(
                                      violations['data'].length, (index) {
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
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CustomMultiSelect(
                                  title: 'المخالفات ما عدا',
                                  items: List.generate(
                                      violations['data'].length, (index) {
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
            violations != null
                ? Expanded(
                    child: FutureBuilder(
                      future: API.get(
                        path:
                            'users/${args['user_id'] ?? sessionUser!['id']}?from=${request['from']}&to=${request['to']}&inList=${request['inList']}&notInList=${request['notInList']}',
                      ),
                      builder: (context, AsyncSnapshot snapshot) {
                        List data = snapshot.hasData &&
                                snapshot.data.containsKey('data')
                            ? snapshot.data['data']
                            : [];
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CustomProgressIndicator();
                        }
                        if (data.isNotEmpty) {
                          bool canEdit = sessionUser!['permissions']
                              .contains('تعديل مخالفات');
                          bool canDelete = sessionUser!['permissions']
                              .contains('حذف مخالفات');
                          return ListView(
                            padding: const EdgeInsets.all(16),
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  // boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 6)],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                child: Table(
                                  border: TableBorder.all(
                                    color: Colors.grey,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                  ),
                                  defaultVerticalAlignment:
                                      TableCellVerticalAlignment.top,
                                  children: [
                                    TableRow(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(12),
                                          child: Text(
                                            'المخالفة',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(12),
                                          child: Text(
                                            'العدد',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        if (request['from'] == '' &&
                                            request['to'] == '')
                                          const Padding(
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
                                                style: const TextStyle(
                                                    fontSize: 20),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: Text(
                                                '${el['count']}',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontSize: 20),
                                              ),
                                            ),
                                            if (request['from'] == '' &&
                                                request['to'] == '')
                                              canEdit || canDelete
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          sessionUser![
                                                                      'permissions']
                                                                  .contains(
                                                                      'تعديل مخالفات')
                                                              ? IconButton(
                                                                  onPressed:
                                                                      () async {
                                                                    var result =
                                                                        await Get
                                                                            .toNamed(
                                                                      'edit-officer-violation',
                                                                      arguments: {
                                                                        'violation_id':
                                                                            '${el['id']}',
                                                                        'count':
                                                                            '${el['count']}',
                                                                      },
                                                                    );
                                                                    if (result ==
                                                                        1)
                                                                      setState(
                                                                          () {});
                                                                  },
                                                                  icon:
                                                                      const Icon(
                                                                    Icons
                                                                        .edit_square,
                                                                    color:
                                                                        primaryColor,
                                                                  ),
                                                                )
                                                              : const SizedBox(),
                                                          sessionUser![
                                                                      'permissions']
                                                                  .contains(
                                                                      'حذف مخالفات')
                                                              ? IconButton(
                                                                  onPressed:
                                                                      () async {
                                                                    customDialog(
                                                                      title:
                                                                          'تحذير',
                                                                      middleText:
                                                                          'هل انت متأكد من حذف هذه المخالفة',
                                                                      confirm:
                                                                          () async {
                                                                        var response =
                                                                            await API.delete(path: 'officer-violations/${el['id']}');
                                                                        if (response['status'] ==
                                                                            200) {
                                                                          setState(
                                                                              () {});
                                                                          Get.back();
                                                                        }
                                                                      },
                                                                    );
                                                                  },
                                                                  icon:
                                                                      const Icon(
                                                                    Icons
                                                                        .delete,
                                                                    color:
                                                                        primaryColor,
                                                                  ),
                                                                )
                                                              : const SizedBox(),
                                                        ],
                                                      ),
                                                    )
                                                  : const Text(
                                                      '---',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                  )
                : const SizedBox()
          ],
        ),
        floatingActionButton:
            sessionUser!['permissions'].contains('اضافة مخالفات')
                ? FloatingActionButton(
                    onPressed: () async {
                      var result = await Get.toNamed(
                        'create-officer-violation',
                      );
                      if (result == 1) setState(() {});
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
