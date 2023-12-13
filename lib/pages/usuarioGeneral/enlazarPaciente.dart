import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:gestiontareas/colores.dart';
import 'package:gestiontareas/components/menuPaciente.dart';
import 'package:http/http.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class EnlazarPaciente extends StatefulWidget {
  const EnlazarPaciente({Key? key}) : super(key: key);

  @override
  _EnlazarPacienteState createState() => _EnlazarPacienteState();
}

class _EnlazarPacienteState extends State<EnlazarPaciente> {
  TextEditingController _codigoController = TextEditingController();

  //funcion para enlazar paciente
  Future<void> _enlazarPaciente() async {
    // Aquí puedes agregar la lógica para enlazar al paciente con el código ingresado
    String codigoIngresado = _codigoController.text;
    Map<String, dynamic> jwtDecodedToken =
          JwtDecoder.decode(window.localStorage['token']!);
    String usuarioId = jwtDecodedToken['usuarioId'];
    // Lógica de enlace de paciente aquí...
    var url = Uri.parse('http://localhost:3000/usuario/addPaciente/$usuarioId');
    var response = await post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({'pacienteId': codigoIngresado}),
          );
    if(response.statusCode == 200){
      print('Paciente enlazado: $codigoIngresado');
      Navigator.pushNamed(context, '/tareas');
      //snackbar de paciente enlazado
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Paciente enlazado'),
          backgroundColor: primaryColor,
        ),
      );
    }
    else{
      print('Error al enlazar paciente: ${response.body}');
      //snackbar de error al enlazar paciente
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al enlazar paciente'),
          backgroundColor: buttonColor1,
        ),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Guardar la ruta actual en las preferencias compartidas
    window.localStorage['currentRoute'] =
        ModalRoute.of(context)!.settings.name!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas asignadas'),
        backgroundColor: secondaryColor,
      ),
      drawer: MenuPaciente(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _codigoController,
              decoration: const InputDecoration(
                labelText: 'Ingrese el código',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _enlazarPaciente();
              },
              child: const Text('Enlazar Paciente'),
            ),
          ],
        ),
      ),
    );
  }
}
