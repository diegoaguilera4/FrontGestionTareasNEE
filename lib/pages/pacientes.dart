import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:gestiontareas/pages/agregarPaciente.dart';
import 'package:gestiontareas/pages/page_404.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

import '../colores.dart';
import '../components/menuProfesional.dart';

class PacientesView extends StatefulWidget {
  const PacientesView({
    Key? key,
  }) : super(key: key);

  @override
  _PacientesViewState createState() => _PacientesViewState();
}

class _PacientesViewState extends State<PacientesView> {
  late Future<List<Paciente>> _pacientesFuture;
  _PacientesDataTableState _pacientesDataTableState =
      _PacientesDataTableState();

  @override
  void initState() {
    super.initState();
    _pacientesDataTableState = _PacientesDataTableState();
    _pacientesFuture = _fetchPacientes(); // Inicializar _pacientesFuture aquí
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Guardar la ruta actual en las preferencias compartidas
    window.localStorage['currentRoute'] =
        ModalRoute.of(context)!.settings.name!;
  }

  Future<List<Paciente>> _fetchPacientes() async {
    try {
      String myToken;
      myToken = window.localStorage['token']!;
      Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(myToken);
      String profesionalId = jwtDecodedToken['usuarioId'];

      // Obtener lista de pacientes directamente desde /getMisPacientes
      var url = Uri.parse(
          'http://localhost:3000/usuario/getMisPacientes/$profesionalId');
      var response = await http.get(url);

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

  void filterPacientes(String query) {
    setState(() {
      if (query.isEmpty) {
        _pacientesDataTableState.clearFilter();
      } else {
        _pacientesDataTableState.filterPacientes(query);
      }
    });
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
        title: const Text('Pacientes'),
        backgroundColor: secondaryColor,
      ),
      drawer: MenuProfesional(currentPage: ''),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (MediaQuery.of(context).size.width < 768)
            Padding(
              padding: const EdgeInsets.only(left: 5.0, top: 16.0, right: 5.0),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AgregarPacienteView(
                                onPacienteAdded: () {
                                  // Esta función se ejecutará después de regresar desde AgregarPacienteView
                                  _refreshPacientes();
                                },
                              ),
                              settings: RouteSettings(name: '/agregarPaciente'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor),
                        icon: const Icon(Icons.person_add),
                        label: const Text('Agregar Paciente'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16.0), // Espaciado entre las filas
          Row(
            children: [
              if (MediaQuery.of(context).size.width < 768 == false)
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AgregarPacienteView(
                              onPacienteAdded: () {
                                // Esta función se ejecutará después de regresar desde AgregarPacienteView
                                _refreshPacientes();
                              },
                            ),
                            settings: RouteSettings(name: '/agregarPaciente'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor),
                      icon: const Icon(Icons.person_add),
                      label: const Text('Agregar Paciente'),
                    ),
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    onChanged: (query) {
                      // Puedes realizar búsquedas aquí
                      filterPacientes(query);
                    },
                    decoration: const InputDecoration(
                      labelText: 'Buscar por nombre',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: FutureBuilder(
              future: _pacientesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData ||
                    (snapshot.data as List<Paciente>).isEmpty) {
                  return Center(child: Text('No se encontraron pacientes.'));
                } else {
                  List<Paciente> pacientes = snapshot.data as List<Paciente>;
                  return SingleChildScrollView(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: PacientesDataTable(
                        pacientes: pacientes,
                        state: _pacientesDataTableState,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Función para actualizar la lista de pacientes después de agregar uno nuevo
  void _refreshPacientes() {
    setState(() {
      _pacientesFuture = _fetchPacientes();
    });
  }
}

class PacientesDataTable extends StatefulWidget {
  final List<Paciente> pacientes;
  final _PacientesDataTableState state;

  PacientesDataTable({required this.pacientes, required this.state});

  @override
  _PacientesDataTableState createState() => state;
}

class _PacientesDataTableState extends State<PacientesDataTable> {
  late List<Paciente> pacientes;
  List<Paciente> filteredPacientes = [];

  _PacientesDataTableState();

  @override
  void initState() {
    super.initState();
    pacientes = List.from(widget.pacientes);
    filteredPacientes = List.from(widget.pacientes);
  }

  void clearFilter() {
    setState(() {
      // Restaura filteredPacientes a la lista completa
      filteredPacientes = List.from(pacientes);
    });
  }

  void filterPacientes(String query) {
    setState(() {
      if (query.isEmpty) {
        clearFilter();
      } else {
        filteredPacientes = pacientes
            .where((paciente) =>
                paciente.nombre.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
      columns: [
        DataColumn(label: Text('Nombre')),
        DataColumn(label: Text('Rut')),
        DataColumn(label: Text('Opciones')),
      ],
      source: PacientesDataSource(filteredPacientes),
    );
  }
}

class PacientesDataSource extends DataTableSource {
  final List<Paciente> _pacientes;

  PacientesDataSource(this._pacientes);

  @override
  DataRow getRow(int index) {
    final paciente = _pacientes[index];
    return DataRow(
      cells: [
        DataCell(Text(paciente.nombre)),
        DataCell(Text(paciente.rut)),
        DataCell(Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.edit_note,
                color: primaryColor,
              ),
              onPressed: () {
                // Agrega la lógica para editar el paciente
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: buttonColor1,
              ),
              onPressed: () {
                // Agrega la lógica para eliminar el paciente
              },
            ),
          ],
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _pacientes.length;

  @override
  int get selectedRowCount => 0;
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
