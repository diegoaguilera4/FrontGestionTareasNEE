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
      onGenerateRoute: (settings) {
        // Si pasas al constructor de la ruta argumentos, se encontrarán en settings.arguments.
        // En este caso, extrae el token que pasaste con Navigator.pushNamed().
        final args = settings.arguments;

        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => LoginView());
          case '/registro':
            return MaterialPageRoute(builder: (context) => RegistroView());
          case '/profesional':
            // Valida si los argumentos son correctos antes de acceder a ellos.
            if (args is String) {
              return MaterialPageRoute(
                builder: (context) => ProfesionalView(token: args),
              );
            }
          // Si los argumentos no son del tipo correcto, redirige a una ruta de error.
          case '/pacientes':
            if (args is String) {
              return MaterialPageRoute(
                builder: (context) => PacientesView(token: args),
              );
            }
          case '/agregarPaciente':
            return MaterialPageRoute(
                builder: (context) => AgregarPersonaView());
          case '/tareas':
            if (args is String) {
              return MaterialPageRoute(
                builder: (context) => TaskView(token: args),
              );
            }
          default:
          // Si no hay ninguna ruta con el nombre que has pasado, entonces usa esta función para manejarlo.
        }
      },
    );
  }
}
