import 'package:flutter/material.dart';
import '../../core/routes_adm.dart';
import '../../config/widgets/floating_panel.dart';
import './gestion_pausas/create_activity_content.dart';
import './gestion_pausas/edit_activities_content.dart';
import './gestion_pausas/activity_plan_content.dart';
import './gestion_pausas/historial_content.dart';
import './notifications/notification_content.dart';
import './user_admin/admin_users_page.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  Widget? _currentContent;
  bool _showNotificationPlan = false;
  bool _showHistory = false;
  bool _showCreateActivity = false;
  bool _showEditActivities = false;
  bool _showActivityPlan = false;
  bool _showActivityHistory = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              // Sidebar izquierdo
              Container(
                width: 280,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(26), // 0.1 * 255 ≈ 26
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    // Logo y título
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/imagenes/LOGOECOBREACK.png',
                            width: 40,
                            height: 40,
                          ),
                          const SizedBox(width: 12),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ECOBREACK',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0067AC),
                                ),
                              ),
                              Text(
                                'Panel Administrativo',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    // Menú principal
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        children: [
                          _buildMenuTile(
                            'Usuarios',
                            Icons.group_outlined,
                            onTap: () => setState(() {
                              _currentContent = const AdminUsersPage();
                            }),
                          ),
                          _buildExpandableMenuTile(
                            'Gestión de Pausas',
                            Icons.fitness_center_outlined,
                            [
                              _buildSubMenuItem(
                                'Crear Actividad',
                                Icons.add_circle_outline,
                                () => setState(() => _showCreateActivity = true),
                              ),
                              _buildSubMenuItem(
                                'Editar Actividades',
                                Icons.edit_outlined,
                                () => setState(() => _showEditActivities = true),
                              ),
                              _buildSubMenuItem(
                                'Plan de Actividades',
                                Icons.calendar_today_outlined,
                                () => setState(() => _showActivityPlan = true),
                              ),
                              _buildSubMenuItem(
                                'Historial',
                                Icons.history_outlined,
                                () => setState(() => _showActivityHistory = true),
                              ),
                            ],
                          ),
                          _buildExpandableMenuTile(
                            'Notificaciones',
                            Icons.notifications_outlined,
                            [
                              _buildSubMenuItem(
                                'Plan de Notificaciones',
                                Icons.schedule_outlined,
                                () => setState(() => _showNotificationPlan = true),
                              ),
                              _buildSubMenuItem(
                                'Historial',
                                Icons.history_outlined,
                                () => setState(() => _showHistory = true),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Botón de salida
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: _buildExitButton(),
                    ),
                  ],
                ),
              ),
              // Contenido principal
              Expanded(
                child: Container(
                  color: const Color(0xFFF5F6F8),
                  child: Column(
                    children: [
                      // Header
                      Container(
                        height: 80,
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(13), // 0.05 * 255 ≈ 13
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Text(
                              'Bienvenido, Administrador',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.notifications_outlined),
                              onPressed: () => _showNotificationMenu(context),
                            ),
                          ],
                        ),
                      ),
                      // Área de contenido
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(30),
                          child: _currentContent ?? const Center(
                            child: Text(
                              'Selecciona una opción del menú para comenzar',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Floating panels
          if (_showCreateActivity)
            FloatingPanel(
              title: 'Crear Actividad',
              onClose: () => setState(() => _showCreateActivity = false),
              child: CreateActivityContent(
                onClose: () => setState(() => _showCreateActivity = false),
              ),
            ),
          if (_showEditActivities)
            FloatingPanel(
              title: 'Editar Actividades',
              onClose: () => setState(() => _showEditActivities = false),
              child: EditActivitiesContent(
                onClose: () => setState(() => _showEditActivities = false),
              ),
            ),
          if (_showActivityPlan)
            FloatingPanel(
              title: 'Plan de Actividades',
              onClose: () => setState(() => _showActivityPlan = false),
              child: ActivityPlanContent(
                onClose: () => setState(() => _showActivityPlan = false),
              ),
            ),
          if (_showActivityHistory)
            FloatingPanel(
              title: 'Historial',
              onClose: () => setState(() => _showActivityHistory = false),
              child: HistorialContent(
                onClose: () => setState(() => _showActivityHistory = false),
              ),
            ),
          if (_showNotificationPlan)
            FloatingPanel(
              title: 'Plan de Notificaciones',
              onClose: () => setState(() => _showNotificationPlan = false),
              child: NotificationContent(
                onClose: () => setState(() => _showNotificationPlan = false),
              ),
            ),
          if (_showHistory)
            FloatingPanel(
              title: 'Historial',
              onClose: () => setState(() => _showHistory = false),
              child: HistorialContent(
                onClose: () => setState(() => _showHistory = false),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMenuTile(String title, IconData icon, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF0067AC)),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        if (title == 'Usuarios') {
          setState(() {
            _currentContent = const AdminUsersPage();
          });
        } else if (onTap != null) {
          onTap();
        }
      },
      dense: true,
    );
  }

  Widget _buildExpandableMenuTile(String title, IconData icon, List<Widget> children) {
    return ExpansionTile(
      leading: Icon(icon, color: const Color(0xFF0067AC)),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      children: children,
    );
  }

  Widget _buildSubMenuItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, size: 20, color: Colors.grey),
      title: Text(
        title,
        style: const TextStyle(fontSize: 13),
      ),
      onTap: onTap,
      dense: true,
      contentPadding: const EdgeInsets.only(left: 50),
    );
  }

  Widget _buildExitButton() {
    return ElevatedButton.icon(
      onPressed: () => _showExitConfirmation(context),
      icon: const Icon(Icons.exit_to_app, color: Colors.white),
      label: const Text(
        'Cerrar Sesión',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: const EdgeInsets.symmetric(vertical: 12),
        minimumSize: const Size(double.infinity, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showNotificationMenu(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(color: Colors.transparent),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.4,
              left: MediaQuery.of(context).size.width * 0.5 - 150,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildMenuOption(
                        'Plan de Notificaciones',
                        Icons.schedule,
                        () {
                          Navigator.pop(context);
                          setState(() => _showNotificationPlan = true);
                        },
                      ),
                      const Divider(height: 1),
                      _buildMenuOption(
                        'Historial',
                        Icons.history,
                        () {
                          Navigator.pop(context);
                          setState(() => _showHistory = true);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMenuOption(String text, IconData icon, VoidCallback onTap) {
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

  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Seguro que quieres salir?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, AdminRoutes.login);
              },
              child: const Text('Salir'),
            ),
          ],
        );
      },
    );
  }
}
