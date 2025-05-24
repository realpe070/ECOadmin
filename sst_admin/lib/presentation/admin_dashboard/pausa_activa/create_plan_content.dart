import 'package:flutter/material.dart';
import '../../../core/services/serv_actividades/activity_service.dart';
import '../../../core/services/serv_actividades/plan_service.dart';

class CreatePlanContent extends StatefulWidget {
  const CreatePlanContent({super.key});

  @override
  State<CreatePlanContent> createState() => _CreatePlanContentState();
}

class _CreatePlanContentState extends State<CreatePlanContent> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  List<Map<String, dynamic>> _availableActivities = [];
  final List<Map<String, dynamic>> _selectedActivities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    try {
      setState(() => _isLoading = true);
      final activities = await ActivityService.getActivities();
      setState(() {
        _availableActivities = activities;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error cargando actividades: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _savePlan() async {
    try {
      // Validaciones
      if (_nameController.text.isEmpty || 
          _descriptionController.text.isEmpty ||
          _selectedActivities.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor complete todos los campos y agregue al menos una actividad'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Mostrar diálogo de confirmación
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirmar Creación'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('¿Está seguro de crear el plan con los siguientes datos?'),
              const SizedBox(height: 16),
              Text('Nombre: ${_nameController.text}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Actividades: ${_selectedActivities.length}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Duración Total: ${_calculateTotalDuration()}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0067AC),
              ),
              child: const Text(
                'Crear Plan',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );

      if (confirm != true) return;

      // Mostrar loading
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF0067AC),
          ),
        ),
      );

      // Preparar datos para el backend
      final result = await PlanService.createPlan(
        name: _nameController.text,
        description: _descriptionController.text,
        activities: _selectedActivities.asMap().entries.map((entry) => {
          'id': entry.value['id'], // Asegurarse de que el ID esté presente
          'activityId': entry.value['id'], // Campo requerido por el backend
          'order': entry.key, // Usar el índice como orden
        }).toList(),
      );

      if (!mounted) return;
      Navigator.pop(context); // Cerrar loading

      if (result['status'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Plan creado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        _clearForm();
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Cerrar loading en caso de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _clearForm() {
    setState(() {
      _nameController.clear();
      _descriptionController.clear();
      _selectedActivities.clear();
    });
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'visual':
      case 'tren superior':
        return const Color(0xFF0067AC); // Azul corporativo
      case 'tren inferior':
        return const Color(0xFFC6DA23); // Verde corporativo
      case 'movilidad articular':
        return const Color(0xFFFF9800); // Naranja
      case 'estiramientos generales':
        return const Color(0xFF673AB7); // Morado
      default:
        return const Color(0xFF0067AC);
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'visual':
        return Icons.visibility;
      case 'auditiva':
        return Icons.hearing;
      case 'cognitiva':
        return Icons.psychology;
      case 'tren superior':
        return Icons.accessibility_new;
      case 'tren inferior':
        return Icons.directions_walk;
      case 'movilidad articular':
        return Icons.self_improvement;
      case 'estiramientos generales':
        return Icons.accessibility;
      default:
        return Icons.fitness_center;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 1200),
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
              'Crear Plan de Pausas Activas',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'HelveticaRounded',
                color: Color(0xFF0067AC),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Panel izquierdo - Información del plan
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(
                        controller: _nameController,
                        label: 'Nombre del Plan',
                        hint: 'Ingrese el nombre del plan',
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _descriptionController,
                        label: 'Descripción',
                        hint: 'Describa el plan de pausas activas\n\nEjemplo:\n- Objetivo del plan\n- Recomendaciones\n- Población objetivo\n- Frecuencia recomendada',
                        maxLines: 12, // Aumentado de 3 a 12 líneas
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0067AC).withAlpha(13), // Cambiado de withOpacity(0.05)
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFF0067AC).withAlpha(26), // Cambiado de withOpacity(0.1)
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline, 
                              color: Color(0xFF0067AC),
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Una buena descripción ayudará a los usuarios a entender mejor el propósito y beneficios del plan de pausas activas.',
                                style: TextStyle(
                                  color: Color(0xFF0067AC),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                // Panel derecho - Selección de actividades
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 500,
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF0067AC).withAlpha(40),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Lista de actividades disponibles
                        Expanded(
                          child: _buildAvailableActivitiesList(),
                        ),
                        // Botones de acción
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                // Agregar actividad seleccionada
                              },
                              icon: const Icon(Icons.chevron_right),
                              color: const Color(0xFF0067AC),
                            ),
                            IconButton(
                              onPressed: () {
                                // Remover actividad del plan
                              },
                              icon: const Icon(Icons.chevron_left),
                              color: const Color(0xFF0067AC),
                            ),
                          ],
                        ),
                        // Lista de actividades seleccionadas
                        Expanded(
                          child: _buildSelectedActivitiesList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Nuevo panel de resumen
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0067AC).withAlpha(5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF0067AC).withAlpha(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Resumen del Plan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0067AC),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildInfoCard(
                        icon: Icons.timer,
                        title: 'Duración Total',
                        value: _calculateTotalDuration(),
                      ),
                      const SizedBox(width: 16),
                      _buildInfoCard(
                        icon: Icons.fitness_center,
                        title: 'Actividades',
                        value: '${_selectedActivities.length} ejercicios',
                      ),
                      const SizedBox(width: 16),
                      _buildInfoCard(
                        icon: Icons.category,
                        title: 'Categorías',
                        value: _getUniqueCategories(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // Lógica para cancelar
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'HelveticaRounded',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _savePlan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0067AC),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Guardar Plan',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'HelveticaRounded',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF0067AC),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF0067AC),
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvailableActivitiesList() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0067AC).withAlpha(10),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
            ),
          ),
          child: const Row(
            children: [
              Icon(Icons.fitness_center, size: 20, color: Color(0xFF0067AC)),
              SizedBox(width: 8),
              Text(
                'Actividades Disponibles',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0067AC),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: _availableActivities.length,
                  itemBuilder: (context, index) {
                    final activity = _availableActivities[index];
                    final categoryColor = _getCategoryColor(activity['category']);
                    
                    return Draggable<Map<String, dynamic>>(
                      data: activity,
                      feedback: Material(
                        elevation: 4,
                        child: Container(
                          width: 300,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: _buildActivityTile(activity, categoryColor),
                        ),
                      ),
                      child: _buildActivityCard(activity, categoryColor),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSelectedActivitiesList() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0067AC).withAlpha(10),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(12),
            ),
          ),
          child: const Row(
            children: [
              Icon(Icons.playlist_play, size: 20, color: Color(0xFF0067AC)),
              SizedBox(width: 8),
              Text(
                'Plan de Pausas',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0067AC),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: DragTarget<Map<String, dynamic>>(
            onAcceptWithDetails: (details) {
              final data = details.data;
              setState(() {
                if (!_selectedActivities.contains(data)) {
                  _selectedActivities.add(data);
                }
              });
            },
            builder: (context, candidateData, rejectedData) {
              return Container(
                decoration: BoxDecoration(
                  color: candidateData.isNotEmpty 
                      ? const Color(0xFF0067AC).withAlpha(20) 
                      : null,
                ),
                child: ReorderableListView(
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final item = _selectedActivities.removeAt(oldIndex);
                      _selectedActivities.insert(newIndex, item);
                    });
                  },
                  children: [
                    for (int index = 0; index < _selectedActivities.length; index++)
                      _buildSelectedActivityCard(
                        _selectedActivities[index], 
                        index,
                        key: ValueKey(_selectedActivities[index]['id']),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> activity, Color categoryColor) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: categoryColor.withAlpha(50),
        ),
      ),
      child: _buildActivityTile(activity, categoryColor),
    );
  }

  Widget _buildSelectedActivityCard(Map<String, dynamic> activity, int index, {Key? key}) {
    final categoryColor = _getCategoryColor(activity['category']);
    
    return Card(
      key: key,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: categoryColor.withAlpha(50),
        ),
      ),
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: categoryColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(_getCategoryIcon(activity['category']), color: categoryColor),
          ],
        ),
        title: Text(
          activity['name'],
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          activity['category'],
          style: TextStyle(color: categoryColor),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
          onPressed: () {
            setState(() {
              _selectedActivities.removeAt(index);
            });
          },
        ),
      ),
    );
  }

  Widget _buildActivityTile(Map<String, dynamic> activity, Color categoryColor) {
    return ListTile(
      leading: Icon(_getCategoryIcon(activity['category']), color: categoryColor),
      title: Text(
        activity['name'],
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        activity['category'],
        style: TextStyle(color: categoryColor),
      ),
      trailing: const Icon(Icons.drag_handle),
    );
  }

  String _calculateTotalDuration() {
    if (_selectedActivities.isEmpty) return '0 minutos';
    
    final totalSeconds = _selectedActivities.fold<int>(
      0,
      (sum, activity) => sum + (activity['maxTime'] as int),
    );
    
    if (totalSeconds < 60) {
      return '$totalSeconds segundos';
    } else {
      final minutes = (totalSeconds / 60).floor();
      final seconds = totalSeconds % 60;
      return seconds > 0 
          ? '$minutes min $seconds seg'
          : '$minutes minutos';
    }
  }

  String _getUniqueCategories() {
    if (_selectedActivities.isEmpty) return '0 tipos';
    
    final categories = _selectedActivities
        .map((e) => e['category'] as String)
        .toSet();
    
    return '${categories.length} tipos';
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFF0067AC).withAlpha(20),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF0067AC).withAlpha(20),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF0067AC),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0067AC),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
