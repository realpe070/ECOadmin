import 'package:flutter/material.dart';

class NotificationMenu extends StatelessWidget {
  final VoidCallback onCreate;
  final VoidCallback onEdit;
  final VoidCallback onPlan;
  final VoidCallback onHistory; // Add new callback
  final GlobalKey buttonKey;

  const NotificationMenu({
    super.key,
    required this.onCreate,
    required this.onEdit,
    required this.onPlan,
    required this.onHistory, // Add new required parameter
    required this.buttonKey,
  });

  @override
  Widget build(BuildContext context) {
    final RenderBox renderBox =
        buttonKey.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    return Positioned(
      left: offset.dx,
      top: offset.dy + renderBox.size.height + 5,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMenuItem('Crear Notificación', Icons.add, onCreate),
              const Divider(height: 1),
              _buildMenuItem('Editar Notificaciones', Icons.edit, onEdit),
              const Divider(height: 1),
              _buildMenuItem('Plan de Notificaciones', Icons.schedule, onPlan),
              const Divider(height: 1),
              _buildMenuItem(
                'Historial',
                Icons.history,
                onHistory,
              ), // Add new menu item
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(String text, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, size: 20, color: const Color(0xFF0067AC)),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                fontFamily: 'HelveticaRounded',
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
