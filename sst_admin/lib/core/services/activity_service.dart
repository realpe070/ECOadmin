import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './api_service.dart';

class ActivityService {
  static Future<Map<String, dynamic>> createActivity({
    required String name,
    required String description,
    required int minTime,
    required int maxTime,
    required String category,
    required String videoUrl,
    required bool sensorEnabled,
  }) async {
    try {
      final baseUrl = await ApiService.resolveBaseUrl();
      final response = await http.post(
        Uri.parse('$baseUrl/admin/activities'),
        headers: {
          'Content-Type': 'application/json',
          // Aquí añadirías el token de autenticación
        },
        body: json.encode({
          'name': name,
          'description': description,
          'minTime': minTime,
          'maxTime': maxTime,
          'category': category,
          'videoUrl': videoUrl,
          'sensorEnabled': sensorEnabled,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return json.decode(response.body);
      }
      
      throw Exception(json.decode(response.body)['message'] ?? 'Error al crear actividad');
    } catch (e) {
      debugPrint('Error creando actividad: $e');
      rethrow;
    }
  }
}
