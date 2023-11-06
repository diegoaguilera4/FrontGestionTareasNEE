import 'package:flutter/material.dart';
import 'package:gestiontareas/colores.dart';
import 'package:google_fonts/google_fonts.dart';

import '../responsive.dart';

class RegistroView extends StatelessWidget {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController vinculacionController = TextEditingController();
  String selectedRole = ''; // Variable para almacenar el rol seleccionado

  void _registro(BuildContext context) {
    final String nombre = nombreController.text;
    final String email = emailController.text;
    final String password = passwordController.text;
    final String vinculacion = vinculacionController.text;

    // Realiza la lógica de registro aquí, y utiliza la variable 'selectedRole' para determinar el rol seleccionado.

    // Supongamos que el registro fue exitoso y deseas navegar a la página de inicio.
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
                        'Registro',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: nombreController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
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
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text(
                            'Rol',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(width: 50),
                          SelectRol(),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: vinculacionController,
                        decoration: const InputDecoration(
                          labelText: 'Código vinculación',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  primaryColor),
                            ),
                            onPressed: () => _registro(context),
                            child: const Text('Registrarse'),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  buttonColor1),
                            ),
                            onPressed: () => Navigator.pushNamed(context, '/'),
                            child: const Text('Cancelar'),
                          ),
                        ],
                      )
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

class SelectRol extends StatefulWidget {
  @override
  _SelectRolState createState() => _SelectRolState();
}

class _SelectRolState extends State<SelectRol> {
  String dropdownValue = 'Profesional'; // Establece el valor inicial

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.person),
      elevation: 16,
      style: GoogleFonts.montserrat(
        textStyle: const TextStyle(
          color: secondaryColor, // Cambia el color del texto
        ),
      ),
      underline: Container(
        height: 2,
        color: secondaryColor,
      ),
      dropdownColor: Colors.white, // Cambia el fondo a blanco
      onChanged: (String? value) {
        // Esto se llama cuando el usuario selecciona un elemento.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: ['Profesional', 'Padre', 'Profesor', 'Paciente']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                  color: secondaryColor,
                  fontSize: 16 // Cambia el color del texto
                  ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
