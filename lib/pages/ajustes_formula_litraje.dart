import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:poolclean/pages/detalles_piscina.dart';
import 'package:poolclean/pages/inicio.dart';
import 'package:poolclean/utils/global.colors.dart';
import 'package:poolclean/widgets/menu.navegacion.dart';
import 'package:poolclean/widgets/text.form.global.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CalcularLitrajePage extends StatefulWidget {
  const CalcularLitrajePage({super.key});

  @override
  State<CalcularLitrajePage> createState() => _CalcularLitrajePageState();
}

class _CalcularLitrajePageState extends State<CalcularLitrajePage> {
  final TextEditingController _anchoController = TextEditingController();
  final TextEditingController _largoController = TextEditingController();
  final TextEditingController _profundidadController = TextEditingController();
  final TextEditingController _diametroController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  double? _litraje;
  String _tipoPiscina = 'Rectangular';

  void _calcularLitraje() {
    if (_formKey.currentState!.validate()) {
      final double ancho = double.tryParse(_anchoController.text) ?? 0;
      final double largo = double.tryParse(_largoController.text) ?? 0;
      final double profundidad =
          double.tryParse(_profundidadController.text) ?? 0;
      final double diametro = double.tryParse(_diametroController.text) ?? 0;

      setState(() {
        switch (_tipoPiscina) {
          case 'Rectangular':
            _litraje = largo * ancho * profundidad * 1000;
            break;
          case 'Ovalada':
            _litraje = largo * ancho * profundidad * 0.89 * 1000;
            break;
          case 'Redonda':
            _litraje = diametro * diametro * profundidad * 0.785 * 1000;
            break;
        }
      });
    }
  }

Future<void> _guardarPiscina() async {
  final prefs = await SharedPreferences.getInstance();
  String id_ = prefs.get('user_id')?.toString() ?? '';
  String token_ = prefs.get('auth_token')?.toString() ?? '';

  final double ancho = double.tryParse(_anchoController.text) ?? 0;
  final double largo = double.tryParse(_largoController.text) ?? 0;
  final double profundidad = double.tryParse(_profundidadController.text) ?? 0;
  final double diametro = double.tryParse(_diametroController.text) ?? 0;

  try {
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/crearPiscina'),
      headers: {
        'Authorization': 'Bearer $token_',
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        'id_usuario': id_,
        'tipo_piscina': _tipoPiscina,
        'ancho': ancho,
        'largo': largo,
        'profundidad': profundidad,
        'diametro': diametro,
      }),
    );

    // Imprime el código de estado y el cuerpo de la respuesta para depuración
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:  Text('Piscina guardada correctamente.',
              style: TextStyle(color: Colors.white)),
          backgroundColor: GlobalColors.mainColor,
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      // Manejo de errores con mensaje del servidor
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al guardar: ${response.body}',
            style: const TextStyle(color: Colors.black),
          ),
        backgroundColor: Colors.grey[500],
        ),
      );
    }
  } catch (e) {
    print('Error al guardar piscina: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Hubo un problema al conectar con el servidor.',
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.grey[500],
      ),
    );
  }
}


  void _limpiarFormulario() {
    _anchoController.clear();
    _largoController.clear();
    _profundidadController.clear();
    _diametroController.clear();
    _formKey.currentState?.reset();
    setState(() {
      _litraje = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calcular la cantidad de litros de la Piscina',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: GlobalColors.mainColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                "Seleccione la forma de su piscina",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 20),
              ),
              DropdownButton<String>(
                value: _tipoPiscina,
                items: <String>['Rectangular', 'Ovalada', 'Redonda']
                    .map((String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _tipoPiscina = newValue!;
                    _limpiarFormulario();
                  });
                },
              ),
              const SizedBox(height: 20),
              if (_tipoPiscina != 'Redonda')
                TextGeneralForm(
                  maxLength: 3,
                  controller: _largoController,
                  text: 'Largo (m)',
                  textInputType: TextInputType.number,
                  obscure: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese el largo';
                    }
                    if (double.tryParse(value) == null ||
                        double.parse(value) <= 0) {
                      return 'Ingrese un valor válido y positivo';
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 20),
              if (_tipoPiscina != 'Redonda')
                TextGeneralForm(
                  maxLength: 3,
                  controller: _anchoController,
                  text: 'Ancho (m)',
                  textInputType: TextInputType.number,
                  obscure: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese el ancho';
                    }
                    if (double.tryParse(value) == null ||
                        double.parse(value) <= 0) {
                      return 'Ingrese un valor válido y positivo';
                    }
                    return null;
                  },
                ),
              if (_tipoPiscina == 'Redonda')
                TextGeneralForm(
                  maxLength: 3,
                  controller: _diametroController,
                  text: 'Diámetro (m)',
                  textInputType: TextInputType.number,
                  obscure: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese el diámetro';
                    }
                    if (double.tryParse(value) == null ||
                        double.parse(value) <= 0) {
                      return 'Ingrese un valor válido y positivo';
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 20),
              TextGeneralForm(
                maxLength: 3,
                controller: _profundidadController,
                text: 'Profundidad media (m)',
                textInputType: TextInputType.number,
                obscure: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese la profundidad media';
                  }
                  if (double.tryParse(value) == null ||
                      double.parse(value) <= 0) {
                    return 'Ingrese un valor válido y positivo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: _calcularLitraje,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GlobalColors.mainColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Calcular Litraje',
                    style:
                        GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_litraje != null)
                Column(
                  children: [
                    Text(
                      'Litraje estimado: ${_litraje!.toStringAsFixed(2)} litros',
                      style: GoogleFonts.poppins(
                        color: GlobalColors.textColor,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: _guardarPiscina,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: GlobalColors.mainColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Guardar Piscina',
                          style: GoogleFonts.poppins(
                              fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
