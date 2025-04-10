import 'package:flutter/material.dart';

class EditActivitiesContent extends StatelessWidget {
  final VoidCallback onClose;

  const EditActivitiesContent({required this.onClose, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Editar Actividades',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          // ...add list of activities with edit and delete options...
          ElevatedButton(
            onPressed: onClose,
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
