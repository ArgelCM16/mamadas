import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Importa SharedPreferences

class PhCard extends StatefulWidget {
  const PhCard({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PhCardState createState() => _PhCardState();
}

class _PhCardState extends State<PhCard> {
  double? ph;
  bool isConnected = true;
  Timer? connectionTimer;
  String? poolCleanIp; // Variable para almacenar la IP
  String? authToken;  // Token de autenticación
  int? userId;        // ID de usuario

  @override
  void initState() {
    super.initState();
    _getStoredIp(); // Obtener la IP almacenada al iniciar
    // _getAuthData(); // Obtener el auth_token y user_id
    _checkConnectionTimeout();
  }

  // Método para obtener la IP almacenada en SharedPreferences
  Future<void> _getStoredIp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    poolCleanIp = prefs.getString('Poolcleanip'); // Obtiene la IP
    if (poolCleanIp != null) {
      fetchPh(); // Llama a la función para obtener el pH si la IP está disponible
    } else {
      setState(() {
        isConnected = false; // Si no hay IP, marca como no conectado
      });
    }
  }

  // // Método para obtener auth_token y user_id
  // Future<void> _getAuthData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   authToken = prefs.getString('auth_token'); // Obtiene el token
  //   userId = prefs.getInt('user_id'); // Obtiene el id del usuario
  //   if (authToken != null && userId != null) {
  //     _updateIpInApi(); // Si se tiene el token y id, actualiza la IP en la API
  //   }
  // }

  // Método para actualizar la IP en la API
  Future<void> _updateIpInApi() async {
    if (poolCleanIp == null || authToken == null || userId == null) return;

    try {
      final response = await http.put(
        Uri.parse('https://poolcleanapi-production.up.railway.app/api/asignarIp/$userId'),
        headers: {
          'Authorization': 'Bearer $authToken',
        },
        body: {
          'usuario_ip': poolCleanIp,
        },
      );

      if (response.statusCode == 200) {
        print('IP actualizada exitosamente');
      } else {
        throw Exception('Error al actualizar la IP');
      }
    } catch (e) {
      print('Error al conectar con la API: $e');
    }
  }

  Future<void> fetchPh() async {
    if (poolCleanIp == null) return; // Si no hay IP, no hace la solicitud

    try {
      final response = await http.get(Uri.parse('http://$poolCleanIp/ph')); // Usa la IP obtenida
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
      if (ph == null && mounted) {
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
    // Aquí, cada vez que se reconstruya el widget, se actualizará la IP en la API
              _updateIpInApi();


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
            Text('pH',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.water_drop_rounded,
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isConnected
                        ? (ph != null
                            ? ph!.toStringAsFixed(1)
                            : 'Cargando...')
                        : 'No conectado',
                    style: GoogleFonts.poppins(
                        color: Colors.grey[700],
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

    );
  }
}
