import 'package:flutter/foundation.dart';
import './api_service.dart';
import './serv_users/auth_service.dart';

class ProcessUploadService {
  static final ProcessUploadService _instance = ProcessUploadService._internal();
  factory ProcessUploadService() => _instance;
  ProcessUploadService._internal();

  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> uploadProcess({
    required String groupId,
    required String processName,
    required List<String> pausePlanIds,
  }) async {
    try {
      debugPrint('🔄 Subiendo proceso...');
      final token = await AuthService.getAdminToken();
      
      if (token == null) {
        throw Exception('No autorizado');
      }

      final response = await _apiService.post(
        endpoint: '/admin/process-upload',
        data: {
          'groupId': groupId,
          'processName': processName,
          'pausePlanIds': pausePlanIds,
        },
        token: token,
      );

      if (response['status'] == true) {
        debugPrint('✅ Proceso subido exitosamente');
        return response['data'];
      }
      
      throw Exception(response['message'] ?? 'Error subiendo proceso');
    } catch (e) {
      debugPrint('❌ Error en uploadProcess: $e');
      rethrow;
    }
  }
}
