import 'package:flutter/material.dart';

class ActivityPlanContent extends StatelessWidget {
  final VoidCallback onClose;

  const ActivityPlanContent({required this.onClose, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Plan de Actividades',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0067AC)),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 5, // Replace with actual activity plan count
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text('Plan de Actividad $index'),
                    subtitle: const Text('Detalles del plan de actividad'),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: onClose,
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
