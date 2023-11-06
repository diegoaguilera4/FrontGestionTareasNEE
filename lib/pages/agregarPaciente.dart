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
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                child: const Text(
                  'Identificación',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nombreController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre completo',
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor, ingrese un nombre';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: edadController,
                        decoration: const InputDecoration(
                          labelText: 'Edad',
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor, ingrese la edad';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: fechaNacimientoController,
                        decoration: const InputDecoration(
                          labelText: 'Fecha de Nacimiento',
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        keyboardType: TextInputType.datetime,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor, ingrese la fecha de nacimiento';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
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
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor),
                        child: const Text('Guardar'),
                      ),
                    ],
                  ),
                ),
              )
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
