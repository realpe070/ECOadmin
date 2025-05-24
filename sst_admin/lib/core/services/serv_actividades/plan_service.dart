import 'package:flutter/foundation.dart';
import '../api_service.dart';
import '../serv_users/auth_service.dart';
import 'notification_service.dart';
import 'dart:convert';

class PlanService {
  static Future<Map<String, dynamic>> createPlan({
    required String name,
    required String description,
    required List<Map<String, dynamic>> activities,
  }) async {
    try {
      // Validaciones
      if (name.isEmpty) {
        throw Exception('El nombre del plan es requerido');
      }
      if (description.isEmpty) {
        throw Exception('La descripción del plan es requerida');
      }
      if (activities.isEmpty) {
        throw Exception('Debe seleccionar al menos una actividad');
      }

      // Validar que todas las actividades tengan ID
      for (var activity in activities) {
        if (!activity.containsKey('id') || activity['id'] == null) {
          throw Exception('Actividad inválida detectada');
        }
      }

      debugPrint('📝 Iniciando creación de plan...');
      debugPrint('📋 Datos a enviar:');
      debugPrint('- Nombre: $name');
      debugPrint('- Descripción: ${description.length} caracteres');
      debugPrint('- Actividades: ${activities.length}');

      final token = await AuthService.getAdminToken();
      if (token == null) {
        throw Exception('No se encontró un token de administrador');
      }

      final planData = {
        'name': name.trim(),
        'description': description.trim(),
        'activities': activities.map((activity) => {
          'activityId': activity['id'],
          'order': activities.indexOf(activity),
        }).toList(),
        'createdAt': DateTime.now().toIso8601String(),
      };

      debugPrint('📦 Enviando datos al servidor: $planData');

      final response = await ApiService().post(
        endpoint: '/admin/plans',
        data: planData,
        token: token,
      );

      if (response['status'] != true) {
        throw Exception(response['message'] ?? 'Error creando el plan');
      }

      debugPrint('✅ Plan creado exitosamente');
      return response;
    } catch (e, stackTrace) {
      debugPrint('❌ Error creando plan: $e');
      debugPrint('📚 StackTrace: $stackTrace');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> createPausePlan(Map<String, dynamic> planData) async {
    try {
      debugPrint('🔄 Iniciando creación de plan de pausas...');
      debugPrint('📦 Datos del plan: ${json.encode(planData)}');
      
      final token = await AuthService.getAdminToken();
      if (token == null) {
        throw Exception('No se encontró un token de administrador');
      }

      final response = await ApiService().post(
        endpoint: '/admin/pause-plans',
        data: planData,
        token: token,
      );

      if (response['status'] == true) {
        debugPrint('✅ Plan de pausas creado exitosamente');
        debugPrint('📎 ID del plan: ${response['data']['id']}');
        
        // Notificar al servicio de notificaciones
        try {
          await NotificationService().onPausePlanCreated(response['data']);
          debugPrint('✅ Plan sincronizado con notificaciones');
        } catch (e) {
          debugPrint('⚠️ Error al sincronizar con notificaciones: $e');
        }
        
        return response;
      }
      
      throw Exception(response['message']);
    } catch (e) {
      debugPrint('❌ Error creando plan de pausas: $e');
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> getPlans() async {
    try {
      debugPrint('📝 Solicitando lista de planes...');
      
      final token = await AuthService.getAdminToken();
      if (token == null) {
        throw Exception('No se encontró un token de administrador');
      }

      final response = await ApiService().get(
        '/admin/plans',
        query: {'includeDetails': 'true'}, // Solicitar detalles completos
      );
      
      if (response['status'] == true && response['data'] != null) {
        final plans = List<Map<String, dynamic>>.from(response['data']);
        debugPrint('✅ Planes cargados: ${plans.length}');
        return plans;
      }

      return [];
    } catch (e) {
      debugPrint('❌ Error obteniendo planes: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> updatePlan({
    required String id,
    required Map<String, dynamic> plan,
  }) async {
    try {
      debugPrint('📝 Actualizando plan $id...');
      
      final token = await AuthService.getAdminToken();
      if (token == null) {
        throw Exception('No se encontró un token de administrador');
      }

      // Preparar datos en el formato correcto
      final planData = {
        'name': plan['name'],
        'description': plan['description'],
        'activities': (plan['activities'] as List).map((activity) => {
          'activityId': activity['activityId'] ?? activity['id'],
          'order': activity['order'],
        }).toList(),
      };

      debugPrint('📦 Datos a enviar: $planData');

      final response = await ApiService().put(
        endpoint: '/admin/plans/$id', // Corregido el endpoint
        data: planData,
        token: token,
      );

      if (response['status'] != true) {
        throw Exception(response['message'] ?? 'Error actualizando el plan');
      }

      return response;
    } catch (e) {
      debugPrint('❌ Error actualizando plan: $e');
      rethrow;
    }
  }

  static Future<void> deletePlan(String id) async {
    try {
      debugPrint('🗑️ Eliminando plan $id...');
      
      final token = await AuthService.getAdminToken();
      if (token == null) {
        throw Exception('No se encontró un token de administrador');
      }

      final response = await ApiService().delete(
        endpoint: '/admin/plans/$id',
        token: token,
      );

      if (response['status'] != true) {
        throw Exception(response['message'] ?? 'Error eliminando el plan');
      }

      debugPrint('✅ Plan eliminado exitosamente');
    } catch (e) {
      debugPrint('❌ Error eliminando plan: $e');
      rethrow;
    }
  }
}
