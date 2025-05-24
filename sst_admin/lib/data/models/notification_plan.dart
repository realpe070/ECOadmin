import 'package:flutter/foundation.dart';

class NotificationPlan {
  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final String time;
  final Map<DateTime, List<Map<String, dynamic>>> assignedPlans;
  final DateTime createdAt;
  bool isActive;
  bool isLoading; // Nueva propiedad

  NotificationPlan({
    this.id = '',
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.time,
    required this.assignedPlans,
    DateTime? createdAt,
    this.isActive = true,
    this.isLoading = false, // Inicializar nueva propiedad
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    final assignedPlansJson = assignedPlans.map((key, value) => MapEntry(
      key.toIso8601String(),
      value.map((plan) => {
        'id': plan['id'],
        'name': plan['name'],
        'time': plan['time'],
        'color': plan['color'].toString(),
      }).toList(),
    ));

    return {
      'name': name,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'time': time,
      'assignedPlans': assignedPlansJson,
      'isActive': isActive,
    };
  }

  factory NotificationPlan.fromJson(Map<String, dynamic> json) {
    try {
      return NotificationPlan(
        id: json['id'] ?? '',
        name: json['name'],
        startDate: DateTime.parse(json['startDate']),
        endDate: DateTime.parse(json['endDate']),
        time: json['time'],
        createdAt: DateTime.parse(json['createdAt']),
        isActive: json['isActive'] ?? true,
        assignedPlans: (json['assignedPlans'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(
            DateTime.parse(key),
            List<Map<String, dynamic>>.from(value),
          ),
        ),
      );
    } catch (e) {
      debugPrint('❌ Error parsing NotificationPlan: $e');
      rethrow;
    }
  }
}
