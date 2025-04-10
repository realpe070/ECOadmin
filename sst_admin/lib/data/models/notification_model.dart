class NotificationModel {
  final String id;
  final String title;
  final String message;
  final DateTime date;
  final bool isPlan;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    this.isPlan = false,
  });
}
