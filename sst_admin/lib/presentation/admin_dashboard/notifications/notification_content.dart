import 'package:flutter/material.dart';

class NotificationContent extends StatelessWidget {
  final VoidCallback onClose;

  const NotificationContent({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Próximamente - Notificaciones',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }
}
