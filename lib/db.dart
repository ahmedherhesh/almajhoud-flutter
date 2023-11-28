import "package:http/http.dart" as http;

class DB {
  String url = 'http://192.168.43.90/almajhoud/public/api/v1';
  get(String path, Map? body) {
    var url = Uri.parse('${this.url}/login');
    var response = http.get(url,body);
  }

  post() {}
  put() {}
  delete() {}
}
