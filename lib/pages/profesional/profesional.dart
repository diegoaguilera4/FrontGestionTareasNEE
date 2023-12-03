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
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    window.localStorage['currentRoute'] =
        ModalRoute.of(context)!.settings.name!;
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
      body: const Center(
        child: Text('Dashboard'),
      ),
    );
  }
}
