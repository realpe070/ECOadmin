import 'package:flutter/material.dart';

class FloatingPanel extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback onClose;
  final List<Widget>? actions;

  const FloatingPanel({
    super.key,
    required this.title,
    required this.child,
    required this.onClose,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'HelveticaRounded',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0067AC),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: child),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (actions != null) ...actions!,
                TextButton(onPressed: onClose, child: const Text('Cerrar')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
