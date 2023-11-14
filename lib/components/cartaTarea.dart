import 'package:flutter/material.dart';
import 'package:gestiontareas/colores.dart';

class CartaTarea extends StatelessWidget {
  final String task;

  CartaTarea({required this.task});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.center, // Alinea el contenido al centro
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    task,
                    style: const TextStyle(fontSize: 20.0),
                    textAlign: TextAlign.center,
                  ),
                  // Descripción
                  Text(
                    'Descripción de la tarea...',
                    style: const TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                  // Imagen (puedes reemplazar el Placeholder con tu propia lógica)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Placeholder(
                      // Reemplazar Placeholder con tu lógica de imagen
                      fallbackWidth: 200.0,
                      fallbackHeight: 200.0,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 16.0,
              right: 16.0,
              child: SizedBox(
                width: 100, 
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                  ),
                  onPressed: () {
                    // Lógica del botón
                  },
                  child: Text('Ver tarea'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
