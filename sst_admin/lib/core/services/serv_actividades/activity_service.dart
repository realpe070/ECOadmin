import 'package:flutter/foundation.dart';
import '../api_service.dart';
import '../serv_users/auth_service.dart';
import 'drive_service.dart';

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
      debugPrint('📝 Iniciando creación de actividad...');
      debugPrint('📋 Datos recibidos:');
      debugPrint('- Nombre: $name');
      debugPrint('- Descripción: ${description.length} caracteres');
      debugPrint('- Tiempo mínimo: $minTime segundos');
      debugPrint('- Tiempo máximo: $maxTime segundos');
      debugPrint('- Categoría: $category');
      debugPrint('- Video ID: $videoUrl');
      debugPrint('- Sensor: ${sensorEnabled ? "Activado" : "Desactivado"}');

      // Validaciones detalladas
      if (minTime <= 0) {
        throw Exception('El tiempo mínimo debe ser mayor a 0 segundos (recibido: $minTime)');
      }

      if (maxTime <= 0) {
        throw Exception('El tiempo máximo debe ser mayor a 0 segundos (recibido: $maxTime)');
      }

      if (maxTime <= minTime) {
        throw Exception('El tiempo máximo ($maxTime) debe ser mayor al tiempo mínimo ($minTime)');
      }

      // Validación adicional del ID del video
      if (videoUrl.isEmpty) {
        throw Exception('El ID del video es requerido');
      }

      // Limpiar y validar la URL del video
      final cleanVideoUrl = DriveService.cleanVideoUrl(videoUrl);

      final token = await AuthService.getAdminToken();
      if (token == null) {
        throw Exception('No se encontró un token de administrador');
      }

      final activityData = {
        'name': name,
        'description': description,
        'minTime': minTime,
        'maxTime': maxTime,
        'category': category,
        'videoUrl': cleanVideoUrl,
        'sensorEnabled': sensorEnabled,
        'createdAt': DateTime.now().toIso8601String(),
      };

      debugPrint('📦 Enviando datos al servidor: $activityData');

      final response = await ApiService().post(
        endpoint: '/admin/activities/create',
        data: activityData,
        token: token,
      );

      debugPrint('✅ Respuesta del servidor: $response');
      return response;
    } catch (e, stackTrace) {
      debugPrint('❌ Error creando actividad: $e');
      debugPrint('📚 StackTrace: $stackTrace');
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> getActivities() async {
    try {
      debugPrint('📝 Solicitando lista de actividades...');
      
      final token = await AuthService.getAdminToken();
      if (token == null) {
        throw Exception('No se encontró un token de administrador');
      }

      final response = await ApiService().get('/admin/activities');
      
      if (response['status'] == true && response['data'] != null) {
        return List<Map<String, dynamic>>.from(response['data']);
      }

      return [];
    } catch (e) {
      debugPrint('❌ Error obteniendo actividades: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> updateActivity({
    required String id,
    required String name,
    required String description,
    required int minTime,
    required int maxTime,
    required String category,
    required String videoUrl,
    required bool sensorEnabled,
  }) async {
    try {
      debugPrint('📝 Actualizando actividad $id...');
      
      final token = await AuthService.getAdminToken();
      if (token == null) {
        throw Exception('No se encontró un token de administrador');
      }

      final activityData = {
        'name': name,
        'description': description,
        'minTime': minTime,
        'maxTime': maxTime,
        'category': category,
        'videoUrl': videoUrl,
        'sensorEnabled': sensorEnabled,
        'updatedAt': DateTime.now().toIso8601String(), // Agregar timestamp de actualización
      };

      final response = await ApiService().put(
        endpoint: '/admin/activities/update/$id', // Modificado el endpoint
        data: activityData,
        token: token,
      );

      debugPrint('✅ Actividad actualizada exitosamente');
      return response;
    } catch (e) {
      debugPrint('❌ Error actualizando actividad: $e');
      rethrow;
    }
  }

  static Future<void> deleteActivity(String id) async {
    try {
      debugPrint('🗑️ Eliminando actividad $id...');
      
      final token = await AuthService.getAdminToken();
      if (token == null) {
        throw Exception('No se encontró un token de administrador');
      }

      await ApiService().delete(
        endpoint: '/admin/activities/$id',
        token: token,
      );

      debugPrint('✅ Actividad eliminada exitosamente');
    } catch (e) {
      debugPrint('❌ Error eliminando actividad: $e');
      rethrow;
    }
  }
}
