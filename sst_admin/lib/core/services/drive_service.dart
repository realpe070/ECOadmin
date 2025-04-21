import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/api_service.dart';

class DriveService {
  static Future<List<Map<String, dynamic>>> getAllVideos() async {
    debugPrint('🎥 Iniciando getAllVideos()');
    try {
      final baseUrl = await ApiService.resolveBaseUrl();
      debugPrint('🌐 URL base: $baseUrl');
      
      // Obtener token de Firebase
      final user = FirebaseAuth.instance.currentUser;
      final token = await user?.getIdToken() ?? '';
      
      final response = await http.get(
        Uri.parse('$baseUrl/admin/drive/videos'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30)); // Aumentar timeout

      debugPrint('📡 Respuesta del servidor: ${response.statusCode}');
      debugPrint('📝 Datos recibidos: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final videos = List<Map<String, dynamic>>.from(data['files'] ?? []);
        debugPrint('✅ Videos obtenidos: ${videos.length}');
        return videos;
      }
      
      debugPrint('❌ Error: Status code ${response.statusCode}');
      return [];
    } catch (e, stackTrace) {
      debugPrint('❌ Error obteniendo videos: $e');
      debugPrint('📚 StackTrace: $stackTrace');
      return [];
    }
  }

  static String getVideoUrl(String fileId) {
    debugPrint('🎬 Generando URL para video: $fileId');
    final url = 'https://drive.google.com/uc?export=download&id=$fileId';
    debugPrint('🔗 URL generada: $url');
    return url;
  }

  static String getEmbedUrl(String fileId) {
    // Usamos el visor universal de Google Drive que soporta múltiples formatos
    return 'https://drive.google.com/file/d/$fileId/preview?usp=drivesdk';
  }

  static String getThumbnailUrl(String fileId) {
    // Usar la URL de thumbnail con el nuevo tamaño
    return 'https://drive.google.com/thumbnail?id=$fileId&sz=w400-h300-n';
  }

  static String getVideoName(Map<String, dynamic> video) {
    return video['name']?.toString().replaceAll('.mp4', '') ?? 'Video sin nombre';
  }

  static String? getStreamUrl(Map<String, dynamic> video) {
    final fileId = video['id'];
    // Priorizar el uso del visor de Drive que maneja mejor los diferentes formatos
    return getEmbedUrl(fileId);
  }

  static String? getVideoId(Map<String, dynamic> video) {
    return video['id'] as String?;
  }

  static Future<bool> validateDriveFile(String url) async {
    try {
      final fileId = getVideoId({'id': url});
      if (fileId == null) return false;

      final baseUrl = await ApiService.resolveBaseUrl();
      final user = FirebaseAuth.instance.currentUser;
      final token = await user?.getIdToken() ?? '';
      
      final response = await http.get(
        Uri.parse('$baseUrl/admin/drive/validate/$fileId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['valid'] ?? false;
      }
      return false;
    } catch (e) {
      debugPrint('Error validando archivo de Drive: $e');
      return false;
    }
  }
}
