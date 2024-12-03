import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PhCard extends StatefulWidget {
  const PhCard({super.key});

  @override
  _PhCardState createState() => _PhCardState();
}

class _PhCardState extends State<PhCard> {
  final double defaultPh =7.6; // Valor predeterminado para el pH
  double ph = 7.6; 
  bool isConnected = true;
  bool isLoading = true; // Estado para controlar el texto de carga
  Timer? connectionTimer;
  String? poolCleanIp;

  @override
  void initState() {
    super.initState();
    _getStoredIp();
    _checkConnectionTimeout();
    _simulateLoading(); // Simular carga inicial
  }

  Future<void> _simulateLoading() async {
    // Esperar 10 segundos antes de mostrar el valor real
    await Future.delayed(const Duration(seconds: 10));
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _getStoredIp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    poolCleanIp = prefs.getString('Poolcleanip');
    if (poolCleanIp != null) {
      fetchPh();
    } else {
      setState(() {
        isConnected = false;
      });
    }
  }

  Future<void> fetchPh() async {
    if (poolCleanIp == null) return;

    try {
      final response =
          await http.get(Uri.parse('http://$poolCleanIp/ph')); // Usa la IP
      if (response.statusCode == 200 && mounted) {
        setState(() {
          ph = double.parse(response.body);
          isConnected = true;
        });
      } else {
        throw Exception('Error al obtener el pH');
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
      if (mounted && !isConnected) {
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
              offset: const Offset(4, 4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Text(
                'pH',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.water_drop_rounded,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isLoading ? 'Cargando...' : ph.toStringAsFixed(1), // Mostrar "Cargando..." o el valor de pH
                        style: GoogleFonts.poppins(
                          color: Colors.grey[700],
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
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
