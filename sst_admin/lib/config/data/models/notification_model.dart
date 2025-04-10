import 'package:intl/intl.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final DateTime date;
  final Map<String, dynamic>? planDetails;
  final bool isPlan;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message, 
    required this.date,
    this.planDetails,
    this.isPlan = false,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? date,
    Map<String, dynamic>? planDetails,
    bool? isPlan,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      date: date ?? this.date,
      planDetails: planDetails ?? this.planDetails,
      isPlan: isPlan ?? this.isPlan,
    );
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id:
          map['id'] as String? ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: map['title'] as String,
      message: map['message'] as String,
      date: DateTime.parse(map['createdAt'] as String),
      isPlan: map['isPlan'] as bool? ?? false,
      planDetails: map['planDetails'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'createdAt': DateFormat("yyyy-MM-ddTHH:mm:ss").format(date),
      'isPlan': isPlan,
      'planDetails': planDetails,
    };
  }
}
