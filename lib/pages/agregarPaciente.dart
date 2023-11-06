import 'package:flutter/material.dart';
import 'package:gestiontareas/colores.dart';

class AgregarPersonaView extends StatefulWidget {
  @override
  _AgregarPersonaViewState createState() => _AgregarPersonaViewState();
}

class _AgregarPersonaViewState extends State<AgregarPersonaView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController edadController = TextEditingController();
  final TextEditingController fechaNacimientoController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar paciente'),
        backgroundColor: secondaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre Completo'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingrese un nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: edadController,
                decoration: InputDecoration(labelText: 'Edad'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingrese la edad';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: fechaNacimientoController,
                decoration: InputDecoration(labelText: 'Fecha de Nacimiento'),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingrese la fecha de nacimiento';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Aquí debes guardar los datos de la persona en tu base de datos o lista
                    final nuevaPersona = Persona(
                      nombre: nombreController.text,
                      edad: int.parse(edadController.text),
                      fechaNacimiento: fechaNacimientoController.text,
                    );
                    // Luego, puedes navegar de regreso a la vista de pacientes
                    Navigator.pop(context, nuevaPersona);
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Persona {
  final String nombre;
  final int edad;
  final String fechaNacimiento;

  Persona({
    required this.nombre,
    required this.edad,
    required this.fechaNacimiento,
  });
}
