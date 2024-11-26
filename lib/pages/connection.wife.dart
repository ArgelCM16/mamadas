import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:poolclean/pages/ajustes_iniciales.dart';
import 'package:poolclean/utils/global.colors.dart';
import 'package:poolclean/widgets/menu.navegacion.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class WiFiConnectionPage extends StatefulWidget {
  @override
  _WiFiConnectionPageState createState() => _WiFiConnectionPageState();
}

class _WiFiConnectionPageState extends State<WiFiConnectionPage> {
  List<WiFiAccessPoint> _wifiNetworks = [];
  bool _isConnectedToPoolclean = false;
  String? _selectedSSID;
  String? poolCleanIp; // Variable para almacenar la IP
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // Indicador de carga para escanear redes
  bool _isConnecting = false; // Indicador de carga para la conexión Wi-Fi
  bool _scanning =
      false; // Para evitar que se vuelva a escanear cuando estamos en la pantalla de contraseña

  @override
  void initState() {
    super.initState();
    _checkInitialScreen();
    _loadSavedWiFiConfig(); // Cargar configuración guardada
    _checkCurrentWiFi();
    _requestPermissions();
  }

  Future<void> _checkInitialScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    poolCleanIp = prefs.getString('Poolcleanip'); // Obtiene la IP

    if (poolCleanIp != null) {
      // Si ya tiene un user_id guardado, ir directamente a HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  Future<void> _checkCurrentWiFi() async {
    String currentSSID = await WiFiForIoTPlugin.getSSID() ?? "";
    setState(() {
      _isConnectedToPoolclean = currentSSID == "Totalplay-2.4G-d3d8";
    });

    if (_isConnectedToPoolclean) {
      _scanForWiFi(); // Escanea las redes Wi-Fi si está conectado a Poolclean
    }
  }

  // Solicita los permisos necesarios para escanear redes Wi-Fi
  Future<void> _requestPermissions() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      _scanForWiFi();
    } else {
      print("Permiso de ubicación denegado. No se puede escanear redes Wi-Fi.");
    }
  }

  // Inicia el escaneo de redes Wi-Fi
  Future<void> _scanForWiFi() async {
    if (_scanning) return; // Si ya estamos escaneando, no volvemos a hacerlo
    setState(() {
      _scanning = true; // Activar el estado de escaneo
      _wifiNetworks = []; // Limpia la lista antes de iniciar el escaneo
      _isLoading = true; // Activar el indicador de carga
    });

    bool scanStarted = await WiFiScan.instance.startScan();
    if (!scanStarted) {
      print("No se pudo iniciar el escaneo de redes Wi-Fi.");
      setState(() {
        _isLoading = false; // Desactivar el indicador de carga
        _scanning = false; // Desactivar el estado de escaneo
      });
      return;
    }

    WiFiScan.instance.onScannedResultsAvailable
        .listen((List<WiFiAccessPoint> networks) {
      setState(() {
        _wifiNetworks = networks;
        _isLoading =
            false; // Desactivar el indicador de carga cuando los resultados estén disponibles
        _scanning = false; // Desactivar el estado de escaneo
      });
    });
  }

  // Conectar al Wi-Fi y enviar la petición al ESP32
  Future<void> _connectToWiFi(String ssid, String password) async {
    setState(() {
      _isConnecting =
          true; // Activar el indicador de carga mientras nos conectamos
    });

    final response = await http.post(
      Uri.parse(
          'http://192.168.4.1/connect'), // Asegúrate de que la IP sea correcta
      body: {'ssid': ssid, 'password': password},
    );

    setState(() {
      _isConnecting =
          false; // Desactivar el indicador de carga después de intentar la conexión
    });

    if (response.statusCode == 200) {
      String poolCleanIp = _parseIpFromResponse(response.body);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('Poolcleanip', poolCleanIp);
      await prefs.setString('ssid', ssid); // Guardar SSID
      await prefs.setString('password', password); // Guardar contraseña
      await prefs.setString('Conectado', "si"); // Guardar conexión

      _showConnectionSuccessDialog(poolCleanIp);
    } else {
      _showConnectionErrorDialog();
    }
  }

  // Analiza el cuerpo de la respuesta para obtener la IP del Poolclean
  String _parseIpFromResponse(String body) {
    final regex = RegExp(r"IP del ESP32: (\d+\.\d+\.\d+\.\d+)");
    final match = regex.firstMatch(body);

    if (match != null) {
      return match.group(1)!;
    } else {
      return "";
    }
  }

  // Cargar configuración guardada
  Future<void> _loadSavedWiFiConfig() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedSSID = prefs.getString('ssid');
    String? savedPassword = prefs.getString('password');

    if (savedSSID != null && savedPassword != null) {
      _connectToWiFi(savedSSID, savedPassword);
    }
  }

  // Muestra un diálogo cuando la conexión es exitosa
  void _showConnectionSuccessDialog(String poolCleanIp) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Conexión exitosa",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          content: Text(
              "Te has conectado correctamente a Poolclean.\nIP: $poolCleanIp",
              style: GoogleFonts.poppins()),
          actions: [
            TextButton(
              child: Text("Aceptar",
                  style: GoogleFonts.poppins(
                      color: GlobalColors.textColor,
                      fontWeight: FontWeight.w500)),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
            ),
          ],
        );
      },
    );
  }

  // Muestra un diálogo en caso de error de conexión
  void _showConnectionErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error de conexión",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          content: Text(
              "La contraseña es incorrecta o hubo un problema con la conexión. Intenta nuevamente.",
              style: GoogleFonts.poppins()),
          actions: [
            TextButton(
              child: Text("Aceptar",
                  style: GoogleFonts.poppins(
                      color: GlobalColors.textColor,
                      fontWeight: FontWeight.w500)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: GlobalColors.mainColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text('Conéctate a una red Wi-Fi',
            style: GoogleFonts.poppins(color: Colors.white)),
      ),
      body: !_isConnectedToPoolclean
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      "Necesitas estar conectado a la red Wi-Fi Poolclean para continuar",
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GlobalColors.mainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            12), // Opcional, para bordes redondeados
                      ),
                    ),
                    onPressed:
                        _checkCurrentWiFi, // Ahora llama a _checkCurrentWiFi, que incluye el escaneo
                    child: Text("Verificar conexión Wi-Fi",
                        style: GoogleFonts.poppins(
                            fontSize: 16, color: Colors.white)),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (_isLoading)
                    const CircularProgressIndicator()
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: _wifiNetworks.length,
                        itemBuilder: (context, index) {
                          final wifiNetwork = _wifiNetworks[index];
                          return ListTile(
                            title: Text(wifiNetwork.ssid),
                            onTap: () async {
                              _selectedSSID = wifiNetwork.ssid;
                              _showPasswordDialog();
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  // Mostrar diálogo de contraseña
  void _showPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Introduce la contraseña",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          content: TextField(
            controller: _passwordController,
            decoration: InputDecoration(hintText: "Contraseña de la red"),
            obscureText: true,
          ),
          actions: [
            TextButton(
              child: Text("Cancelar",
                  style: GoogleFonts.poppins(
                      color: GlobalColors.textColor,
                      fontWeight: FontWeight.w500)),
              onPressed: () {
                Navigator.pop(context); // Solo cierra el diálogo
              },
            ),
            TextButton(
              child: Text("Conectar",
                  style: GoogleFonts.poppins(
                      color: GlobalColors.textColor,
                      fontWeight: FontWeight.w500)),
              onPressed: () {
                if (_passwordController.text.isNotEmpty) {
                  _connectToWiFi(_selectedSSID ?? '', _passwordController.text);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
