import 'dart:html';

import 'package:flutter/material.dart';
import 'package:gestiontareas/colores.dart';
import 'package:gestiontareas/components/cartaTarea.dart';
import 'package:gestiontareas/components/menuPaciente.dart';
import 'package:gestiontareas/responsive.dart';

class TaskView extends StatefulWidget {
  final String token;

  const TaskView({super.key, required this.token});
  @override
  _TaskViewState createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  final List<String> tasks = [
    'Tarea 1',
    'Tarea 2',
    'Tarea 3',
    'Tarea 4',
    'Tarea 5',
    'Tarea 6',
    'Tarea 7',
    'Tarea 8',
    'Tarea 9',
    'Tarea 10',
    // Agrega más tareas según sea necesario
  ];

  late PageController _pageController;
  int _currentIndex = 0; // Inicia en 0 para mostrar la primera tarea

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.8,
      initialPage: _currentIndex,
    );
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
      drawer: MenuPaciente(currentPage: '', token: widget.token),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (Responsive.isMobile(context) || Responsive.isTablet(context)) {
      // Vista para dispositivos móviles
      return PageView.builder(
        controller: _pageController,
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return CartaTarea(task: tasks[index]);
        },
      );
    } else if (Responsive.isDesktop(context)) {
      // Vista para escritorio
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              _pageController.previousPage(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.90,
            child: ListView.builder(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 500.0, // Ancho definido para la carta
                  child: CartaTarea(task: tasks[index]),
                );
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              _pageController.nextPage(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
          ),
        ],
      );
    }

    // Si no es móvil ni de escritorio, puedes manejar otro diseño aquí
    return Container();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
