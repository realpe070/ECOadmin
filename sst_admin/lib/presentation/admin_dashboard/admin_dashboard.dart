import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';  // Actualizado para usar la nueva ubicación
import './user_admin/admin_users_page.dart';
import 'pausa_activa/create_activity_content.dart';
import 'pausa_activa/edit_activities_content.dart';
import 'pausa_activa/activity_list_content.dart';
import 'pausa_activa/history_content.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  Widget? _currentContent;
  bool _pausaActivaExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Panel lateral
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0067AC).withAlpha(15),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 32),
                // Logo y título
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
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
                              fontSize: 20,
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
                const SizedBox(height: 40),
                // Menú principal
                _buildMenuItem(
                  icon: Icons.people,
                  title: 'Usuarios',
                  onTap: () => setState(() {
                    _currentContent = const AdminUsersPage();
                  }),
                ),
                ExpansionTile(
                  leading: const Icon(
                    Icons.fitness_center,
                    color: Color(0xFF0067AC),
                    size: 22,
                  ),
                  title: Text(
                    'Gestión de Pausas',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'HelveticaRounded',
                      color: _pausaActivaExpanded ? const Color(0xFF0067AC) : Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  childrenPadding: EdgeInsets.zero,
                  collapsedIconColor: Colors.grey,
                  iconColor: const Color(0xFF0067AC),
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildSubMenuItem(
                      title: 'Nueva Actividad',
                      onTap: () => setState(() {
                        _currentContent = const CreateActivityContent();
                      }),
                    ),
                    _buildSubMenuItem(
                      title: 'Editar Actividades',
                      onTap: () => setState(() {
                        _currentContent = const EditActivitiesContent();
                      }),
                    ),
                    _buildSubMenuItem(
                      title: 'Ver Lista',
                      onTap: () => setState(() {
                        _currentContent = const ActivityListContent();
                      }),
                    ),
                    _buildSubMenuItem(
                      title: 'Historial',
                      onTap: () => setState(() {
                        _currentContent = const HistoryContent();
                      }),
                    ),
                  ],
                  onExpansionChanged: (expanded) {
                    setState(() => _pausaActivaExpanded = expanded);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.notifications,
                  title: 'Notificaciones',
                  isDisabled: true,
                ),
                const Spacer(),
                // Botón de salida
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: _buildExitButton(),
                ),
              ],
            ),
          ),
          // Contenido principal
          Expanded(
            child: Container(
              color: const Color(0xFFF8FAFC),
              child: Column(
                children: [
                  // Header
                  Container(
                    height: 80,
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(5),
                          blurRadius: 8,
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
                          color: const Color(0xFF0067AC),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  // Área de contenido
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      child: _currentContent ?? const _WelcomeContent(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    bool isDisabled = false,
  }) {
    final color = isDisabled ? Colors.grey : const Color(0xFF0067AC);
    
    return Material(
      color: Colors.transparent,
      child: ListTile(
        onTap: isDisabled ? null : onTap,
        leading: Icon(icon, color: color, size: 22),
        title: Text(
          title,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w500,
            fontSize: 14,
            fontFamily: 'HelveticaRounded',
          ),
        ),
        dense: true,
        visualDensity: const VisualDensity(vertical: -1),
      ),
    );
  }

  Widget _buildSubMenuItem({
    required String title,
    required VoidCallback onTap,
  }) {
    IconData getIcon() {
      switch (title) {
        case 'Nueva Actividad':
          return Icons.add_circle_outline;
        case 'Editar Actividades':
          return Icons.edit_note;
        case 'Ver Lista':
          return Icons.format_list_bulleted;
        case 'Historial':
          return Icons.history;
        default:
          return Icons.circle;
      }
    }

    return ListTile(
      contentPadding: const EdgeInsets.only(left: 72),
      leading: Icon(
        getIcon(),
        color: const Color(0xFF0067AC),
        size: 20,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontFamily: 'HelveticaRounded',
          color: Color(0xFF0067AC),
          fontWeight: FontWeight.w500,
        ),
      ),
      dense: true,
      visualDensity: const VisualDensity(vertical: -1),
      onTap: onTap,
    );
  }

  Widget _buildExitButton() {
    return ElevatedButton.icon(
      onPressed: () => _showExitConfirmation(context),
      icon: const Icon(Icons.exit_to_app, color: Colors.white, size: 20),
      label: const Text(
        'Cerrar Sesión',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade400,
        padding: const EdgeInsets.symmetric(vertical: 12),
        minimumSize: const Size(double.infinity, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
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

class _WelcomeContent extends StatelessWidget {
  const _WelcomeContent();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.admin_panel_settings,
            size: 64,
            color: const Color(0xFF0067AC).withAlpha(100),
          ),
          const SizedBox(height: 16),
          const Text(
            'Bienvenido al Panel de Administración',
            style: TextStyle(
              fontSize: 24,
              color: Color(0xFF0067AC),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Selecciona una opción del menú para comenzar',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
