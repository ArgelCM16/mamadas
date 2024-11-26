import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poolclean/pages/login.dart';
import 'package:poolclean/utils/global.colors.dart';
import 'package:poolclean/widgets/text.form.global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CrearCuentaPage extends StatelessWidget {
  CrearCuentaPage({super.key});

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController contraController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ClipPath(
            clipper: CurvedHeaderClipper(),
            child: Container(
              height: 250,
              color: GlobalColors.mainColor,
              child: Center(
                child: Text(
                  'POOL CLEAN',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 150),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 80),
                    Center(
                      child: Text(
                        'Bienvenido, regístrate aquí',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Form(
                      key: _formKey,
                      child: Container(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            TextGeneralForm(
                              controller: nombreController,
                              text: 'Nombre',
                              obscure: false,
                              textInputType: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'El nombre no puede estar vacío';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 15),
                            TextGeneralForm(
                              controller: apellidosController,
                              text: 'Apellido',
                              obscure: false,
                              textInputType: TextInputType.name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'El apellido no puede estar vacío';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 15),
                            TextGeneralForm(
                              controller: correoController,
                              text: 'Correo',
                              obscure: false,
                              textInputType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'El correo no puede estar vacío';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(value)) {
                                  return 'Introduce un correo válido';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 15),
                            TextGeneralForm(
                              controller: contraController,
                              text: 'Contraseña',
                              obscure: true,
                              textInputType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'La contraseña no puede estar vacía';
                                }
                                if (value.length < 6) {
                                  return 'La contraseña debe tener al menos 6 caracteres';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 15),
                            _ButtonGlobalCuenta(
                              formKey: _formKey,
                              nombreController: nombreController,
                              apellidosController: apellidosController,
                              correoController: correoController,
                              contraController: contraController,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
              '¿Ya tienes cuenta? ',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/sesion');
              },
              child: Text(
                'Inicia sesión',
                style: GoogleFonts.poppins(
                  textStyle: GoogleFonts.poppins(
                    color: GlobalColors.textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TextGeneralForm extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  final bool obscure;
  final TextInputType textInputType;
  final String? Function(String?)? validator;

  const _TextGeneralForm({
    required this.controller,
    required this.text,
    required this.obscure,
    required this.textInputType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: textInputType,
      validator: validator,
      decoration: InputDecoration(
        labelText: text,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}

class _ButtonGlobalCuenta extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nombreController;
  final TextEditingController apellidosController;
  final TextEditingController correoController;
  final TextEditingController contraController;

  _ButtonGlobalCuenta({
    required this.formKey,
    required this.nombreController,
    required this.apellidosController,
    required this.correoController,
    required this.contraController,
  });

  Future<void> _register(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      final Map<String, String> body = {
        'Nombres': nombreController.text,
        'Apellidos': apellidosController.text,
        'Correo': correoController.text,
        'password': contraController.text,
      };

      const String url = 'https://poolcleanapi-production.up.railway.app/api/crearCuenta';

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(body),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Registro exitoso")),
          );
          Navigator.pushReplacementNamed(context, '/sesion');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${response.body}")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error de conexión: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _register(context),
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
              BoxShadow(color: Colors.white.withOpacity(0.1), blurRadius: 5)
            ]),
        child: Text(
          'Crear cuenta',
          style: GoogleFonts.poppins(
              textStyle:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}
