import 'package:flutter/material.dart';
import '../core/service/platform_service.dart';
import '../core/routes_adm.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  AdminLoginPageState createState() => AdminLoginPageState();
}

class AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    if (!PlatformService.isAdminPlatform) {
      return const Scaffold(
        body: Center(
          child: Text(
            'El panel de administración solo está disponible en computadoras de escritorio.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: BackgroundPainter())),
          Positioned(
            bottom: 20,
            left: 20,
            child: Image.asset(
              'assets/imagenes/LOGOECOBREACK.png',
              width: 80,
              height: 80,
            ),
          ),
          Center(
            child: Container(
              width: size.width * 0.85,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.25 * 255).toInt()),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xFF0067AC),
                    child: Icon(
                      Icons.admin_panel_settings,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    '¡Bienvenido Administrador!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'HelveticaRounded',
                      color: Color(0xFF0067AC),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Color(0xFF0067AC),
                      ),
                      labelText: 'Correo Admin',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF0067AC),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Color(0xFF0067AC),
                      ),
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF0067AC),
                          width: 2,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: const Color(0xFF0067AC),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      const adminUsername = 'ecoecobreack@gmail.com';
                      const adminPassword = 'ECO123456789';

                      if (usernameController.text == adminUsername &&
                          passwordController.text == adminPassword) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('¡Inicio de sesión exitoso!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        if (!mounted) return;
                        Navigator.pushReplacementNamed(context, AdminRoutes.dashboard);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Credenciales incorrectas'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0067AC),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Iniciar sesión',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'HelveticaRounded',
                        color: Colors.white,
                      ),
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
}

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    paint.color = const Color(0xFF0067AC);
    final path1 =
        Path()
          ..moveTo(0, 0)
          ..lineTo(size.width, 0)
          ..lineTo(size.width, size.height * 0.5)
          ..lineTo(0, size.height * 0.4)
          ..close();
    canvas.drawPath(path1, paint);

    paint.color = const Color(0xFFC6DA23);
    final borderPath =
        Path()
          ..moveTo(0, size.height * 0.4)
          ..lineTo(size.width, size.height * 0.5)
          ..lineTo(size.width, size.height * 0.48)
          ..lineTo(0, size.height * 0.38)
          ..close();
    canvas.drawPath(borderPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
