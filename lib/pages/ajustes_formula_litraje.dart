import 'package:flutter/material.dart';
import 'package:poolclean/pages/inicio.dart';
import 'package:poolclean/utils/global.colors.dart';
import 'package:poolclean/widgets/menu.navegacion.dart';
import 'package:poolclean/widgets/text.form.global.dart';
import 'package:google_fonts/google_fonts.dart';

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
        title:  Text(
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
                style:  GoogleFonts.poppins(fontSize: 20),
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
                  child:  Text(
                    'Calcular Litraje',
                    style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: GlobalColors.mainColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child:  Text(
                          'Continuar',
                          style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
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
