import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'serv_users/auth_service.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final http.Client _client = http.Client();
  final Duration _timeout = const Duration(seconds: 30);

  static Future<String> resolveBaseUrl() async {
    if (kDebugMode) {
      if (kIsWeb) {
        debugPrint('🌐 Modo Web detectado, usando localhost:4300');
        return 'http://localhost:4300'; // Corregido para usar siempre 4300
      }
      debugPrint('🖥️ Modo escritorio detectado, usando IP local');
      return 'http://localhost:4300'; // Corregido para usar siempre 4300
    }
    return 'https://your-production-url.com';
  }

  Future<bool> verifyConnection() async {
    try {
      final baseUrl = await resolveBaseUrl();
      debugPrint('🔄 Intentando conectar a: $baseUrl');
      
      final response = await _client.get(
        Uri.parse('$baseUrl/admin'),
        headers: {
          'Content-Type': 'application/json',
          'Origin': kIsWeb ? 'http://localhost:3000' : 'http://localhost:4300',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      debugPrint('📡 Respuesta del servidor: ${response.statusCode}');
      debugPrint('📝 Cuerpo de respuesta: ${response.body}');
      
      return response.statusCode == 401 || (response.statusCode >= 200 && response.statusCode < 500);
    } catch (e) {
      debugPrint('❌ Error de conexión: ${e.toString()}');
      return false;
    }
  }

  Future<Map<String, dynamic>> authenticateAdmin(String email, String password) async {
    try {
      final baseUrl = await resolveBaseUrl();
      debugPrint('🔐 Intentando autenticar admin en: $baseUrl/admin/login');
      
      final response = await _client.post(
        Uri.parse('$baseUrl/admin/login'),
        headers: {
          'Content-Type': 'application/json',
          'Origin': kIsWeb ? 'http://localhost:3000' : 'http://localhost:4300',
          'Accept': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      ).timeout(_timeout);

      debugPrint('📡 Código de respuesta: ${response.statusCode}');
      final responseData = json.decode(response.body);
      debugPrint('📝 Respuesta: $responseData');

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData['status'] == true) {
          debugPrint('✅ Autenticación exitosa');
          return responseData;
        }
      }
      
      throw Exception(responseData['message'] ?? 'Error de autenticación');
    } catch (e, stackTrace) {
      debugPrint('❌ Error en autenticación: $e');
      debugPrint('📚 Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? query,
  }) async {
    try {
      final baseUrl = await resolveBaseUrl();
      final token = await AuthService.getAdminToken();
      
      if (token == null) {
        throw Exception('No se encontró token de autenticación');
      }

      final Uri uri = Uri.parse('$baseUrl$endpoint').replace(
        queryParameters: query,
      );

      debugPrint('🔄 Realizando GET a: $uri');
      debugPrint('🔑 Usando token: ${token.substring(0, 20)}...');
      
      final response = await _client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          ...?headers,
        },
      ).timeout(_timeout);

      debugPrint('📡 Código de respuesta: ${response.statusCode}');
      debugPrint('📝 Cuerpo de respuesta: ${response.body}');

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        if (decodedResponse['status'] == true) {
          return decodedResponse;
        }
        throw Exception(decodedResponse['message'] ?? 'Error en la respuesta del servidor');
      }
      
      throw Exception('Error ${response.statusCode}: ${response.body}');
    } catch (e) {
      debugPrint('❌ Error en petición GET: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> post({
    required String endpoint,
    required Map<String, dynamic> data,
    required String token,
  }) async {
    try {
      final baseUrl = await resolveBaseUrl();
      debugPrint('🔄 POST request to: $baseUrl$endpoint');
      debugPrint('📦 Data: $data');
      
      final response = await _client.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(data),
      ).timeout(_timeout);

      final responseData = json.decode(response.body);
      debugPrint('📡 Response status: ${response.statusCode}');
      debugPrint('📝 Response data: $responseData');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return responseData;
      }
      
      throw Exception(responseData['message'] ?? 'Error en la operación');
    } catch (e) {
      debugPrint('❌ Error en POST request: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> put({
    required String endpoint,
    required Map<String, dynamic> data,
    required String token,
  }) async {
    try {
      final baseUrl = await resolveBaseUrl();
      final uri = Uri.parse('$baseUrl$endpoint');
      
      debugPrint('🔄 PUT request to: $uri');
      debugPrint('📦 Data: $data');
      debugPrint('🔑 Using token: ${token.substring(0, 20)}...');

      final response = await _client.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: json.encode(data),
      ).timeout(_timeout);

      final responseData = json.decode(response.body);
      debugPrint('📡 Response status: ${response.statusCode}');
      debugPrint('📝 Response data: $responseData');

      if (response.statusCode == 200) {
        return responseData;
      }
      
      throw Exception(responseData['message'] ?? 'Error en la operación PUT');
    } catch (e) {
      debugPrint('❌ Error en PUT request: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> delete({
    required String endpoint,
    required String token,
  }) async {
    try {
      final baseUrl = await resolveBaseUrl();
      debugPrint('🗑️ DELETE request to: $baseUrl$endpoint');
      
      final response = await _client.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(_timeout);

      if (response.statusCode == 204) {
        return {'status': true};
      }

      final responseData = json.decode(response.body);
      debugPrint('📡 Response status: ${response.statusCode}');
      debugPrint('📝 Response data: $responseData');

      if (response.statusCode == 200) {
        return responseData;
      }
      
      throw Exception(responseData['message'] ?? 'Error en la operación');
    } catch (e) {
      debugPrint('❌ Error en DELETE request: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createActivity(String token, Map<String, dynamic> activityData) async {
    try {
      final baseUrl = await resolveBaseUrl();
      
      final response = await _client.post(
        Uri.parse('$baseUrl/admin/activities'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(activityData),
      ).timeout(_timeout);

      final responseData = json.decode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (responseData['status'] == true) {
          return responseData;
        }
      }
      
      throw Exception(responseData['message'] ?? 'Error al crear actividad');
    } catch (e, stackTrace) {
      debugPrint('❌ Error en createActivity: $e');
      debugPrint('📚 Stack trace: $stackTrace');
      rethrow;
    }
  }
}