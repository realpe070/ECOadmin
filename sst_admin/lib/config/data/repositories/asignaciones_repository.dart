import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AsignacionesRepository {
  final FirebaseFirestore _firestore;

  AsignacionesRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<Map<DateTime, Map<String, dynamic>>> fetchAssignedActivities() async {
    final snapshot = await _firestore.collection('asignaciones').get();
    Map<DateTime, Map<String, dynamic>> fetchedActivities = {};

    for (var doc in snapshot.docs) {
      DateTime date = DateFormat('dd/MM/yyyy', 'es_ES').parse(doc['fecha']);
      String colorHex =
          doc.data().containsKey('color') ? doc['color'] : '0xFF800080';

      fetchedActivities[date] = {
        'nombreActividad': doc['nombreActividad'],
        'color': colorHex,
        'videoUrl': doc['videoUrl'],
        'informacion': doc['informacion'],
        'materiales': doc['materiales'],
        'secuencia': doc['secuencia'],
      };
    }
    return fetchedActivities;
  }

  Future<void> asignarActividad({
    required DateTime fecha,
    required String nombreActividad,
    required String videoUrl,
    required String informacion,
    required List<String> materiales,
    required List<String> secuencia,
    required String color,
  }) async {
    final formattedDate = DateFormat('dd/MM/yyyy', 'es_ES').format(fecha);
    await _firestore.collection('asignaciones').add({
      'fecha': formattedDate,
      'nombreActividad': nombreActividad,
      'videoUrl': videoUrl,
      'informacion': informacion,
      'materiales': materiales,
      'secuencia': secuencia,
      'color': color,
    });
  }

  Future<void> eliminarActividad(DateTime fecha) async {
    final formattedDate = DateFormat('dd/MM/yyyy', 'es_ES').format(fecha);
    var snapshot =
        await _firestore
            .collection('asignaciones')
            .where('fecha', isEqualTo: formattedDate)
            .get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}
