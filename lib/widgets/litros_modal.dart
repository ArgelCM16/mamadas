import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:poolclean/pages/configurar_piscinas_page.dart';
import 'package:poolclean/pages/detalles_piscina.dart';
import 'package:poolclean/pages/inicio.dart';
import 'package:poolclean/utils/global.colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:poolclean/widgets/menu.navegacion.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LitrosModal extends StatefulWidget {
  final Function(int) onContinue;

  const LitrosModal({super.key, required this.onContinue});

  @override
  _LitrosModalState createState() => _LitrosModalState();
}

class _LitrosModalState extends State<LitrosModal> {
  final TextEditingController _controller = TextEditingController();
  String? _errorMessage;

  // Function to handle validation and saving data to the backend
  void _validateAndContinue() async {
    final int? litros = int.tryParse(_controller.text);

    if (litros == null || litros <= 0) {
      setState(() {
        _errorMessage = 'Por favor, ingrese un número válido de litros.';
      });
    } else {
      // Calling the API to save the pool data
      final success = await _savePiscinaData(litros);

      if (success) {
        widget.onContinue(litros);
        Navigator.of(context).pop();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        setState(() {
          _errorMessage = 'Hubo un error al guardar la piscina.';
        });
      }
    }
  }

  Future<bool> _savePiscinaData(int litros) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String id_ = prefs.get('user_id')?.toString() ?? '';
      String token_ = prefs.get('auth_token')?.toString() ?? '';

      final response = await http.post(
        Uri.parse('http://localhost:3000/api/crearPiscinaPorLitros'),
        headers: {
          'Authorization': 'Bearer $token_',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'litros': litros,
          'id_usuario': id_,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error al hacer la solicitud: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Ingrese los litros de agua de su piscina',
        style: GoogleFonts.poppins(),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Litros',
              errorText: _errorMessage,
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancelar',
            style: GoogleFonts.poppins(color: Colors.black),
          ),
        ),
        ElevatedButton(
          onPressed: _validateAndContinue,
          style: ElevatedButton.styleFrom(
            backgroundColor: GlobalColors.mainColor,
          ),
          child: Text(
            'Continuar',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
