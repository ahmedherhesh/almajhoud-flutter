import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_almajhoud/api.dart';
import 'package:flutter_almajhoud/custom_widgets.dart';
import 'package:flutter_almajhoud/functions.dart';
import 'package:get/get.dart';

class AllViolations extends StatefulWidget {
  const AllViolations({super.key});

  @override
  State<AllViolations> createState() => _AllViolationsState();
}

class _AllViolationsState extends State<AllViolations> {
  var args = Get.arguments;
  Map request = {'from': '', 'to': ''};
  List<dynamic> violations = [];
  void getViolations() async {
    violations = await API.get(path: 'violations');
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
                violations.isNotEmpty
                    ? CustomMultiSelect(
                        title: 'المخالفات',
                        data: violations,
                        initialValue: [],
                        onConfirm: (results) {},
                      )
                    : const SizedBox()
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: API.get(
                path:
                    'all-violations?from=${request['from']}&to=${request['to']}',
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
    );
  }
}
