import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gestiontareas/pages/agregarPaciente.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

import '../colores.dart';
import '../components/menuProfesional.dart';

class PacientesView extends StatefulWidget {
  final String token;

  const PacientesView({Key? key, required this.token}) : super(key: key);

  @override
  _PacientesViewState createState() => _PacientesViewState();
}

class _PacientesViewState extends State<PacientesView> {
  late List<String>? pacientesID = [];
  late Future<List<Paciente>> _pacientesFuture;
  late _PacientesDataTableState _pacientesDataTableState;

  @override
  void initState() {
    super.initState();
    _pacientesDataTableState = _PacientesDataTableState();
    _initializePacientes();
  }

  void _initializePacientes() async {
    try {
      Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);

      List<dynamic>? pacientesDynamic = jwtDecodedToken['pacientes'];
      if (pacientesDynamic != null) {
        pacientesID =
            pacientesDynamic.map((dynamic item) => item.toString()).toList();
        _pacientesFuture = _fetchPacientes();
      }
    } catch (e) {
      print('Error al decodificar el token: $e');
    }
  }

  Future<List<Paciente>> _fetchPacientes() async {
    try {
      List<Paciente> fetchedPacientes = await getListaPacientes(pacientesID!);
      return fetchedPacientes;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pacientes'),
        backgroundColor: secondaryColor,
      ),
      drawer: MenuProfesional(currentPage: 'pacientes', token: widget.token),
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
                              builder: (context) =>
                                  AgregarPacienteView(token: widget.token),
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
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Agrega la lógica para "Nueva Sesión"
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor),
                        icon: const Icon(Icons.add),
                        label: const Text('Nueva Sesión'),
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
                            builder: (context) =>
                                AgregarPacienteView(token: widget.token),
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
              const SizedBox(width: 16.0),
              if (MediaQuery.of(context).size.width < 768 == false)
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Agrega la lógica para "Nueva Sesión"
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor),
                      icon: const Icon(Icons.add),
                      label: const Text('Nueva Sesión'),
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
                } else {
                  List<Paciente> pacientes = snapshot.data as List<Paciente>;
                  return SingleChildScrollView(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: pacientes != null
                          ? PacientesDataTable(
                              pacientes: pacientes,
                              state: _pacientesDataTableState)
                          : Center(child: CircularProgressIndicator()),
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
    pacientes = widget.pacientes;
    // Inicializa filteredPacientes con la lista completa al inicio
    filteredPacientes = widget.pacientes;
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
      columns: const [
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

Future<List<Paciente>> getListaPacientes(List<String> pacientesIDs) async {
  const String url = "http://localhost:3000/usuario/getPacientesData";

  final Map<String, dynamic> requestBody = {
    "pacientesIds": pacientesIDs,
  };

  final String jsonBody = jsonEncode(requestBody);

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      List<Paciente> pacientes =
          jsonResponse.map((data) => Paciente.fromJson(data)).toList();

      return pacientes;
    } else {
      throw Exception('Error al obtener la lista de pacientes');
    }
  } catch (e) {
    throw Exception('Error de conexión: $e');
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
