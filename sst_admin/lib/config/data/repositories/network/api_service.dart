import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = "http://localhost:4300";

  // Método genérico para enviar peticiones HTTP
  Future<Map<String, dynamic>?> postRequest(
      String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/$endpoint"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }
}
