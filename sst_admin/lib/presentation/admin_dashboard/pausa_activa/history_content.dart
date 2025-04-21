import 'package:flutter/material.dart';

class HistoryContent extends StatelessWidget {
  const HistoryContent({super.key});

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Historial de Actividades',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'HelveticaRounded',
                  color: Color(0xFF0067AC),
                ),
              ),
              _buildFilterButton(),
            ],
          ),
          const SizedBox(height: 24),
          _buildHistoryList(),
        ],
      ),
    );
  }

  Widget _buildFilterButton() {
    return ElevatedButton.icon(
      onPressed: () {
        // Implementar filtros
      },
      icon: const Icon(Icons.filter_list),
      label: const Text('Filtrar'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0067AC),
      ),
    );
  }

  Widget _buildHistoryList() {
    // Simulación de datos - reemplazar con datos reales
    final historyItems = [
      {
        'user': 'Juan Pérez',
        'activity': 'Estiramiento Cuello',
        'date': '2024-03-15',
        'time': '15:30',
        'duration': '45 seg',
      },
      // Añadir más items...
    ];

    return Expanded(
      child: ListView.builder(
        itemCount: historyItems.length,
        itemBuilder: (context, index) {
          final item = historyItems[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF0067AC),
                child: Icon(Icons.history, color: Colors.white),
              ),
              title: Text(
                item['activity'] ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'HelveticaRounded',
                ),
              ),
              subtitle: Text(
                'Usuario: ${item['user']} - ${item['date']} ${item['time']}',
                style: const TextStyle(
                  fontFamily: 'HelveticaRounded',
                ),
              ),
              trailing: Text(
                item['duration'] ?? '',
                style: const TextStyle(
                  color: Color(0xFF9ACA60),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
