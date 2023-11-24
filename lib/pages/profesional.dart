import 'package:flutter/material.dart';
import 'package:gestiontareas/colores.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../components/sidemenu.dart';

class ProfesionalView extends StatefulWidget {
  final token;
  const ProfesionalView({Key? key, this.token}) : super(key: key);

  @override
  State<ProfesionalView> createState() => _ProfesionalView();
}

class _ProfesionalView extends State<ProfesionalView> {
  late String? email;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    email = jwtDecodedToken['email'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vista Profesional'),
        backgroundColor: secondaryColor,
      ),
      drawer: SideMenu(
        currentPage: 'general',
      ), // Usa la clase SideMenu como el Drawer
      body: Center(
        child: Text(email ?? 'Correo no disponible'),
      ),
    );
  }
}
