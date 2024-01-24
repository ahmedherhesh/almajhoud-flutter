import "dart:convert";

import "package:flutter_almajhoud/env.dart";
import "package:flutter_almajhoud/functions.dart";
import "package:http/http.dart" as http;

class API {
  static String url = mainUrl;
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${sessionUser!['token']}'
  };
  static bool loading = true;
  static response(
      {response, bool showDialog = true, bool cached = false, String? path}) {
    if (!cached && ['users', 'violations'].contains('$path')) {
      sharedPreferences!.setString('$path', response.body);
    }
    var body = jsonDecode(response.body);
    if (response.statusCode >= 500) {
      if (showDialog) {
        customDialog(
          title: 'خطأ برمجي',
          middleText: "يرجى الانتظار حتى يقوم الدعم الفني بحل المشكلة",
        );
      }
    } else if (response.statusCode == 404) {
      if (showDialog) {
        customDialog(
          title: 'خطأ ',
          middleText: "هذه الصفحة غير موجوده",
        );
      }
    }
    // if (response.statusCode != 200) return {'status': response.statusCode};

    if (response.statusCode == 422) {
      String text = validationMsgs(response.body);
      if (showDialog) {
        customDialog(title: 'خطأ في البيانات المدخلة ', middleText: text);
      }
    }
    if (response.body.contains('status') && body['status'] == 400) {
      if (showDialog) customDialog(title: 'تنبيه', middleText: body['msg']);
    } else if (response.body.contains('status') && body['status'] == 403) {
      if (showDialog) customDialog(title: 'تنبيه', middleText: body['msg']);
    }

    return body;
  }

  static Future get(
      {String? path, bool showDialog = true, bool cached = false}) async {
    var url = Uri.parse('${API.url}/$path');
    String? dataOfCached = sharedPreferences!.getString('$path');
    if (cached) {
      if (dataOfCached != null) return jsonDecode(dataOfCached);
    }
    var response = await http.get(url, headers: headers);
    return API.response(
      response: response,
      showDialog: showDialog,
      path: path,
      cached: cached,
    );
  }

  static Future post({String? path, Map? body, bool showDialog = true}) async {
    var url = Uri.parse('${API.url}/$path');
    var response = await http.post(url, body: body, headers: headers);
    return API.response(response: response, showDialog: showDialog);
  }

  static Future put({String? path, Map? body, bool showDialog = true}) async {
    var url = Uri.parse('${API.url}/$path');
    var response = await http.put(url, body: body, headers: headers);
    return API.response(response: response, showDialog: showDialog);
  }

  static Future delete({String? path, bool showDialog = true}) async {
    var url = Uri.parse('${API.url}/$path');
    var response = await http.delete(url, headers: headers);
    return API.response(response: response, showDialog: showDialog);
  }
}
