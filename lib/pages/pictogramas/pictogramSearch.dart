import 'dart:html';
import 'package:flutter/material.dart';
import 'package:gestiontareas/components/menuProfesional.dart';
import 'package:gestiontareas/pages/pictogramas/pictograma.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../colores.dart';
import '../page_404.dart';

class PictogramSearchView extends StatefulWidget {
  @override
  _PictogramSearchViewState createState() => _PictogramSearchViewState();
}

class _PictogramSearchViewState extends State<PictogramSearchView> {
  final TextEditingController _controller = TextEditingController();
  List<PictogramResult> _results = [];
  PictogramResult pictogramResult = PictogramResult(
    id: 0,
    keyword: '',
    imageUrl: '',
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Guardar la ruta actual en las preferencias compartidas
    window.localStorage['currentRoute'] =
        ModalRoute.of(context)!.settings.name!;
  }

  void _performSearch() async {
    try {
      if (_controller.text.isNotEmpty) {
        final results = await searchPictograms(_controller.text);
        setState(() {
          _results = results;
        });
      }
    } catch (e) {
      // Manejar la excepción aquí, por ejemplo, puedes imprimir un mensaje o no hacer nada.
      print('Error during pictogram search: $e');
      setState(() {
        _results = []; // Puedes limpiar la lista de resultados si lo deseas.
      });
    }
  }

  void _handleItemSelected(PictogramResult selectedResult) {
    // Cerrar el cuadro de diálogo y pasar el pictograma seleccionado como resultado
    pictogramResult = selectedResult;
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
        title: const Text('Buscar pictograma'),
        backgroundColor: secondaryColor,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Buscar',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () async {
                    _performSearch();
                  },
                ),
              ),
              onSubmitted: (String value) async {
                _performSearch();
              },
            ),
          ),
          Expanded(
            child: _results != null && _results.isNotEmpty
                ? ListView.builder(
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final result = _results[index];
                      return InkWell(
                        onTap: () {
                          _handleItemSelected(result);
                        },
                        child: ListTile(
                          leading: Image.network(result.imageUrl),
                          title: Text(result.keyword),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      'No se encontraron resultados',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Lógica para guardar aquí
          Navigator.pop(context, pictogramResult);
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.save), // Cambia el color según tu diseño
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 50.0,
        ),
      ),
    );
  }
}
