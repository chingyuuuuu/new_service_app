import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jkmapp/constants.dart';
//連接後端flask
class ApiService{
  //在flutter 當中請求api
  //由指定的api端點(http....)獲取jason data
  Future<Map<String, dynamic>> fetchData() async {
    final response = await http.get(Uri.parse('$baseUrl/api/data'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

}

