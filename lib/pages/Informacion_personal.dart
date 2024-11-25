import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poolclean/utils/provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:poolclean/utils/global.colors.dart';

class InformacionPersonal extends StatefulWidget {
  const InformacionPersonal({super.key});

  @override
  _InformacionPersonalState createState() => _InformacionPersonalState();
}

class _InformacionPersonalState extends State<InformacionPersonal> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;

  late TextEditingController _nombreController;
  late TextEditingController _apellidosController;
  late TextEditingController _correoController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController();
    _apellidosController = TextEditingController();
    _correoController = TextEditingController();
    _loadUserData();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidosController.dispose();
    _correoController.dispose();
    super.dispose();
  }

  // Cargar los datos del usuario desde SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nombreController.text = prefs.getString('user_name') ?? '';
      _apellidosController.text = prefs.getString('user_lastname') ?? '';
      _correoController.text = prefs.getString('user_email') ?? '';
    });
  }

  // Función para actualizar los datos del usuario
Future<void> _updateUserData() async {
  final prefs = await SharedPreferences.getInstance();
  String id_ = prefs.get('user_id')?.toString() ?? '';
  String token_ = prefs.get('auth_token')?.toString() ?? '';

  String nombre = _nombreController.text;
  String apellidos = _apellidosController.text;
  String correo = _correoController.text;

  try {
    final response = await http.put(
      Uri.parse('http://localhost:3000/api/actualizarUsuario/$id_'),
      headers: {
        'Authorization': 'Bearer $token_',
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        'Nombres': nombre,
        'Apellidos': apellidos,
        'Correo': correo,
      }),
    );

    if (response.statusCode == 200) {
      // Actualizar el Provider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.updateUser(id_, nombre, apellidos, correo);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Datos guardados',
              style: TextStyle(color: Colors.white)),
          backgroundColor: GlobalColors.mainColor,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Hubo un error al guardar los datos',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    print('Error de red: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            const Text('Error de red', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: GlobalColors.mainColor,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        title: Text(
          'Información personal',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isEditing ? Icons.check : Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              if (_isEditing && _formKey.currentState!.validate()) {
                setState(() {
                  _isEditing = false;
                });
                _updateUserData();
              } else if (!_isEditing) {
                setState(() {
                  _isEditing = true;
                });
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildInputField(
                label: 'Nombre',
                hint: 'Ingrese su nombre',
                controller: _nombreController,
                enabled: _isEditing,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildInputField(
                label: 'Apellidos',
                hint: 'Ingrese sus apellidos',
                controller: _apellidosController,
                enabled: _isEditing,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese sus apellidos';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildInputField(
                label: 'Correo Electrónico',
                hint: 'Ingrese su correo electrónico',
                controller: _correoController,
                enabled: _isEditing,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su correo electrónico';
                  }
                  String pattern =
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
                  RegExp regex = RegExp(pattern);
                  if (!regex.hasMatch(value)) {
                    return 'Por favor ingrese un correo electrónico válido';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool enabled,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          enabled: enabled,
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey.shade200,
            hintText: hint,
            hintStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
