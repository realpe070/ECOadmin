import 'package:flutter/material.dart';

class HistorialContent extends StatelessWidget {
  final VoidCallback onClose;

  const HistorialContent({required this.onClose, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Historial',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0067AC),
            ),
          ),
          const SizedBox(height: 16),
          // Add your historial content here
          ElevatedButton(
            onPressed: onClose,
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
