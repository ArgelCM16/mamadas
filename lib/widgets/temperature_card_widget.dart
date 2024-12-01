// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Importa SharedPreferences

class TemperatureCard extends StatefulWidget {
  const TemperatureCard({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TemperatureCardState createState() => _TemperatureCardState();
}

class _TemperatureCardState extends State<TemperatureCard> {
  double? temperature;
  bool isConnected = true;
  Timer? connectionTimer;
  String? poolCleanIp; // Variable para almacenar la IP

  @override
  void initState() {
    super.initState();
    _getStoredIp(); // Obtener la IP almacenada al iniciar
    _checkConnectionTimeout();
  }

  // Método para obtener la IP almacenada en SharedPreferences
  Future<void> _getStoredIp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    poolCleanIp = prefs.getString('Poolcleanip'); // Obtiene la IP
    if (poolCleanIp != null) {
      fetchTemperature(); // Llama a la función para obtener la temperatura si la IP está disponible
    } else {
      setState(() {
        isConnected = false; // Si no hay IP, marca como no conectado
      });
    }
  }

  Future<void> fetchTemperature() async {
    if (poolCleanIp == null) return; // Si no hay IP, no hace la solicitud

    try {
      final response = await http
          .get(Uri.parse('http://$poolCleanIp/temp')); // Usa la IP obtenida
      if (response.statusCode == 200 && mounted) {
        setState(() {
          temperature = double.parse(response.body);
          isConnected = true;
        });
      } else {
        throw Exception('Error al obtener la temperatura');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isConnected = false;
        });
      }
    }
  }

  void _checkConnectionTimeout() {
    connectionTimer = Timer(const Duration(seconds: 3), () {
      if (temperature == null && mounted) {
        setState(() {
          isConnected = false;
        });
      }
    });
  }

  @override
  void dispose() {
    connectionTimer?.cancel(); // Cancelar el Timer al destruir el widget
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: Offset(4, 4),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                Text('Temperatura',
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.thermostat_rounded,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          isConnected
                              ? (temperature != null
                                  ? '${temperature!.toStringAsFixed(1)} °C'
                                  : 'Cargando...')
                              : 'No conectado',
                          style: GoogleFonts.poppins(
                              color: Colors.grey[700],
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
