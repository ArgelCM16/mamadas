import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poolclean/pages/ajustes_iniciales.dart';
import 'package:poolclean/pages/configurar_piscinas_page.dart';
import 'package:poolclean/pages/detalles_piscina.dart';
import 'package:poolclean/pages/informacion_personal.dart';
import 'package:poolclean/pages/login.dart';
import 'package:poolclean/pages/preguntas_frecuentes.dart';
import 'package:poolclean/pages/terminos_condiciones.dart';
import 'package:poolclean/utils/get.clima.dart';
import 'package:poolclean/utils/global.colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poolclean/utils/provider.dart';
import 'package:poolclean/widgets/informacion_personal_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  bool shadowColor = false;
  double? scrolledUnderElevation;
  Future<void> _verificarDatosPiscina(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String id_ = (prefs.getInt('user_id') ?? 0).toString();
      String token_ = prefs.getString('auth_token') ?? '';

      if (id_.isNotEmpty && token_.isNotEmpty) {
        final url = Uri.parse('https://poolcleanapi-production.up.railway.app/api/obtenerPiscinas/$id_');
        final response = await http.get(
          url,
          headers: {'Authorization': 'Bearer $token_'},
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          if (data['piscinas'] != null && data['piscinas'].isNotEmpty) {
            final piscina = data['piscinas'][0];

            if (piscina['piscina_id'] == null) {
              // Si piscina_id es null, navegar a AjustesInicialesPage
              Navigator.pushReplacementNamed(context, '/ajustespiscina');
            } else {
              // Si piscina_id tiene un valor, navegar a ConfigurarPiscinaPage
              Navigator.pushReplacementNamed(context, '/editarpiscina');

            }
          } else {
            Navigator.pushReplacementNamed(context, '/editarpiscina');
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error al obtener datos: ${response.body}',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('Error al verificar datos: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Hubo un problema al conectar con el servidor.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _logOutAndDeleteAccount(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
    Navigator.pushReplacementNamed(context, '/sesion');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const CardProfileImageSettings(),
            const SizedBox(height: 10),
            ListTile(
              shape: const Border(
                bottom: BorderSide(color: Colors.grey, width: 0.2),
                top: BorderSide(color: Colors.grey, width: 0.2),
              ),
              leading: Icon(
                Icons.account_circle_rounded,
                color: GlobalColors.mainColor,
              ),
              title: Text(
                'Información personales',
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w500),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InformacionPersonal()));
              },
            ),
            ListTile(
              shape: const Border(
                bottom: BorderSide(color: Colors.grey, width: 0.2),
              ),
              leading: Icon(
                Icons.storage,
                color: GlobalColors.mainColor,
              ),
              title: Text(
                'Configurar datos de la piscina',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
              onTap: () async {
                await _verificarDatosPiscina(context);
              },
            ),
            ListTile(
              shape: const Border(
                bottom: BorderSide(color: Colors.grey, width: 0.2),
              ),
              leading: Icon(
                Icons.description,
                color: GlobalColors.mainColor,
              ),
              title: Text(
                'Terminos y Condiciones',
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w500),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TerminosCondiciones()));
              },
            ),
            ListTile(
              shape: const Border(
                bottom: BorderSide(color: Colors.grey, width: 0.2),
              ),
              leading: Icon(
                Icons.help_outline,
                color: GlobalColors.mainColor,
              ),
              title: Text(
                'Preguntas frecuentes',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PreguntasFrecuentes(),
                  ),
                );
              },
            ),
            ListTile(
              shape: const Border(
                bottom: BorderSide(color: Colors.grey, width: 0.2),
                top: BorderSide(color: Colors.grey, width: 0.2),
              ),
              leading: Icon(
                Icons.logout,
                color: GlobalColors.mainColor,
              ),
              title: Text(
                'Cerrar sesión',
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w500),
              ),
              onTap: () => _logOutAndDeleteAccount(context),
            ),
          ]),
        ),
      ),
    );
  }
}

class CardProfileImageSettings extends StatefulWidget {
  const CardProfileImageSettings({super.key});

  @override
  State<CardProfileImageSettings> createState() =>
      _CardProfileImageSettingsState();
}

class _CardProfileImageSettingsState extends State<CardProfileImageSettings> {
  String avatarUrl = 'assets/perfil.png';
  String _nombre = '-----';
  String _apellidos = '-----';
  String _correo = '-----';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Método para cargar datos desde SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    // Establecer los datos del usuario en el UserProvider
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // También puedes almacenar los valores localmente si necesitas usarlos más tarde
    setState(() {
      _nombre = prefs.getString('user_name') ?? '-----';
      _apellidos = prefs.getString('user_lastname') ?? '-----';
      _correo = prefs.getString('user_email') ?? '-----';
    });
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 400;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    final userProvider = Provider.of<UserProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 1000,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[200],
        ),
        margin: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: [
                  Container(
                    width: fem * 80,
                    height: fem * 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(avatarUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            userProvider.nombres.isNotEmpty
                                ? userProvider.nombres
                                : _nombre,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            userProvider.apellidos.isNotEmpty
                                ? userProvider.apellidos
                                : _apellidos,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        userProvider.correo.isNotEmpty
                            ? userProvider.correo
                            : _correo,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
