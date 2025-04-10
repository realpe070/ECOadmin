import 'package:flutter/material.dart';

class NotificationContent extends StatelessWidget {
  final VoidCallback onClose;

  const NotificationContent({required this.onClose, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Notificaciones',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0067AC)),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Replace with actual notification count
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text('Notificación $index'),
                    subtitle: const Text('Detalles de la notificación'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
