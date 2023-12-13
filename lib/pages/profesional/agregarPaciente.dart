import 'dart:convert';
import 'dart:html';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:gestiontareas/colores.dart';
import 'package:gestiontareas/pages/profesional/pacientes.dart';
import 'package:gestiontareas/pages/page_404.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class AgregarPacienteView extends StatefulWidget {
  final ui.VoidCallback onPacienteAdded;
  AgregarPacienteView({Key? key, required this.onPacienteAdded})
      : super(key: key);

  @override
  _AgregarPacienteViewState createState() => _AgregarPacienteViewState();
}

class _AgregarPacienteViewState extends State<AgregarPacienteView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController rutController = TextEditingController();
  String? idProfesional;

  @override
  void initState() {
    super.initState();
    _initializeEmail();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Guardar la ruta actual en las preferencias compartidas
    window.localStorage['currentRoute'] =
        ModalRoute.of(context)!.settings.name!;
  }

  // Función para inicializar el campo 'email'
  void _initializeEmail() {
    try {
      Map<String, dynamic> jwtDecodedToken =
          JwtDecoder.decode(window.localStorage['token']!);
      idProfesional = jwtDecodedToken['usuarioId'];
    } catch (e) {
      // Manejar cualquier error al decodificar el token, por ejemplo, token no válido.
      print('Error al decodificar el token: $e');
      // Puedes manejar el error de otra manera, como cerrar sesión y volver a la pantalla de inicio.
    }
  }

  Future<void> _crearPaciente(Map<String, String> pacienteData) async {
    try {
      if (nombreController.text.isNotEmpty && rutController.text.isNotEmpty) {
        var url = Uri.parse('http://localhost:3000/paciente/add');
        var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(pacienteData),
        );

        if (response.statusCode == 201) {
          // Cambiado a 201
          var pacienteId = jsonDecode(response.body)['_id'];

          var url2 = Uri.parse(
              'http://localhost:3000/usuario/addPaciente/$idProfesional');
          var response2 = await http.post(
            url2,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({'pacienteId': pacienteId}),
          );

          if (response2.statusCode == 200) {
            // Éxito en ambas solicitudes
            print('Ambas solicitudes completadas con éxito');
            widget.onPacienteAdded();
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PacientesView(),
                settings: const RouteSettings(name: '/pacientes'),
              ),
            );
          } else {
            // Manejar error en la segunda solicitud
            print('Error en la segunda solicitud: ${response2.statusCode}');
          }
        } else {
          // Manejar error en la primera solicitud
          print('Error en la primera solicitud: ${response.statusCode}');
        }
      }
    } catch (error) {
      // Manejar errores generales
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    String token = window.localStorage['token']!;
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token);
    String? rol = jwtDecodedToken['rol'];
    if (rol != "Profesional") {
      return const Page404();
    }
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
