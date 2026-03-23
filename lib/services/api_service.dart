import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  Future<dynamic> get(String url, {int? id}) async {
    final response = await http.get(Uri.parse(url));
    return _handleResponse(response);
  }

  Future<dynamic> post(
    String url,
    Map<String, dynamic> body, {
    int? userId,
    String? role,
  }) async {
    final requestBody = {...body, "user_id": ?userId, "role": ?role};
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(requestBody),
    );
    return _handleResponse(response);
  }

  Future<dynamic> _handleResponse(http.Response response) async {
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data["message"] ?? "api error");
    }
  }
}
