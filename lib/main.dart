import 'dart:html';
import 'dart:js';

import 'package:flutter/material.dart';
import 'package:gestiontareas/pages/profesional/agregarPaciente.dart';
import 'package:gestiontareas/pages/auth/login.dart';
import 'package:gestiontareas/pages/profesional/agregarTarea.dart';
import 'package:gestiontareas/pages/usuarioGeneral/misTareas.dart';
import 'package:gestiontareas/pages/profesional/pacientes.dart';
import 'package:gestiontareas/pages/page_404.dart';
import 'package:gestiontareas/pages/profesional/profesional.dart';
import 'package:gestiontareas/pages/auth/registro.dart';
import 'package:gestiontareas/pages/profesional/sesiones.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:url_strategy/url_strategy.dart';

import 'colores.dart';

void main() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _routes = {
    '/': (context) => LoginView(),
    '/registro': (context) => RegistroView(),
    '/profesional': (context) => ProfesionalView(),
    '/pacientes': (context) => PacientesView(),
    '/sesiones': (context) => const SesionesView(),
    '/agregarPaciente': (context) =>
        AgregarPacienteView(onPacienteAdded: () {}),
    '/tareas': (context) => TaskView(),
    '/agregarTarea': (context) => const AgregarTareaView(),
  };

  @override
  Widget build(BuildContext context) {
    String? token = window.localStorage['token'];
    bool isTokenValid = token != null && JwtDecoder.isExpired(token!) == false;
    // Verificar si el token es válido, sino enviar al login
    String rutaInicial = "";
    if (isTokenValid) {
      Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token!);
      String rol = jwtDecodedToken['rol'];
      if (rol == 'Profesional') {
        rutaInicial = '/profesional';
      } else {
        rutaInicial = '/tareas';
      }
    } else {
      rutaInicial = '/';
    }
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: bgColor,
        textTheme:
            GoogleFonts.montserratTextTheme(Theme.of(context).textTheme).apply(
          bodyColor: secondaryColor,
          displayColor: secondaryColor,
        ),
        canvasColor: secondaryColor,
      ),
      initialRoute: rutaInicial,
      routes: _routes,
      onGenerateRoute: (settings) {
        window.localStorage['currentRoute'] = settings.name!;
        return MaterialPageRoute(
          builder: (context) => const Page404(),
        );
      },
    );
  }
}
