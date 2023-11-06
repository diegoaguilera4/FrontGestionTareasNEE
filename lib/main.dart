import 'package:flutter/material.dart';
import 'package:gestiontareas/pages/login.dart';
import 'package:gestiontareas/pages/pacientes.dart';
import 'package:gestiontareas/pages/profesional.dart';
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
          displayColor: secondaryColor, // Configura la fuente secundaria aquí
        ),
        canvasColor: secondaryColor,
        // Tu configuración de tema aquí
      ),
      initialRoute: '/', // Página de inicio
      routes: {
        // Página de inicio
        '/': (context) => LoginPage(), // Página de inicio de sesión
        '/profesional': (context) => const ProfesionalView(),
        '/pacientes': (context) => PacientesView()
        // Define otras rutas aquí si es necesario
      },
    );
  }
}
