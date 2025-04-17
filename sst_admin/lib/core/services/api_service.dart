import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final http.Client _client = http.Client();

  static Future<String> resolveBaseUrl() async {
    if (kDebugMode) {
      if (kIsWeb) {
        debugPrint('🌐 Modo Web detectado, usando localhost');
        return 'http://localhost:4300';
      }
      debugPrint('🖥️ Modo escritorio detectado, usando IP local');
      return 'http://192.168.0.107:4300'; // IP específica de tu máquina
    }
    return 'https://your-production-url.com';
  }

  Future<bool> verifyConnection() async {
    try {
      final baseUrl = await resolveBaseUrl();
      debugPrint('🔄 Intentando conectar a: $baseUrl');
      
      final response = await _client.get(
        Uri.parse('$baseUrl/admin'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 15));

      debugPrint('📡 Respuesta del servidor: ${response.statusCode}');
      debugPrint('📝 Cuerpo de respuesta: ${response.body}');
      
      // Aceptar 401 como una respuesta válida ya que el endpoint requiere autenticación
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
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      debugPrint('📡 Código de respuesta: ${response.statusCode}');
      final responseData = json.decode(response.body);
      debugPrint('📝 Respuesta: $responseData');

      if (responseData['status'] == true) {
        debugPrint('✅ Autenticación exitosa');
        return responseData;
      }
      
      throw Exception(responseData['message'] ?? 'Error de autenticación');
    } catch (e) {
      debugPrint('❌ Error en autenticación: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final baseUrl = await resolveBaseUrl();
      final user = await FirebaseAuth.instance.currentUser?.getIdToken();

      debugPrint('🔄 Realizando GET a: $baseUrl$endpoint');
      
      final response = await _client.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $user',
        },
      );

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
}