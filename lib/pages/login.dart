import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:poolclean/pages/crear_cuentra.dart';
import 'package:poolclean/pages/home.dart';
import 'package:poolclean/utils/global.colors.dart';
import 'package:poolclean/widgets/menu.navegacion.dart';
import 'package:poolclean/widgets/text.form.global.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importa SharedPreferences

class LoginPage extends StatefulWidget {
  // Cambié a StatefulWidget
  LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController correoController = TextEditingController();
  final TextEditingController contraController = TextEditingController();
  bool _isPasswordVisible =
      false; // Estado para manejar la visibilidad de la contraseña

  Future<void> _login(BuildContext context) async {
    const String apiUrl =
        "https://poolcleanapi-production.up.railway.app/api/login";

    if (correoController.text.isEmpty || contraController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "Correo": correoController.text,
          "password": contraController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['token'] != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', data['token']);
          await prefs.setInt('user_id', data['user']['id']);
          await prefs.setString('user_name', data['user']['Nombres']);
          await prefs.setString('user_lastname', data['user']['Apellidos']);
          await prefs.setString('user_email', data['user']['Correo']);

          // Navega a la siguiente pantalla
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(data['message'] ?? "Credenciales incorrectas")),
          );
        }
      } else if (response.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Usuario o contraseña incorrectos.")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Error del servidor. Intenta más tarde.")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error de conexión: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ClipPath(
            clipper: CurvedHeaderClipper(),
            child: Container(
              height: 280,
              color: GlobalColors.mainColor,
              child: Center(
                child: Text(
                  'Bienvenido',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 150),
                    child: SafeArea(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 90),
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                'POOL CLEAN',
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                  color: GlobalColors.mainColor,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                )),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: Text(
                                'Inicia sesión con tu cuenta',
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                )),
                              ),
                            ),
                            const SizedBox(height: 15),
                            TextGeneralForm(
                              controller: correoController,
                              text: 'Correo',
                              obscure: false,
                              textInputType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 15),
                            // Uso de TextGeneralForm para la contraseña con visibilidad
                            TextGeneralForm(
                              controller: contraController,
                              text: 'Contraseña',
                              obscure: !_isPasswordVisible,
                              textInputType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa tu contraseña';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 15),
                            InkWell(
                              onTap: () => _login(context),
                              child: Container(
                                alignment: Alignment.center,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: GlobalColors.mainColor,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: GlobalColors.colorborde,
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10)
                                    ]),
                                child: Text(
                                  'Iniciar Sesión',
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 50,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¿Aún no tienes cuenta?',
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              )),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CrearCuentaPage(),
                  ),
                );
              },
              child: Text(
                'Crear cuenta',
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        color: GlobalColors.mainColor,
                        fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CurvedHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
