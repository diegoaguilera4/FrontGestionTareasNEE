import 'package:flutter/material.dart';

import '../models/paciente.dart';

class VerPaciente extends StatefulWidget {
  final Paciente paciente;

  VerPaciente({required this.paciente});

  @override
  _verPacienteState createState() => _verPacienteState();
}

class _verPacienteState extends State<VerPaciente> {
  // Aquí puedes implementar la lógica de edición del paciente
  @override
  Widget build(BuildContext context) {
    // Construye la interfaz de edición del paciente aquí
    return const Text('Aquí puedes editar los datos del paciente');
  }
}
