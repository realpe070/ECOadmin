import '../../data/models/notification_model.dart';
import '../../data/repositories/notifications_repository.dart';

class CreateNotificationUseCase {
  final NotificationsRepository repository;

  CreateNotificationUseCase(this.repository);

  Future<void> call(NotificationModel notification) async {
    await repository.createNotification(notification);
  }
}
