import 'package:flutter/foundation.dart';
import 'dart:convert';
import '../../../data/models/notification_model.dart';
import '../../../data/models/notification_plan.dart';
import '../api_service.dart';
import '../serv_users/auth_service.dart';

class NotificationService {
  final ApiService _apiService;

  NotificationService([ApiService? apiService]) 
    : _apiService = apiService ?? ApiService();

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final token = await AuthService.getAdminToken();
      if (token == null) throw Exception('No autorizado');

      final response = await _apiService.get('/admin/notifications');
      
      if (response['status'] == true && response['data'] != null) {
        return (response['data'] as List)
            .map((item) => NotificationModel.fromJson(item))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('❌ Error getting notifications: $e');
      rethrow;
    }
  }

  Future<List<NotificationPlan>> getNotificationPlans() async {
    try {
      final token = await AuthService.getAdminToken();
      if (token == null) throw Exception('No autorizado');

      // Cambiar la llamada para usar Authorization en el query
      final response = await _apiService.get(
        '/admin/notification-plans',
        query: {'token': token},  // Usar query en lugar de headers
      );
      
      if (response['status'] == true && response['data'] != null) {
        return (response['data'] as List)
            .map((item) => NotificationPlan.fromJson(item))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('❌ Error getting notification plans: $e');
      rethrow;
    }
  }

  Future<NotificationPlan> createNotificationPlan(NotificationPlan plan) async {
    try {
      final token = await AuthService.getAdminToken();
      if (token == null) throw Exception('No autorizado');

      debugPrint('📤 Enviando plan al servidor: ${plan.toJson()}');
      
      final response = await _apiService.post(
        endpoint: '/admin/notification-plans',
        data: plan.toJson(),
        token: token,
      );

      if (response['status'] == true && response['data'] != null) {
        debugPrint('✅ Plan creado exitosamente');
        return NotificationPlan.fromJson(response['data']);
      }
      throw Exception(response['message'] ?? 'Error al crear plan de notificación');
    } catch (e) {
      debugPrint('❌ Error creating notification plan: $e');
      rethrow;
    }
  }

  Future<void> updateNotificationPlanStatus(String planId, bool isActive) async {
    try {
      debugPrint('🔄 Actualizando estado del plan $planId a: $isActive');
      
      final token = await AuthService.getAdminToken();
      if (token == null) throw Exception('No autorizado');

      final response = await _apiService.put(
        endpoint: '/admin/notification-plans/$planId/status',
        data: {'isActive': isActive},
        token: token,
      );

      if (response['status'] != true) {
        throw Exception(response['message'] ?? 'Error actualizando estado');
      }

      debugPrint('✅ Estado actualizado correctamente');
    } catch (e) {
      debugPrint('❌ Error updating notification plan status: $e');
      rethrow;
    }
  }

  Future<NotificationModel> createNotification({
    required String title,
    required String message,
    required String type,
    DateTime? scheduledFor,
    String? time,
    List<String>? targetUsers,
  }) async {
    try {
      final token = await AuthService.getAdminToken();
      if (token == null) throw Exception('No autorizado');

      final response = await _apiService.post(
        endpoint: '/admin/notifications',
        data: {
          'title': title,
          'message': message,
          'type': type,
          'scheduledFor': scheduledFor?.toIso8601String(),
          'time': time,
          'targetUsers': targetUsers,
        },
        token: token,
      );

      if (response['status'] == true && response['data'] != null) {
        return NotificationModel.fromJson(response['data']);
      }
      throw Exception('Error al crear notificación');
    } catch (e) {
      debugPrint('❌ Error creating notification: $e');
      rethrow;
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      final token = await AuthService.getAdminToken();
      if (token == null) throw Exception('No autorizado');

      await _apiService.delete(
        endpoint: '/admin/notifications/$id',
        token: token,
      );
    } catch (e) {
      debugPrint('❌ Error deleting notification: $e');
      rethrow;
    }
  }

  Future<void> onPausePlanCreated(Map<String, dynamic> pausePlan) async {
    try {
      debugPrint('🔄 Procesando nuevo plan de pausas para notificaciones...');
      debugPrint('📦 Plan recibido: ${json.encode(pausePlan)}');

      // Crear plan de notificaciones automáticamente
      final notificationPlan = NotificationPlan(
        name: 'Recordatorios: ${pausePlan['name']}',
        startDate: DateTime.parse(pausePlan['startDate']),
        endDate: DateTime.parse(pausePlan['endDate']),
        time: pausePlan['time'],
        assignedPlans: {}, // Se llenarán manualmente desde la UI
      );

      final result = await createNotificationPlan(notificationPlan);
      debugPrint('✅ Plan de notificaciones creado: ${result.id}');
      debugPrint('📅 Período: ${result.startDate} - ${result.endDate}');
      
    } catch (e) {
      debugPrint('❌ Error en sincronización de planes: $e');
      rethrow;
    }
  }
}
