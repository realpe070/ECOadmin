import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../api_service.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _storage = const FlutterSecureStorage();

  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  static Future<void> authenticateAdmin(String email, String password) async {
    try {
      final response = await ApiService().authenticateAdmin(email, password);
      if (response['status'] == true) {
        final token = response['data']['token'];
        await _storage.write(key: 'admin_token', value: token);
        debugPrint('✅ Token almacenado exitosamente');
      } else {
        throw Exception(response['message']);
      }
    } catch (e) {
      debugPrint('❌ Error en authenticateAdmin: $e');
      rethrow;
    }
  }

  static Future<String?> getAdminToken() async {
    try {
      // First try to get admin JWT token
      final adminToken = await _storage.read(key: 'admin_token');
      if (adminToken != null) {
        debugPrint('✅ Admin JWT token found');
        return adminToken;
      }

      // If no admin token, try Firebase token
      final firebaseToken = await _auth.currentUser?.getIdToken(true);
      if (firebaseToken != null) {
        debugPrint('✅ Firebase token found');
        return firebaseToken;
      }

      debugPrint('❌ No token found');
      return null;
    } catch (e) {
      debugPrint('❌ Error getting token: $e');
      return null;
    }
  }

  static Future<void> logout() async {
    try {
      await _storage.delete(key: 'admin_token');
      debugPrint('✅ Token eliminado exitosamente');
    } catch (e) {
      debugPrint('❌ Error en logout: $e');
      rethrow;
    }
  }
}
