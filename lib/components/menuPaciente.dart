import 'package:flutter/material.dart';
import 'package:gestiontareas/colores.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/login.dart';

class MenuPaciente extends StatefulWidget {
  final String token;

  MenuPaciente({Key? key, required this.token, required String currentPage}) : super(key: key);

  @override
  _MenuPacienteState createState() => _MenuPacienteState();
}

class _MenuPacienteState extends State<MenuPaciente> {
  String currentPage = 'Mis tareas'; // Inicializa con la página predeterminada

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
          _buildMenuItem('Mis tareas', Icons.dashboard),
          // Agrega más elementos de menú según tus necesidades
          const Divider(), // Línea divisoria
          _buildMenuItem('Cerrar Sesión', Icons.exit_to_app),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon) {
    return Container(
      color: currentPage == title ? primaryColor : Colors.transparent,
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
            currentPage = title;
          });

          // Realiza la navegación
          if (title == 'Mis tareas') {
            Navigator.pushNamed(context, '/tareas', arguments: widget.token);
          } else if (title == 'Cerrar Sesión') {
            _handleLogout();
          }
        },
      ),
    );
  }

  Future<void> _handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginView()));
  }
}
