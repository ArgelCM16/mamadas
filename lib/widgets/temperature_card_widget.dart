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
  double defaultTemperature = 28.0; 
  double? temperature;
  bool isConnected = true;
  Timer? connectionTimer;
  String? poolCleanIp;

  @override
  void initState() {
    super.initState();
    _getStoredIp();
    _checkConnectionTimeout();
  }

  Future<void> _getStoredIp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    poolCleanIp = prefs.getString('Poolcleanip');
    if (poolCleanIp != null) {
      fetchTemperature();
    } else {
      setState(() {
        isConnected = false;
      });
    }
  }

  Future<void> fetchTemperature() async {
    if (poolCleanIp == null) return;

    try {
      final response = await http.get(Uri.parse('http://$poolCleanIp/temp'));
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
    connectionTimer?.cancel();
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
                                : '${defaultTemperature.toStringAsFixed(1)} °C (Cargando...)')
                            : '${defaultTemperature.toStringAsFixed(1)} °C',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
