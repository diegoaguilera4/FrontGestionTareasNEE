import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  String currentPage; // La página actual

  SideMenu({required this.currentPage});
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
            color: currentPage == 'general' ? Colors.blue : Colors.transparent,
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
                Navigator.pushNamed(context, '/profesional');
                currentPage = 'general';
              },
            ),
          ),
          Container(
            color:
                currentPage == 'pacientes' ? Colors.blue : Colors.transparent,
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
                Navigator.pushNamed(context, '/pacientes');
                currentPage = 'pacientes';
              },
            ),
          ),

          // Agrega más elementos de menú según tus necesidades

          Divider(), // Línea divisoria

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
              onTap: () {
                // Agrega la lógica para cerrar la sesión
                // Esto puede incluir limpiar datos de sesión y redirigir al inicio de sesión
                Navigator.pushNamed(
                    context, '/'); // Redirige a la página de inicio de sesión
              },
            ),
          ),
        ],
      ),
    );
  }
}
