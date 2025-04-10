import 'package:flutter/material.dart';
import '../presentation/admin_login.dart';
import '../presentation/admin_dashboard/admin_dashboard.dart';
import '../presentation/admin_dashboard/user_admin/admin_users_page.dart';

class AdminRoutes {
  static const String dashboard = '/admin_dashboard';
  static const String users = '/admin_users';
  static const String login = '/admin_login';
  static const String notifications = '/admin_notifications';
}

final Map<String, WidgetBuilder> adminRoutes = {
  AdminRoutes.login: (context) => const AdminLoginPage(),
  AdminRoutes.dashboard: (context) => const AdminDashboard(),
  AdminRoutes.users: (context) => const AdminUsersPage(),
};
