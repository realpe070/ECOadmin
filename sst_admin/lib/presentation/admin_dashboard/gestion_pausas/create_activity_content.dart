import 'package:flutter/material.dart';

class CreateActivityContent extends StatelessWidget {
  final VoidCallback onClose;

  const CreateActivityContent({required this.onClose, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Crear Nueva Actividad',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          // ...add form fields for activity creation...
          ElevatedButton(
            onPressed: onClose,
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
