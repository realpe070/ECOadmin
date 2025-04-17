import 'package:flutter/material.dart';

class CreateActivityContent extends StatelessWidget {
  final VoidCallback onClose;

  const CreateActivityContent({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Próximamente - Crear Actividad',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }
}
