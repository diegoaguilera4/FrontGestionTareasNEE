import 'dart:html';

import 'package:flutter/material.dart';
import 'package:gestiontareas/colores.dart';
import 'package:gestiontareas/pages/auth/login.dart';
import 'package:gestiontareas/pages/page_404.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../components/menuProfesional.dart';

class ProfesionalView extends StatefulWidget {
  const ProfesionalView({Key? key}) : super(key: key);

  @override
  State<ProfesionalView> createState() => _ProfesionalViewState();
}

class _ProfesionalViewState extends State<ProfesionalView> {
  String? email;

  @override
  void initState() {
    super.initState();
    _initializeEmail();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    window.localStorage['currentRoute'] =
        ModalRoute.of(context)!.settings.name!;
  }

  // Función para inicializar el campo 'email'
  void _initializeEmail() {
    try {
      Map<String, dynamic> jwtDecodedToken =
          JwtDecoder.decode(window.localStorage['token']!);
      // Verificar si el rol es 'Profesional' antes de mostrar la vista
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
    window.localStorage.remove('token');
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
    String token = window.localStorage['token']!;
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token);
    String? rol = jwtDecodedToken['rol'];
    if (rol != "Profesional") {
      return const Page404();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vista Profesional'),
        backgroundColor: secondaryColor,
        //agregar boton para ir a pictogramas
      ),
      drawer: MenuProfesional(),
      body: Center(
        child: Text(email ?? 'Correo no disponible'),
      ),
    );
  }
}
