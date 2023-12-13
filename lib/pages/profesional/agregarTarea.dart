import 'dart:convert';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:gestiontareas/colores.dart';
import 'package:gestiontareas/pages/page_404.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import '../pictogramas/pictograma.dart';

class AgregarTareaView extends StatefulWidget {
  const AgregarTareaView({Key? key}) : super(key: key);

  @override
  State<AgregarTareaView> createState() => _AgregarTareaViewState();
}

class _AgregarTareaViewState extends State<AgregarTareaView> {
  String? rol;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nombreController = TextEditingController();
  String? asignacion;
  String? repeticion;
  Color casaButtonColor = buttonColor2;
  Color colegioButtonColor = buttonColor2;
  List<TextEditingController> instruccionesControllers = [
    TextEditingController()
  ];
  PictogramResult? pictogramResult =
      PictogramResult(id: 0, keyword: 'xd', imageUrl: '');

  @override
  void initState() {
    super.initState();
    _initializeRol();
  }

  void _initializeRol() {
    try {
      Map<String, dynamic> jwtDecodedToken =
          JwtDecoder.decode(window.localStorage['token']!);
      rol = jwtDecodedToken['rol'];
    } catch (e) {
      print('Error al decodificar el token: $e');
    }
  }

  void actualizarPictogramResult(PictogramResult? nuevoResultado) {
    setState(() {
      pictogramResult = nuevoResultado;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    window.localStorage['currentRoute'] =
        ModalRoute.of(context)!.settings.name!;
  }

  @override
  Widget build(BuildContext context) {
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
                if (pictogramResult?.imageUrl != '')
                  Image.network(
                    pictogramResult?.imageUrl ??
                        '', // Asegúrate de manejar el caso en que imageUrl sea nulo
                    width: 100, // ajusta el ancho según tus necesidades
                    height: 100, // ajusta la altura según tus necesidades
                    fit: BoxFit
                        .cover, // o utiliza otro método de ajuste según tus necesidades
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
                            if (MediaQuery.of(context).size.width > 820)
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
                            if (MediaQuery.of(context).size.width > 820)
                              const SizedBox(width: 5),
                            if (MediaQuery.of(context).size.width > 820)
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
                            if (MediaQuery.of(context).size.width > 820)
                              const SizedBox(width: 5),
                            if (MediaQuery.of(context).size.width > 820)
                              Expanded(
                                flex: 1,
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    var pictogramaSeleccionado =
                                        await Navigator.pushNamed(
                                            context, '/pictogramas');
                                    if (pictogramaSeleccionado != null) {
                                      actualizarPictogramResult(
                                          pictogramaSeleccionado
                                              as PictogramResult?);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor),
                                  icon: const Icon(Icons.add_a_photo),
                                  label: const Text('Agregar pictograma'),
                                ),
                              ),
                            if (MediaQuery.of(context).size.width > 820)
                              const SizedBox(width: 5),
                            if (MediaQuery.of(context).size.width > 820)
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
                            if (MediaQuery.of(context).size.width <= 820)
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
                            if (MediaQuery.of(context).size.width <= 820)
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
                            if (MediaQuery.of(context).size.width <= 820)
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    var pictogramaSeleccionado =
                                        await Navigator.pushNamed(
                                            context, '/pictogramas');
                                    if (pictogramaSeleccionado != null) {
                                      actualizarPictogramResult(
                                          pictogramaSeleccionado
                                              as PictogramResult?);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor),
                                  icon: const Icon(Icons.add_a_photo),
                                  label: const Text('Agregar pictograma'),
                                ),
                              ),
                          ],
                        ),
                        Row(
                          children: [
                            if (MediaQuery.of(context).size.width <= 820)
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
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Por favor, seleccione una repetición.'),
                                    backgroundColor: buttonColor1,
                                  ),
                                );
                                return;
                              }
                              for (var i = 0;
                                  i < instruccionesControllers.length;
                                  i++) {
                                if (instruccionesControllers[i].text.isEmpty) {
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
                              if (instruccionesControllers.isEmpty) {
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
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tarea creada exitosamente.'),
            backgroundColor: buttonColor1,
          ),
        );
        Navigator.pushNamed(context, '/sesiones');
      } else {
        throw Exception('Error al crear la tarea');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
}
