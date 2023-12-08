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
  static response(response) {
    if (response.statusCode >= 500) {
      customDialog(
        title: 'خطأ برمجي',
        middleText: "يرجى الانتظار حتى يقوم الدعم الفني بحل المشكلة",
      );
    }
    if (response.statusCode == 404) {
      customDialog(
        title: 'خطأ ',
        middleText: "هذه الصفحة غير موجوده",
      );
    }
    if (response.statusCode != 200) return {'status': response.statusCode};

    var body = jsonDecode(response.body);
    if (response.statusCode == 422) {
      String text = validationMsgs(response.body);
      customDialog(title: 'خطأ في البيانات المدخلة ', middleText: text);
    }
    if (body['status'] == 400) {
      customDialog(title: 'تنبيه', middleText: body['msg']);
    }
    return body;
  }

  static Future get({String? path}) async {
    loading = true;
    var url = Uri.parse('${API.url}/$path');
    var response = await http.get(url, headers: headers);
    loading = false;

    return API.response(response);
  }

  static Future post({String? path, Map? body}) async {
    var url = Uri.parse('${API.url}/$path');
    var response = await http.post(url, body: body, headers: headers);
    return API.response(response);
  }

  static Future put({String? path, Map? body}) async {
    var url = Uri.parse('${API.url}/$path');
    var response = await http.put(url, body: body, headers: headers);
    return API.response(response);
  }

  static Future delete({String? path}) async {
    var url = Uri.parse('${API.url}/$path');
    var response = await http.delete(url, headers: headers);
    return API.response(response);
  }
}
