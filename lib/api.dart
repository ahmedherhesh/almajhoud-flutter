import "dart:convert";

import "package:flutter_almajhoud/env.dart";
import "package:http/http.dart" as http;

class API {
  static String url = 'http://192.168.43.90/almajhoud/public/api/v1';
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${sessionUser['token']}'
  };
  static get({String? path}) async {
    var url = Uri.parse('${API.url}/$path');
    var response = await http.get(url, headers: headers);
    if (response.statusCode != 200) return;
    var body = jsonDecode(response.body);
    if (body['status'] == 200) {
      print(body);
      return body;
    }
  }

  post() {}
  put() {}
  delete() {}
}
