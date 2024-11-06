// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

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

  @override
  void initState() {
    super.initState();
    fetchTemperature();
    _checkConnectionTimeout();
  }

  Future<void> fetchTemperature() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.4.1/temp'));
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
      elevation: 8.0,
      shadowColor: Colors.grey.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Text('Temperatura',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
