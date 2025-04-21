
import 'package:flutter/material.dart';

class EditActivitiesContent extends StatefulWidget {
  const EditActivitiesContent({super.key});

  @override
  State<EditActivitiesContent> createState() => _EditActivitiesContentState();
}

class _EditActivitiesContentState extends State<EditActivitiesContent> {
  // Simulación de datos - reemplazar con datos reales de tu API
  final List<Map<String, dynamic>> _activities = [
    {'id': '1', 'name': 'Estiramiento Cuello', 'category': 'Tren Superior'},
    {'id': '2', 'name': 'Rotación Hombros', 'category': 'Tren Superior'},
    {'id': '3', 'name': 'Flexión Rodillas', 'category': 'Tren Inferior'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0067AC).withAlpha(26),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Editar Actividades',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'HelveticaRounded',
              color: Color(0xFF0067AC),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: _activities.length,
              itemBuilder: (context, index) {
                final activity = _activities[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFC6DA23),
                      child: Icon(Icons.fitness_center, color: Colors.white),
                    ),
                    title: Text(
                      activity['name'],
                      style: const TextStyle(
                        fontFamily: 'HelveticaRounded',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      activity['category'],
                      style: const TextStyle(
                        fontFamily: 'HelveticaRounded',
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          color: const Color(0xFF0067AC),
                          onPressed: () => _showEditDialog(activity),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () => _showDeleteConfirmation(activity),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(Map<String, dynamic> activity) {
    // Implementar diálogo de edición
  }

  void _showDeleteConfirmation(Map<String, dynamic> activity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Desea eliminar la actividad "${activity['name']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: () {
              // Implementar eliminación
              Navigator.pop(context);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
