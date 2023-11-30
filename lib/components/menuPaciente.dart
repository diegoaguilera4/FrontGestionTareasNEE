import 'dart:html';

import 'package:flutter/material.dart';
import 'package:gestiontareas/colores.dart';
import 'package:gestiontareas/pages/usuarioGeneral/misTareas.dart';
import '../pages/auth/login.dart';

class MenuPaciente extends StatefulWidget {
  MenuPaciente({Key? key, required String currentPage}) : super(key: key);

  @override
  _MenuPacienteState createState() => _MenuPacienteState();
}

class _MenuPacienteState extends State<MenuPaciente> {
  String currentPage = window.localStorage['currentRoute']!;
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
          _buildMenuItem('/tareas', 'Mis tareas', Icons.dashboard),
          // Agrega más elementos de menú según tus necesidades
          const Divider(), // Línea divisoria
          _buildMenuItem('', 'Cerrar Sesión', Icons.exit_to_app),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String ruta, String title, IconData icon) {
    bool isSelected = ruta == currentPage;

    return Container(
      color: isSelected ? primaryColor : Colors.transparent,
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        onTap: () {
          // Actualiza currentPage antes de realizar la navegación
          setState(() {
            currentPage = window.localStorage['currentRoute']!;
          });

          // Realiza la navegación
          if (title == 'Mis tareas') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskView(),
                settings: RouteSettings(name: '/tareas'),
              ),
            );
          } else if (title == 'Cerrar Sesión') {
            _handleLogout();
          }
        },
      ),
    );
  }

  Future<void> _handleLogout() async {
    window.localStorage.remove('token');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginView(),
        settings: RouteSettings(name: '/'),
      ),
    );
  }
}
