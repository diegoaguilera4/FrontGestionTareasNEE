import 'package:flutter/material.dart';
import 'package:gestiontareas/colores.dart';
import '../components/menuProfesional.dart';

class PacientesView extends StatelessWidget {
  final String token;

  const PacientesView({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pacientes'),
        backgroundColor: secondaryColor,
      ),
      drawer: MenuProfesional(currentPage: 'pacientes', token: token),
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
                          Navigator.pushNamed(context, '/agregarPaciente',
                              arguments: token);
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
                        Navigator.pushNamed(context, '/agregarPaciente',
                            arguments: token);
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
          const SizedBox(height: 16.0), // Espaciado entre las filas
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: PacientesDataTable(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PacientesDataTable extends StatefulWidget {
  @override
  _PacientesDataTableState createState() => _PacientesDataTableState();
}

class _PacientesDataTableState extends State<PacientesDataTable> {
  List<Paciente> pacientes = [];
  List<Paciente> filteredPacientes = [];

  @override
  void initState() {
    super.initState();
    pacientes = getListaPacientes();
    filteredPacientes.addAll(pacientes);
  }

  void filterPacientes(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredPacientes.clear();
        filteredPacientes.addAll(pacientes);
      } else {
        filteredPacientes.clear();
        filteredPacientes.addAll(pacientes.where((paciente) =>
            paciente.nombre.toLowerCase().contains(query.toLowerCase())));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
      columns: const [
        DataColumn(label: Text('Nombre')),
        DataColumn(label: Text('Edad')),
        DataColumn(label: Text('Opciones')),
      ],
      source: PacientesDataSource(filteredPacientes),
    );
  }
}

class Paciente {
  final String nombre;
  final int edad;

  Paciente({required this.nombre, required this.edad});
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
        DataCell(Text(paciente.edad.toString())),
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

List<Paciente> getListaPacientes() {
  // Aquí debes cargar la lista de pacientes desde tus datos.
  // Ejemplo de cómo llenar la lista:
  return [
    Paciente(nombre: "Diego Aguilera", edad: 23),
    Paciente(nombre: "Ana García", edad: 45),
    Paciente(nombre: "Juan Pérez", edad: 32),
    Paciente(nombre: "María López", edad: 28),
    Paciente(nombre: "Carlos Rodríguez", edad: 50),
    Paciente(nombre: "Laura Sánchez", edad: 42),
    Paciente(nombre: "Pedro Martínez", edad: 35),
    Paciente(nombre: "Luisa Fernández", edad: 27),
    Paciente(nombre: "Miguel González", edad: 38),
    Paciente(nombre: "Isabel Torres", edad: 29),
    Paciente(nombre: "Roberto Ramírez", edad: 48),
    Paciente(nombre: "Carmen Ruiz", edad: 33),
    Paciente(nombre: "Javier Vargas", edad: 31),
    Paciente(nombre: "Elena Jiménez", edad: 40),
    Paciente(nombre: "Guillermo Silva", edad: 26),
    Paciente(nombre: "Sofía Ortiz", edad: 34),
    Paciente(nombre: "Alejandro Herrera", edad: 44),
    Paciente(nombre: "Natalia Castro", edad: 37),
    Paciente(nombre: "Andrés Morales", edad: 39),
    // Agrega más pacientes según tus necesidades
  ];
}
