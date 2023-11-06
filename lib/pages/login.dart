import 'package:flutter/material.dart';
import 'package:gestiontareas/colores.dart';

import '../responsive.dart';

class LoginView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _login(BuildContext context) {
    final String email = emailController.text;
    final String password = passwordController.text;

    // Realiza la lógica de autenticación aquí, por ejemplo, puedes validar los campos y autenticar al usuario.
    // Puedes mostrar un mensaje de error si la autenticación falla o navegar a la página principal si tiene éxito.

    // Supongamos que la autenticación fue exitosa y deseas navegar a la página de inicio.
    Navigator.pushNamed(context, '/profesional');
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
                  offset: Offset(0, 3),
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
                        onTap: () => Navigator.pushNamed(context, '/registro'),
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
