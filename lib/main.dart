import 'dart:html';

import 'package:flutter/material.dart';
import 'package:gestiontareas/pages/agregarPaciente.dart';
import 'package:gestiontareas/pages/login.dart';
import 'package:gestiontareas/pages/misTareas.dart';
import 'package:gestiontareas/pages/pacientes.dart';
import 'package:gestiontareas/pages/profesional.dart';
import 'package:gestiontareas/pages/registro.dart';
import 'package:gestiontareas/pages/sesiones.dart';
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
  };

  @override
  Widget build(BuildContext context) {
    String? token = window.localStorage['token'];
    String? lastRoute = window.localStorage['currentRoute'];
    bool isTokenValid = token != null && JwtDecoder.isExpired(token!) == false;

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
      routes: _routes,
      onGenerateRoute: (settings) {
        window.localStorage['currentRoute'] = settings.name!;
        return MaterialPageRoute(
          builder: (context) => ErrorView(),
        );
      },
    );
  }

  Widget _getInitialRoute(String? routeName) {
    switch (routeName) {
      case '/profesional':
        return ProfesionalView();
      case '/pacientes':
        return PacientesView();
      case '/agregarPaciente':
        return AgregarPacienteView(onPacienteAdded: () {});
      case '/tareas':
        return TaskView();
      default:
        return LoginView();
    }
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: const Center(
        child: Text('Ruta no encontrada'),
      ),
    );
  }
}
