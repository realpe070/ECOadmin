import 'package:flutter/material.dart';

class ActivityPlanContent extends StatelessWidget {
  final VoidCallback onClose;

  const ActivityPlanContent({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Próximamente - Plan de Actividades',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }
}
