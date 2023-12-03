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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Guardar la ruta actual en las preferencias compartidas
    window.localStorage['currentRoute'] =
        ModalRoute.of(context)!.settings.name!;
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
        title: const Text('Buscar pictogramas'),
        backgroundColor: secondaryColor,
      ),
      drawer: MenuProfesional(),
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
                    try {
                      final results = await searchPictograms(_controller.text);
                      setState(() {
                        _results = results;
                      });
                    } catch (e) {
                      // Manejar la excepción aquí, por ejemplo, puedes imprimir un mensaje o no hacer nada.
                      print('Error during pictogram search: $e');
                      setState(() {
                        _results =
                            []; // Puedes limpiar la lista de resultados si lo deseas.
                      });
                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final result = _results[index];
                return ListTile(
                  leading: Image.network(result.imageUrl),
                  title: Text(result.keyword),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
