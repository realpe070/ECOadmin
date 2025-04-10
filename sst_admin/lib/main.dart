import 'package:flutter/material.dart';
import 'administrador/presentation/admin_login.dart';
import 'administrador/core/routes_adm.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  
      title: 'SST Admin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: AdminRoutes.login,
      routes: adminRoutes,
      home: const AdminLoginPage(),
    );
  }
}
