import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/env_config.dart';

class HttpService {
  final String baseUrl;
  final Map<String, String> defaultHeaders;

  HttpService({
    String? baseUrl,
    Map<String, String>? headers,
  })  : baseUrl = baseUrl ?? EnvConfig.apiBaseUrl,
        defaultHeaders = headers ?? {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        };

  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/$endpoint'),
            headers: {...defaultHeaders, ...?headers},
          )
          .timeout(EnvConfig.timeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> post(String endpoint,
      {dynamic body, Map<String, String>? headers}) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/$endpoint'),
            headers: {...defaultHeaders, ...?headers},
            body: json.encode(body),
          )
          .timeout(EnvConfig.timeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw HttpException('Error ${response.statusCode}: ${response.body}');
    }
  }

  Exception _handleError(dynamic error) {
    if (error is Exception) {
      return error;
    }
    return Exception('An unexpected error occurred: $error');
  }
}
