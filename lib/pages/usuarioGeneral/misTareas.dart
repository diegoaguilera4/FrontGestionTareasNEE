import 'package:flutter/material.dart';
import 'package:gestiontareas/colores.dart';
import 'package:gestiontareas/components/cartaTarea.dart';
import 'package:gestiontareas/components/menuPaciente.dart';
import 'package:gestiontareas/pages/page_404.dart';
import 'package:gestiontareas/responsive.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:html';
import 'package:jwt_decoder/jwt_decoder.dart';

class TaskView extends StatefulWidget {
  const TaskView({super.key});
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
  late Future<List<Paciente>> pacientes;

  String? _selectedPacienteId;
  List<Paciente> _pacientes = [];

  @override
  void initState() {
    super.initState();
    pacientes = _obtenerPacientes();
    _pageController = PageController(
      viewportFraction: 0.8,
      initialPage: _currentIndex,
    );
  }

  Future<List<Paciente>> _obtenerPacientes() async {
    try {
      String myToken = window.localStorage['token']!;
      Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(myToken);
      String usuarioId = jwtDecodedToken['usuarioId'];

      var url =
          Uri.parse('http://localhost:3000/usuario/getMisPacientes/$usuarioId');
      var response = await get(url);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        List<Paciente> pacientes =
            List<Paciente>.from(jsonResponse.map((dynamic item) {
          return Paciente.fromJson(item as Map<String, dynamic>);
        }));

        return pacientes;
      } else {
        throw Exception('Error al obtener la lista de pacientes');
      }
    } catch (e) {
      print('Error al obtener la lista de pacientes: $e');
      throw e;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    window.localStorage['currentRoute'] =
        ModalRoute.of(context)!.settings.name!;
  }

  @override
  Widget build(BuildContext context) {
    String token = window.localStorage['token']!;
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token);
    String? rol = jwtDecodedToken['rol'];
    if (rol == "Profesional") {
      return const Page404();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas asignadas'),
        backgroundColor: secondaryColor,
      ),
      drawer: MenuPaciente(),
      body: Column(
        children: [
          _buildPacienteDropdown(),
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildPacienteDropdown() {
  return FutureBuilder<List<Paciente>>(
    future: pacientes,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return const Text('Error al cargar pacientes');
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Text('No hay pacientes disponibles');
      } else {
        _pacientes = snapshot.data!;
        return DropdownButton<String>(
          value: _selectedPacienteId,
          hint: const Text('Seleccionar Paciente'),
          onChanged: (String? value) {
            setState(() {
              _selectedPacienteId = value;
            });
          },
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              color: secondaryColor,
              fontSize: 16,
            ),
          ),
          icon: const Icon(Icons.arrow_drop_down, color: secondaryColor),
          dropdownColor: Colors.white,
          items: _pacientes.map((Paciente paciente) {
            return DropdownMenuItem<String>(
              value: paciente.id,
              child: Text(
                paciente.nombre,
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
    },
  );
}


  Widget _buildBody() {
    if (Responsive.isMobile(context) || Responsive.isTablet(context)) {
      return PageView.builder(
        controller: _pageController,
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return CartaTarea(task: tasks[index]);
        },
      );
    } else if (Responsive.isDesktop(context)) {
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

    return Container();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class Paciente {
  final String id;
  final String nombre;
  final String rut;
  Paciente({required this.id, required this.nombre, required this.rut});

  factory Paciente.fromJson(Map<String, dynamic> json) {
    return Paciente(
      id: json['_id'],
      nombre: json['nombre'],
      rut: json['rut'],
    );
  }
}
