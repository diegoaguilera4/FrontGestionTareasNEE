import 'package:flutter/material.dart';
import 'package:gestiontareas/pages/agregarPaciente.dart';
import 'package:gestiontareas/pages/login.dart';
import 'package:gestiontareas/pages/misTareas.dart';
import 'package:gestiontareas/pages/pacientes.dart';
import 'package:gestiontareas/pages/profesional.dart';
import 'package:gestiontareas/pages/registro.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';

import 'colores.dart';

void main() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  String? lastRoute = prefs.getString('currentRoute');
  //obtener atributo rol del token
  if (token != null) {
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token);
    String rol = jwtDecodedToken['rol'];
    if (rol == 'Profesional') {
      lastRoute = '/profesional';
    } else {
      lastRoute = '/tareas';
    }
  }

  runApp(MyApp(token: token, initialRoute: lastRoute));
}

class MyApp extends StatelessWidget {
  final String? token;
  final String? initialRoute;

  const MyApp({Key? key, this.token, this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      initialRoute: isTokenValid ? initialRoute ?? '/' : '/',
      home: isTokenValid
          ? (initialRoute == '/tareas'
              ? TaskView(token: token!)
              : (initialRoute == '/profesional'
                  ? ProfesionalView(token: token!)
                  : Container()))
          : LoginView(),
      onGenerateRoute: (settings) {
        final args = settings.arguments;

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
