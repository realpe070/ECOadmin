import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/notification_model.dart';
import '../../../domain/use_cases/create_notification_use_case.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _message = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Notificación'),
        backgroundColor: const Color(0xFF0067AC),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => _title = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese un título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Mensaje',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onSaved: (value) => _message = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese un mensaje';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          setState(() => _isLoading = true);

                          try {
                            final notification = NotificationModel(
                              id: DateTime.now().millisecondsSinceEpoch.toString(),
                              title: _title,
                              message: _message,
                              date: DateTime.now(),
                            );

                            if (!mounted) return;

                            await context.read<CreateNotificationUseCase>()(notification);

                            if (!mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Notificación enviada')),
                            );
                            Navigator.pop(context);
                          } catch (e) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          } finally {
                            if (mounted) setState(() => _isLoading = false);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC6DA23),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                      child: const Text('Enviar Notificación'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
