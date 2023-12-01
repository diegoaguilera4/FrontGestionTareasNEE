import 'dart:convert';
import 'dart:html';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:gestiontareas/colores.dart';
import 'package:gestiontareas/pages/page_404.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class AgregarTareaView extends StatefulWidget {
  const AgregarTareaView({Key? key}) : super(key: key);

  @override
  State<AgregarTareaView> createState() => _AgregarTareaViewState();
}

class _AgregarTareaViewState extends State<AgregarTareaView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nombreController = TextEditingController();
  String? asignacion;
  String? repeticion;
  Color casaButtonColor = buttonColor2;
  Color colegioButtonColor = buttonColor2;
  List<TextEditingController> instruccionesControllers = [
    TextEditingController()
  ];

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
    if (rol != "Profesional") {
      return const Page404();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar tarea'),
        backgroundColor: secondaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                    'Nueva tarea',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: nombreController,
                                decoration: const InputDecoration(
                                  labelText: 'Nombre de la tarea',
                                  border: OutlineInputBorder(),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Por favor, ingrese un nombre para la tarea';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 5),
                            if (MediaQuery.of(context).size.width > 768)
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      asignacion = 'Casa';
                                      casaButtonColor = buttonColor1;
                                      colegioButtonColor = buttonColor2;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: casaButtonColor,
                                  ),
                                  icon: const Icon(Icons.home),
                                  label: const Text('Casa'),
                                ),
                              ),
                            if (MediaQuery.of(context).size.width > 768)
                              const SizedBox(width: 5),
                            if (MediaQuery.of(context).size.width > 768)
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      asignacion = 'Colegio';
                                      colegioButtonColor = buttonColor1;
                                      casaButtonColor = buttonColor2;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: colegioButtonColor,
                                  ),
                                  icon: const Icon(Icons.school),
                                  label: const Text('Colegio'),
                                ),
                              ),
                            if (MediaQuery.of(context).size.width > 768)
                              const SizedBox(width: 5),
                            if (MediaQuery.of(context).size.width > 768)
                              Expanded(
                                flex: 1,
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor),
                                  icon: const Icon(Icons.add_a_photo),
                                  label: const Text('Agregar imagen'),
                                ),
                              ),
                            if (MediaQuery.of(context).size.width > 768)
                              const SizedBox(width: 5),
                            if (MediaQuery.of(context).size.width > 768)
                              DropdownButton<String>(
                                dropdownColor: Colors.white,
                                value: repeticion,
                                onChanged: (value) {
                                  setState(() {
                                    repeticion = value;
                                  });
                                },
                                items: const [
                                  DropdownMenuItem(
                                    value: 'todos los dias',
                                    child: Text('Todos los días'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'una vez a la semana',
                                    child: Text('Una vez a la semana'),
                                  ),
                                ],
                                hint: const Text('Repetición'),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        Row(
                          children: [
                            if (MediaQuery.of(context).size.width <= 768)
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      asignacion = 'Casa';
                                      casaButtonColor = buttonColor1;
                                      colegioButtonColor = buttonColor2;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: casaButtonColor,
                                  ),
                                  icon: const Icon(Icons.home),
                                  label: const Text('Casa'),
                                ),
                              ),
                            const SizedBox(width: 5),
                            if (MediaQuery.of(context).size.width <= 768)
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      asignacion = 'Colegio';
                                      colegioButtonColor = buttonColor1;
                                      casaButtonColor = buttonColor2;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: colegioButtonColor,
                                  ),
                                  icon: const Icon(Icons.school),
                                  label: const Text('Colegio'),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            if (MediaQuery.of(context).size.width <= 768)
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor),
                                  icon: const Icon(Icons.add_a_photo),
                                  label: const Text('Agregar imagen'),
                                ),
                              ),
                          ],
                        ),
                        Row(
                          children: [
                            if (MediaQuery.of(context).size.width <= 768)
                              DropdownButton<String>(
                                dropdownColor: Colors.white,
                                value: repeticion,
                                onChanged: (value) {
                                  setState(() {
                                    repeticion = value;
                                  });
                                },
                                items: const [
                                  DropdownMenuItem(
                                    value: 'todos los dias',
                                    child: Text('Todos los días'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'una vez a la semana',
                                    child: Text('Una vez a la semana'),
                                  ),
                                ],
                                hint: const Text('Repetición'),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text('Instrucciones',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        // Lista dinámica de instrucciones
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: instruccionesControllers.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 40,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        child: TextField(
                                          controller:
                                              instruccionesControllers[index],
                                          style:
                                              const TextStyle(fontSize: 16.0),
                                          cursorColor: Colors.transparent,
                                          maxLines: 3,
                                          onChanged: (value) {
                                            // Lógica para manejar el cambio de texto
                                          },
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                          // Otros atributos de estilo y comportamiento
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: buttonColor1,
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            instruccionesControllers
                                                .removeAt(index);
                                          });
                                        },
                                        icon: const Icon(Icons.delete),
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                    height: 10), // Espacio entre las filas
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        // Botón para agregar más instrucciones
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              instruccionesControllers
                                  .add(TextEditingController());
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor),
                          icon: const Icon(Icons.add),
                          label: const Text('Agregar instrucción'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (asignacion == null) {
                                // Mostrar mensaje al usuario sobre la asignación no seleccionada
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Por favor, seleccione una asignación.'),
                                    backgroundColor: buttonColor1,
                                  ),
                                );
                                return;
                              }

                              if (repeticion == null) {
                                // Mostrar mensaje al usuario sobre la repetición no seleccionada
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Por favor, seleccione una repetición.'),
                                    backgroundColor: buttonColor1,
                                  ),
                                );
                                return;
                              }
                              //recorrer instrucciones y validar que no esten vacias
                              for (var i = 0;
                                  i < instruccionesControllers.length;
                                  i++) {
                                if (instruccionesControllers[i].text.isEmpty) {
                                  // Mostrar mensaje al usuario sobre la repetición no seleccionada
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Por favor, ingrese todas las instrucciones.'),
                                      backgroundColor: buttonColor1,
                                    ),
                                  );
                                  return;
                                }
                              }
                              //validar que instrucciones tenga al menos una instruccion
                              if (instruccionesControllers.isEmpty) {
                                // Mostrar mensaje al usuario sobre la repetición no seleccionada
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Por favor, ingrese al menos una instrucción.'),
                                    backgroundColor: buttonColor1,
                                  ),
                                );
                                return;
                              }
                              Map<String, dynamic> nuevaTarea = {
                                'nombre': nombreController.text,
                                'estado': 'recien creada',
                                'imagen': '.',
                                'asignacion': asignacion!,
                                'repeticion': repeticion,
                                'instrucciones': instruccionesControllers
                                    .map((controller) => controller.text)
                                    .toList(),
                              };
                              _crearTarea(nuevaTarea);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor),
                          icon: const Icon(Icons.add_task),
                          label: const Text('Crear tarea'),
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _crearTarea(Map<String, dynamic> tareaData) async {
    try {
      // Lógica para enviar la tarea al servidor o almacenarla localmente
      // Puedes adaptar la lógica de _crearPaciente en AgregarPacienteView para tus necesidades de tareas
      //transformar instrucciones a instruccion: {descripcion: intruccion[i]}
      List<Map<String, dynamic>> instrucciones = [];
      for (var i = 0; i < tareaData['instrucciones'].length; i++) {
        instrucciones.add({
          'descripcion': tareaData['instrucciones'][i],
        });
      }
      tareaData['instrucciones'] = instrucciones;
      var url = Uri.parse('http://localhost:3000/tarea/add');
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(tareaData),
      );
      //Comprobar el envio con response.statusCode
      if (response.statusCode == 201) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tarea creada exitosamente.'),
            backgroundColor: buttonColor1,
          ),
        );
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, '/sesiones');
      } else {
        throw Exception('Error al crear la tarea');
      }
    } catch (error) {
      // Manejar errores generales
      print('Error: $error');
    }
  }
}
