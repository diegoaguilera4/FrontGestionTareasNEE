import 'dart:html';

import 'package:flutter/material.dart';
import 'package:gestiontareas/pages/agregarPaciente.dart';
import 'package:gestiontareas/pages/login.dart';
import 'package:gestiontareas/pages/misTareas.dart';
import 'package:gestiontareas/pages/pacientes.dart';
import 'package:gestiontareas/pages/profesional.dart';
import 'package:gestiontareas/pages/registro.dart';
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
      home: isTokenValid ? _getInitialRoute(lastRoute, token) : LoginView(),
      onGenerateRoute: (settings) {
        final args = settings.arguments;
        window.localStorage['currentRoute'] = settings.name!;
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => LoginView());
          case '/registro':
            return MaterialPageRoute(builder: (context) => RegistroView());
          case '/profesional':
            if (args is String) {
              return MaterialPageRoute(
                builder: (context) => ProfesionalView(token: args),
              );
            }
            break;
          case '/pacientes':
            if (args is String) {
              return MaterialPageRoute(
                builder: (context) => PacientesView(token: args),
              );
            }
            break;
          case '/agregarPaciente':
            if (args is String) {
              return MaterialPageRoute(
                builder: (context) => AgregarPacienteView(
                  token: args,
                  onPacienteAdded: () {},
                ),
              );
            }
            break;
          case '/tareas':
            if (args is String) {
              return MaterialPageRoute(
                builder: (context) => TaskView(token: args),
              );
            }
            break;
          default:
            return MaterialPageRoute(builder: (context) => ErrorView());
        }
      },
    );
  }

  Widget _getInitialRoute(String? routeName, String? token) {
    switch (routeName) {
      case '/profesional':
        return ProfesionalView(token: token!);
      case '/pacientes':
        return PacientesView(token: token!);
      case '/agregarPaciente':
        return AgregarPacienteView(token: token!, onPacienteAdded: () {});
      case '/tareas':
        return TaskView(token: token!);
      default:
        return LoginView();
    }
  }
}

class ErrorView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Error')),
      body: Center(
        child: Text('Ruta no encontrada'),
      ),
    );
  }
}
