import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static Future<String> resolveBaseUrl() async {
    return 'http://localhost:4300/api';
  }

  Future<Map<String, dynamic>?> postRequest(String endpoint, Map<String, dynamic> data) async {
    final baseUrl = await resolveBaseUrl();
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }
}
