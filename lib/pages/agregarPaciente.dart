import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestiontareas/colores.dart';
import 'package:http/http.dart' as http;

class AgregarPacienteView extends StatefulWidget {
  final String token;

  AgregarPacienteView({Key? key, required this.token}) : super(key: key);

  @override
  _AgregarPacienteViewState createState() => _AgregarPacienteViewState();
}

class _AgregarPacienteViewState extends State<AgregarPacienteView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController rutController = TextEditingController();

  Future<void> _crearPaciente(Map<String, String> pacienteData) async {
    if (nombreController.text.isNotEmpty && rutController.text.isNotEmpty) {
      var url = Uri.parse('http://localhost:3000/paciente/add');
      var response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(pacienteData));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar paciente'),
        backgroundColor: secondaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        child: Container(
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
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                child: const Text(
                  'Nuevo paciente',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nombreController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre completo',
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor, ingrese un nombre';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: rutController,
                        decoration: const InputDecoration(
                          labelText: 'RUT',
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor, ingrese el RUT';
                          }
                          // Puedes agregar validaciones adicionales para el RUT si es necesario
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Aquí debes guardar los datos de la Paciente en tu base de datos o lista

                            Map<String, String> nuevoPaciente = {
                              'nombre': nombreController.text,
                              'rut': rutController.text,
                            };
                            _crearPaciente(nuevoPaciente);
                            // Luego, puedes navegar de regreso a la vista de pacientes
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor),
                        child: const Text('Guardar'),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Paciente {
  final String nombre;
  final String rut;

  Paciente({
    required this.nombre,
    required this.rut,
  });
}
