import 'dart:html';

import 'package:flutter/material.dart';

import '../../colores.dart';
import '../../components/menuProfesional.dart';

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Espaciado entre las filas
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5.0, top: 10.0),
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style:
                        ElevatedButton.styleFrom(backgroundColor: primaryColor),
                    icon: const Icon(Icons.person_add),
                    label: const Text('Nueva sesión'),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          const Expanded(
            child: SesionesDataTable(),
          ),
        ],
      ),
    );
  }
}

class SesionesDataTable extends StatefulWidget {
  const SesionesDataTable({Key? key}) : super(key: key);

  @override
  _SesionesDataTableState createState() => _SesionesDataTableState();
}

class _SesionesDataTableState extends State<SesionesDataTable> {
  List<Sesion> sesiones = []; // Agrega tus datos de sesiones aquí

  @override
  void initState() {
    // Obtén tus datos de sesiones aquí y actualiza la lista de sesiones
    // Ejemplo: fetchSesionesData().then((data) => setState(() => sesiones = data));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
      columns: const [
        DataColumn(label: Text('ID')),
        DataColumn(label: Text('ID del Paciente')),
        DataColumn(label: Text('Fecha')),
      ],
      source: SesionesDataSource(sesiones),
      rowsPerPage: 5, // Ajusta según sea necesario
    );
  }
}

class SesionesDataSource extends DataTableSource {
  final List<Sesion> _sesiones;

  SesionesDataSource(this._sesiones);

  @override
  DataRow getRow(int index) {
    final sesion = _sesiones[index];
    return DataRow(cells: [
      DataCell(Text(sesion.id)),
      DataCell(Text(sesion.pacienteId)),
      DataCell(Text(sesion.fecha)),
    ]);
  }

  @override
  int get rowCount => _sesiones.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}

class Sesion {
  final String id;
  final String pacienteId;
  final String fecha;

  Sesion({required this.id, required this.pacienteId, required this.fecha});

  factory Sesion.fromJson(Map<String, dynamic> json) {
    return Sesion(
      id: json['_id'],
      pacienteId: json['paciente'],
      fecha: json['fecha'],
    );
  }
}
