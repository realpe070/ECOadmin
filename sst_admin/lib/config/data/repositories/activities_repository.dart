import 'package:cloud_firestore/cloud_firestore.dart';

class ActivitiesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> asignarActividad({
    required DateTime fecha,
    required String nombreActividad,
    required String videoUrl,
    required String informacion,
    required List<String> materiales,
    required List<String> secuencia,
    required String color,
  }) async {
    try {
      await _firestore.collection('actividades_asignadas').doc(fecha.toIso8601String()).set({
        'fecha': fecha.toIso8601String(),
        'nombreActividad': nombreActividad,
        'videoUrl': videoUrl,
        'informacion': informacion,
        'materiales': materiales,
        'secuencia': secuencia,
        'color': color,
      });
    } catch (e) {
      throw Exception('Error al asignar actividad: $e');
    }
  }

  Future<void> eliminarActividad(DateTime fecha) async {
    try {
      await _firestore.collection('actividades_asignadas').doc(fecha.toIso8601String()).delete();
    } catch (e) {
      throw Exception('Error al eliminar actividad: $e');
    }
  }

  Future<Map<DateTime, Map<String, dynamic>>> obtenerActividadesAsignadas() async {
    try {
      final snapshot = await _firestore.collection('actividades_asignadas').get();
      final Map<DateTime, Map<String, dynamic>> actividades = {};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final fecha = DateTime.parse(data['fecha']);
        actividades[fecha] = {
          'nombreActividad': data['nombreActividad'],
          'color': data['color'],
        };
      }

      return actividades;
    } catch (e) {
      throw Exception('Error al obtener actividades: $e');
    }
  }
}