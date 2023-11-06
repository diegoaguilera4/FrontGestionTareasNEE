import 'package:flutter/material.dart';
import 'package:gestiontareas/colores.dart';

import '../components/sidemenu.dart';

class ProfesionalView extends StatelessWidget {
  const ProfesionalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vista Profesional'),
        backgroundColor: secondaryColor,
      ),
      drawer: SideMenu(
        currentPage: 'general',
      ), // Usa la clase SideMenu como el Drawer
      body: const Center(
        child: Text('Dashboard'),
      ),
    );
  }
}
