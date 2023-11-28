import "dart:convert";

import "package:flutter_almajhoud/env.dart";
import "package:http/http.dart" as http;

class API {
  static String url = 'http://192.168.43.90/almajhoud/public/api/v1';
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${sessionUser['token']}'
  };
  static response(response) {
    if (response.statusCode != 200) return;
    var body = jsonDecode(response.body);
    if (body['status'] == 200) {
      return body;
    }
    return [
      {'status': 400, 'msg': ''}
    ];
  }

  static get({String? path}) async {
    var url = Uri.parse('${API.url}/$path');
    var response = await http.get(url, headers: headers);
    return API.response(response);
  }

  static post({String? path, Map? body}) async {
    var url = Uri.parse('${API.url}/$path');
    var response = await http.post(url, body: body, headers: headers);
    return API.response(response);
  }

  static put({String? path, Map? body}) async {
    var url = Uri.parse('${API.url}/$path');
    var response = await http.put(url, body: body, headers: headers);
    return API.response(response);
  }

  static delete({String? path}) async {
    var url = Uri.parse('${API.url}/$path');
    var response = await http.delete(url, headers: headers);
    return API.response(response);
  }
}
