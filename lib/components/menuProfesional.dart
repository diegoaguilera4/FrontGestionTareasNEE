import 'dart:html';

import 'package:flutter/material.dart';
import 'package:gestiontareas/colores.dart';
import 'package:gestiontareas/pages/usuarioGeneral/misTareas.dart';
import 'package:gestiontareas/pages/profesional/pacientes.dart';
import 'package:gestiontareas/pages/profesional/profesional.dart';
import 'package:gestiontareas/pages/profesional/sesiones.dart';
import '../pages/auth/login.dart';

class MenuProfesional extends StatefulWidget {
  MenuProfesional({Key? key, required String currentPage}) : super(key: key);

  @override
  _MenuProfesionalState createState() => _MenuProfesionalState();
}

class _MenuProfesionalState extends State<MenuProfesional> {
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
          _buildMenuItem('/profesional', 'General', Icons.dashboard),
          _buildMenuItem('/pacientes', 'Pacientes', Icons.people),
          _buildMenuItem('/sesiones', 'Sesiones', Icons.dashboard),

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
          if (title == 'General') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfesionalView(),
                settings: RouteSettings(name: '/profesional'),
              ),
            );
          } else if (title == 'Pacientes') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PacientesView(),
                settings: RouteSettings(name: '/pacientes'),
              ),
            );
          } else if (title == 'Sesiones') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SesionesView(),
                settings: RouteSettings(name: '/sesiones'),
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
