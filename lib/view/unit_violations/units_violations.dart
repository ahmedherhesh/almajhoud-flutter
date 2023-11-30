import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_almajhoud/api.dart';
import 'package:flutter_almajhoud/colors.dart';
import 'package:flutter_almajhoud/custom_widgets.dart';
import 'package:get/get.dart';

class UnitsViolations extends StatefulWidget {
  const UnitsViolations({super.key});

  @override
  State<UnitsViolations> createState() => _UnitsViolationsState();
}

class _UnitsViolationsState extends State<UnitsViolations> {
  var args = Get.arguments;
  Map request = {'from': '', 'to': ''};
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
                      },
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                        (states) => primaryColor,
                      ),
                    ),
                    onPressed: () {
                      print(request);
                      setState(() => request);
                    },
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: API.get(
                path:
                    'unit-violations?from=${request['from']}&to=${request['from']}',
              ),
              builder: (context, AsyncSnapshot snapshot) {
                List data = snapshot.hasData ? snapshot.data['data'] : [];
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
