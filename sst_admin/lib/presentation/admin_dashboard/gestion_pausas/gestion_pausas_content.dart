import 'package:flutter/material.dart';

class GestionPausasContent extends StatelessWidget {
  final VoidCallback onClose;

  const GestionPausasContent({required this.onClose, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Gestión de Pausas Activas',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0067AC)
            ),
          ),
          const SizedBox(height: 16),
          // Add your existing pause management content here
        ],
      ),
    );
  }
}
