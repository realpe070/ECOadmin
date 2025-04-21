import 'package:flutter/material.dart';

class ActivityListContent extends StatelessWidget {
  const ActivityListContent({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulación de datos - reemplazar con datos reales
    final activities = [
      {
        'name': 'Estiramiento Cuello',
        'duration': '45 seg',
        'status': 'Activa',
      },
      {
        'name': 'Rotación Hombros',
        'duration': '30 seg',
        'status': 'Activa',
      },
    ];

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Lista de Actividades',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'HelveticaRounded',
                  color: Color(0xFF0067AC),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Implementar exportación
                },
                icon: const Icon(Icons.download),
                label: const Text('Exportar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC6DA23),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Nombre')),
                DataColumn(label: Text('Duración')),
                DataColumn(label: Text('Estado')),
                DataColumn(label: Text('Acciones')),
              ],
              rows: activities.map((activity) {
                return DataRow(
                  cells: [
                    DataCell(Text(activity['name'] ?? '')),
                    DataCell(Text(activity['duration'] ?? '')),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF9ACA60).withAlpha(20),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          activity['status'] ?? '',
                          style: const TextStyle(
                            color: Color(0xFF9ACA60),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.visibility),
                            onPressed: () {
                              // Implementar vista previa
                            },
                            tooltip: 'Ver detalles',
                            color: const Color(0xFF0067AC),
                          ),
                          IconButton(
                            icon: const Icon(Icons.play_circle),
                            onPressed: () {
                              // Implementar reproducción
                            },
                            tooltip: 'Reproducir video',
                            color: const Color(0xFFC6DA23),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
