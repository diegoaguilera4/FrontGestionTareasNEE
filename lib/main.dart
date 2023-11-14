import 'package:flutter/material.dart';
import 'package:gestiontareas/pages/agregarPaciente.dart';
import 'package:gestiontareas/pages/login.dart';
import 'package:gestiontareas/pages/misTareas.dart';
import 'package:gestiontareas/pages/pacientes.dart';
import 'package:gestiontareas/pages/profesional.dart';
import 'package:gestiontareas/pages/registro.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colores.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
      initialRoute: '/', // Página de inicio
      routes: {
        // Página de inicio
        '/': (context) => LoginView(), // Página de inicio de sesión
        '/registro': (context) => RegistroView(),
        '/profesional': (context) => const ProfesionalView(),
        '/pacientes': (context) => PacientesView(),
        '/agregarPaciente': (context) => AgregarPersonaView(),
        '/tareas':(context) => TaskView(),
      },
    );
  }
}
