import 'package:flutter/material.dart';
import 'package:gestiontareas/colores.dart';
import 'package:gestiontareas/pages/pacientes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/login.dart';
import '../pages/profesional.dart';

class MenuProfesional extends StatelessWidget {
  String currentPage; // La página actual
  final String token;
  MenuProfesional({super.key, required this.currentPage, required this.token});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Gestión de tareas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: currentPage == 'general' ? primaryColor : Colors.transparent,
            child: ListTile(
              leading: const Icon(Icons.dashboard, color: Colors.white),
              title: const Text(
                'General',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () {
                // Navega a la página de panel de control y actualiza currentPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfesionalView(token: token),
                    settings: RouteSettings(name: '/profesional'),
                  ),
                );
                currentPage = 'general';
              },
            ),
          ),
          Container(
            color:
                currentPage == 'pacientes' ? primaryColor : Colors.transparent,
            child: ListTile(
              leading: const Icon(Icons.people, color: Colors.white),
              title: const Text(
                'Pacientes',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () {
                // Navega a la página de panel de control y actualiza currentPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PacientesView(token: token),
                    settings: RouteSettings(name: '/profesional'),
                  ),
                );
                currentPage = 'pacientes';
              },
            ),
          ),

          // Agrega más elementos de menú según tus necesidades

          const Divider(), // Línea divisoria

          Container(
            color: currentPage == 'cerrarSesion'
                ? Colors.blue
                : Colors.transparent,
            child: ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.white),
              title: const Text(
                'Cerrar Sesión',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () async {
                // Agrega la lógica para cerrar la sesión
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('token'); // Elimina el token almacenado
                // Redirige a la página de inicio de sesión
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginView(),
                    settings: RouteSettings(name: '/'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
