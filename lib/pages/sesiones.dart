import 'dart:html';

import 'package:flutter/material.dart';

import '../colores.dart';
import '../components/menuProfesional.dart';

class SesionesView extends StatefulWidget {
  const SesionesView({super.key});

  @override
  State<SesionesView> createState() => _SesionesViewState();
}

class _SesionesViewState extends State<SesionesView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    window.localStorage['currentRoute'] =
        ModalRoute.of(context)!.settings.name!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vista Profesional'),
        backgroundColor: secondaryColor,
      ),
      drawer: MenuProfesional(currentPage: ''),
      body: const Center(
        child: Text('Sesiones'),
      ),
    );
  }
}
