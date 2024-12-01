import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:poolclean/utils/global.colors.dart';

class IConfiguracionPiscina extends StatefulWidget {
  const IConfiguracionPiscina({super.key});

  @override
  _IConfiguracionPiscinaState createState() => _IConfiguracionPiscinaState();
}

class _IConfiguracionPiscinaState extends State<IConfiguracionPiscina> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;

  // Controladores para los campos del formulario
  final TextEditingController _tipoPiscinaController = TextEditingController();
  final TextEditingController _largoController = TextEditingController();
  final TextEditingController _anchoController = TextEditingController();
  final TextEditingController _profundidadController = TextEditingController();
  final TextEditingController _diametroController = TextEditingController();
  final TextEditingController _litrajeController = TextEditingController();

  int? piscinaId;

  @override
  void initState() {
    super.initState();
    _cargarDatosPiscina();
  }

  Future<void> _cargarDatosPiscina() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String id_ = (prefs.getInt('user_id') ?? 0).toString();
      String token_ = prefs.getString('auth_token') ?? '';

      if (id_.isNotEmpty && token_.isNotEmpty) {
        final url = Uri.parse(
            'https://poolcleanapi-production.up.railway.app/api/obtenerPiscinas/$id_');
        final response = await http.get(
          url,
          headers: {'Authorization': 'Bearer $token_'},
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          if (data['piscinas'] != null && data['piscinas'].isNotEmpty) {
            final piscina = data['piscinas'][0];

            setState(() {
              _tipoPiscinaController.text = piscina['tipo_piscina'] ?? '';
              _largoController.text =
                  piscina['largo'] != "0.00" ? piscina['largo'] : '';
              _anchoController.text =
                  piscina['ancho'] != "0.00" ? piscina['ancho'] : '';
              _profundidadController.text = piscina['profundidad'] != "0.00"
                  ? piscina['profundidad']
                  : '';
              _diametroController.text =
                  piscina['diametro'] != null ? piscina['diametro'] : '';
              _litrajeController.text = piscina['litraje'] ?? '';

              piscinaId = piscina['piscina_id']; // Guardar piscina_id
            });
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al cargar datos: ${response.body}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('Error al cargar datos: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Hubo un problema al conectar con el servidor.',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.grey,
        ),
      );
    }
  }

  Future<void> _actualizarPiscina() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token_ = prefs.getString('auth_token') ?? '';
      if (piscinaId == null) {
        throw Exception("No se ha cargado el ID de la piscina.");
      }

      final url = Uri.parse(
          'https://poolcleanapi-production.up.railway.app/api/actualizarPiscina/$piscinaId');
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token_',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'tipo_piscina': _tipoPiscinaController.text,
          'largo': _largoController.text,
          'ancho': _anchoController.text,
          'profundidad': _profundidadController.text,
          'diametro': _diametroController.text,
          'litraje': _litrajeController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Piscina actualizada correctamente',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Error al actualizar: ${response.body}');
      }
    } catch (e) {
      print('Error al actualizar piscina: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error al actualizar: $e',
                style: const TextStyle(color: Colors.black)),
            backgroundColor: Colors.grey),
      );
    }
  }

  Future<void> _eliminarPiscina() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token_ = prefs.getString('auth_token') ?? '';
      if (piscinaId == null) {
        throw Exception("No se ha cargado el ID de la piscina.");
      }

      final url = Uri.parse(
          'https://poolcleanapi-production.up.railway.app/api/borrarPiscina/$piscinaId');
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token_',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Piscina eliminada correctamente',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: GlobalColors.mainColor,
          ),
        );
        Navigator.pushReplacementNamed(context, '/ajustespiscina');
      } else {
        throw Exception('Error al eliminar: ${response.body}');
      }
    } catch (e) {
      print('Error al eliminar piscina: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al eliminar piscina: $e',
            style: const TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.grey,
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
          'Detalles de la piscina',
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
                _actualizarPiscina();
              } else if (!_isEditing) {
                setState(() {
                  _isEditing = true;
                });
              }
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isEditing || _tipoPiscinaController.text.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: DropdownButtonFormField<String>(
                        value: _tipoPiscinaController.text.isNotEmpty
                            ? _tipoPiscinaController.text
                            : null,
                        decoration: const InputDecoration(
                          labelText: 'Tipo de Piscina',
                          prefixIcon: Icon(Icons.pool),
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Rectangular',
                            child: Text('Rectangular'),
                          ),
                          DropdownMenuItem(
                            value: 'Ovalada',
                            child: Text('Ovalada'),
                          ),
                          DropdownMenuItem(
                            value: 'Redonda',
                            child: Text('Redonda'),
                          ),
                        ],
                        onChanged: _isEditing
                            ? (value) {
                                setState(() {
                                  _tipoPiscinaController.text = value!;
                                });
                              }
                            : null,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor seleccione un tipo de piscina';
                          }
                          return null;
                        },
                      ),
                    ),
                  if (_largoController.text.isNotEmpty)
                    _buildInputField(
                      label: 'Largo',
                      hint: 'Ingrese el largo de la piscina',
                      controller: _largoController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el largo de la piscina';
                        }
                        return null;
                      },
                      enabled: _isEditing,
                      icon: Icons.straighten,
                    ),
                  if (_anchoController.text.isNotEmpty)
                    _buildInputField(
                      label: 'Ancho',
                      hint: 'Ingrese el ancho de la piscina',
                      controller: _anchoController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el ancho de la piscina';
                        }
                        return null;
                      },
                      enabled: _isEditing,
                      icon: Icons.straighten,
                    ),
                  if (_profundidadController.text.isNotEmpty)
                    _buildInputField(
                      label: 'Profundidad',
                      hint: 'Ingrese la profundidad de la piscina',
                      controller: _profundidadController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese la profundidad';
                        }
                        return null;
                      },
                      enabled: _isEditing,
                      icon: Icons.waves,
                    ),
                  if (_diametroController.text.isNotEmpty)
                    _buildInputField(
                      label: 'Diámetro',
                      hint: 'Ingrese el diámetro de la piscina',
                      controller: _diametroController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el diámetro';
                        }
                        return null;
                      },
                      enabled: _isEditing,
                      icon: Icons.circle,
                    ),
                  if (_litrajeController.text.isNotEmpty)
                    _buildInputField(
                      label: 'Litraje',
                      hint: 'Ingrese el litraje de la piscina',
                      controller: _litrajeController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el litraje';
                        }
                        return null;
                      },
                      enabled: _isEditing,
                      icon: Icons.water_drop,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed:
                  _eliminarPiscina, // Llamar la función de eliminar piscina
              style: ElevatedButton.styleFrom(
                backgroundColor: GlobalColors.mainColor,
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 100.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text(
                'Eliminar',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required String? Function(String?) validator,
    required bool enabled,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
        validator: validator,
      ),
    );
  }
}
