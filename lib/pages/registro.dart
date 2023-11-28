import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestiontareas/colores.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../responsive.dart';
import 'login.dart';

class RegistroView extends StatelessWidget {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String selectedRole = 'Profesional'; // Establecer un valor predeterminado

  void _registro(BuildContext context) async {
    final String nombre = nombreController.text;
    final String email = emailController.text;
    final String password = passwordController.text;

    // Verificar condiciones del nombre
    if (nombre.isEmpty) {
      _mostrarError(context, 'Ingrese un nombre válido.');
      return;
    }

    // Verificar formato de email
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(email)) {
      _mostrarError(context, 'Ingrese un correo electrónico válido.');
      return;
    }

    // Verificar longitud de la contraseña
    if (password.length < 8) {
      _mostrarError(context, 'La contraseña debe tener al menos 8 caracteres.');
      return;
    }

    Map<String, String> userData = {
      'nombre': nombre,
      'email': email,
      'contrasenia': password,
      'rol': selectedRole,
    };

    await _enviarRegistroAlServidor(userData);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginView(),
        settings: RouteSettings(name: '/'),
      ),
    );
  }

  Future<void> _enviarRegistroAlServidor(Map<String, String> userData) async {
    if (nombreController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      var url = Uri.parse('http://localhost:3000/usuario/add');
      var response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(userData));
    }
  }

  void _mostrarError(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: buttonColor1,
      ),
    );
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
                if (Responsive.isDesktop(context))
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7),
                    child: FractionallySizedBox(
                      widthFactor: 0.7,
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
                          SelectRol(
                            onRolSelected: (selectedRol) {
                              this.selectedRole = selectedRol;
                            },
                            initialRol: selectedRole,
                          ),
                        ],
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
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginView(),
                                settings: RouteSettings(name: '/'),
                              ),
                            ),
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
  final Function(String) onRolSelected;
  final String initialRol;

  const SelectRol({
    Key? key,
    required this.onRolSelected,
    required this.initialRol,
  }) : super(key: key);

  @override
  _SelectRolState createState() => _SelectRolState();
}

class _SelectRolState extends State<SelectRol> {
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.initialRol;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.person),
      elevation: 16,
      style: GoogleFonts.montserrat(
        textStyle: const TextStyle(
          color: secondaryColor,
        ),
      ),
      underline: Container(
        height: 2,
        color: secondaryColor,
      ),
      dropdownColor: Colors.white,
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
          widget.onRolSelected(dropdownValue);
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
                fontSize: 16,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
