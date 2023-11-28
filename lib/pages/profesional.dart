import 'package:flutter/material.dart';
import 'package:gestiontareas/colores.dart';
import 'package:gestiontareas/pages/login.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/menuProfesional.dart';

class ProfesionalView extends StatefulWidget {
  final String token;

  const ProfesionalView({Key? key, required this.token}) : super(key: key);

  @override
  State<ProfesionalView> createState() => _ProfesionalViewState();
}

class _ProfesionalViewState extends State<ProfesionalView> {
  String? email;

  @override
  void initState() {
    super.initState();
    _storeToken();
    _initializeEmail();
  }

  // Función para almacenar el token
  Future<void> _storeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', widget.token);
  }

  // Función para inicializar el campo 'email'
  void _initializeEmail() {
    try {
      Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
      email = jwtDecodedToken['email'];
    } catch (e) {
      // Manejar cualquier error al decodificar el token, por ejemplo, token no válido.
      print('Error al decodificar el token: $e');
      // Puedes manejar el error de otra manera, como cerrar sesión y volver a la pantalla de inicio.
      _handleLogout();
    }
  }

  // Función para cerrar sesión
  Future<void> _handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Elimina el token almacenado
    // Navega a la pantalla de inicio de sesión
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginView(),
        settings: RouteSettings(name: '/'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vista Profesional'),
        backgroundColor: secondaryColor,
      ),
      drawer: MenuProfesional(
        currentPage: 'general',
        token: widget.token,
      ),
      body: Center(
        child: Text(email ?? 'Correo no disponible'),
      ),
    );
  }
}
