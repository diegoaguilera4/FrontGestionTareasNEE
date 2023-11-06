import 'package:flutter/material.dart';
import 'package:gestiontareas/pages/profesional.dart';

import '../colores.dart';

class LoginPage extends StatelessWidget {
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
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: secondaryColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Ingresa tus credenciales aquí',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Correo',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
                obscureText: true, // Para ocultar la contraseña
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _login(
                    context), // Llama a la función _login con el contexto
                child: Text('Iniciar sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
