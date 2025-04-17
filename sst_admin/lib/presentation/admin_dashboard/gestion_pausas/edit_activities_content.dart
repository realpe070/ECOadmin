import 'package:flutter/material.dart';

class EditActivitiesContent extends StatelessWidget {
  final VoidCallback onClose;

  const EditActivitiesContent({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Próximamente - Editar Actividades',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }
}
