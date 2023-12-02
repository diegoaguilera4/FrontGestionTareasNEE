import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:gestiontareas/colores.dart';
import 'package:gestiontareas/pages/usuarioGeneral/misTareas.dart';
import 'package:gestiontareas/pages/profesional/profesional.dart';
import 'package:gestiontareas/pages/auth/registro.dart';
import 'package:http/http.dart' as http;
import '../../responsive.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _login(BuildContext context) async {
    var reqBody = {
      'email': emailController.text,
      'contrasenia': passwordController.text,
    };

    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var response = await http.post(
        Uri.parse('http://localhost:3000/usuario/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody),
      );

      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status']) {
        var myToken = jsonResponse['token'];
        var rol = jsonResponse['rol'];
        window.localStorage['token'] = myToken;
        window.localStorage['rol'] = rol;

        if (rol == 'Profesional') {
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfesionalView(),
              settings: RouteSettings(name: '/profesional'),
            ),
          );
        } else {
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskView(),
              settings: RouteSettings(name: '/tareas'),
            ),
          );
        }
      }
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingrese datos válidos'),
          backgroundColor:
              buttonColor1, // Puedes ajustar el color según tus preferencias
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [secondaryColor, Color.fromARGB(255, 56, 122, 148)],
          ),
        ),
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1,
              vertical: MediaQuery.of(context).size.height * 0.1,
            ),
            padding: const EdgeInsets.all(25.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: <Widget>[
                if (Responsive.isDesktop(
                    context)) // Comprueba si la pantalla es de escritorio
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width *
                            0.7), // Establece un ancho máximo
                    child: FractionallySizedBox(
                      widthFactor: 0.7, // Establece el ancho al 70%
                      child: Image.asset(
                        'images/login.jpg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Bienvenid@',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Correo',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Contraseña',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(primaryColor),
                        ),
                        onPressed: () => _login(context),
                        child: const Text('Iniciar sesión'),
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegistroView(),
                            settings: RouteSettings(name: '/registro'),
                          ),
                        ),
                        child: const Text(
                          '¿No tienes cuenta? Regístrate aquí',
                          style: TextStyle(
                            color:
                                buttonColor2, // Color para el enlace de registro
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
