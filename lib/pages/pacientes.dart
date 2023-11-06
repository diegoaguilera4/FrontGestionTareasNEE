import 'package:flutter/material.dart';
import 'package:gestiontareas/colores.dart';

import '../components/sidemenu.dart';

class PacientesView extends StatelessWidget {
  const PacientesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pacientes'),
        backgroundColor: secondaryColor,
      ),
      drawer: SideMenu(
        currentPage: 'pacientes',
      ), // Usa la clase SideMenu como el Drawer
      body: const Center(
        child: Text('Tabla pacientes'),
      ),
    );
  }
}
