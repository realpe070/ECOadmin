import '../models/notification_model.dart';

class NotificationsRepository {
  final List<NotificationModel> _notifications = [];

  Future<void> createNotification(NotificationModel notification) async {
    _notifications.add(notification);
  }

  Future<List<NotificationModel>> getAllNotifications() async {
    return _notifications;
  }

  Future<void> updateNotification(NotificationModel updatedNotification) async {
    final index = _notifications.indexWhere(
      (n) => n.id == updatedNotification.id,
    );
    if (index != -1) {
      _notifications[index] = updatedNotification;
    }
  }

  Future<void> deleteNotification(String id) async {
    _notifications.removeWhere((n) => n.id == id);
  }
}
