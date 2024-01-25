import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_almajhoud/api.dart';
import 'package:flutter_almajhoud/colors.dart';
import 'package:flutter_almajhoud/custom_widgets.dart';
import 'package:flutter_almajhoud/functions.dart';
import 'package:get/get.dart';

class CreateOfficerViolation extends StatefulWidget {
  const CreateOfficerViolation({super.key});

  @override
  State<CreateOfficerViolation> createState() => _CreateOfficerViolationState();
}

class _CreateOfficerViolationState extends State<CreateOfficerViolation> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  String? title;
  Map request = {};
  create() async {
    var formValid = formState.currentState!.validate();
    if (formValid) {
      var response = await API.post(path: 'officer-violations', body: request);
      if (response['status'] == 200) {
        Get.back(result: 1);
      }
    }
  }

  bool cached = true;
  Future onRefresh() async {
    cached = false;
    setState(() => cached);
  }

  String? selectedValue;
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    checkPermission('اضافة مخالفات');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Scaffold(
        appBar: appBar(
          title: 'تسجيل مخالفة',
          refreshBtn: IconButton(
            onPressed: onRefresh,
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  border: Border.all(color: primaryColor),
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: Form(
                  key: formState,
                  child: Column(
                    children: [
                      FutureBuilder(
                        future: API.get(path: 'violations', cached: cached),
                        builder: (context, AsyncSnapshot snapshot) {
                          List data =
                              snapshot.hasData ? snapshot.data['data'] : [];
                          return DropdownButton2(
                            hint: const Text('اختر نوع المخالفة'),
                            dropdownSearchData: DropdownSearchData(
                              searchController: textEditingController,
                              searchInnerWidgetHeight: 50,
                              searchInnerWidget: Container(
                                height: 50,
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  bottom: 4,
                                  right: 8,
                                  left: 8,
                                ),
                                child: TextFormField(
                                  expands: true,
                                  maxLines: null,
                                  controller: textEditingController,
                                  decoration: InputDecoration(
                                    // isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    hintText: 'بحث',
                                    hintStyle: const TextStyle(fontSize: 16),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        width: 1,
                                        style: BorderStyle.solid,
                                        color: Colors.transparent,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                              searchMatchFn: (item, searchValue) {
                                return item.child
                                    .toString()
                                    .contains(searchValue);
                              },
                            ),
                            //This to clear the search value when you close the menu
                            onMenuStateChange: (isOpen) {
                              if (!isOpen) {
                                textEditingController.clear();
                              }
                            },
                            items: List.generate(
                              data.length,
                              (index) {
                                var el = data[index];
                                return DropdownMenuItem(
                                  alignment: Alignment.center,
                                  value: '${el['id']}',
                                  child: Text('${el['title']}'),
                                );
                              },
                            ),
                            value: request['violation_id'],
                            onChanged: (val) {
                              request['violation_id'] = val.toString();
                              setState(() {});
                            },
                          );
                        },
                      ),
                      TextFormField(
                        validator: (val) {
                          val = val.toString();
                          if (val.isEmpty) {
                            return 'هذا الحقل لا يجب ان يكون فارغاً';
                          }
                          int count = int.parse(val);
                          if (count < 1) {
                            return 'يجب ان يكون العدد اكبر من صفر';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                          labelText: 'العدد',
                          contentPadding: EdgeInsets.only(top: 20, bottom: 20),
                          labelStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onChanged: (val) {
                          request['count'] = val.toString();
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          print(request);
                          create();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.only(
                              right: 40, left: 40, top: 10, bottom: 10),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.save,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'حفظ',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
