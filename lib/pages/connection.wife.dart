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
  poolCleanIp = prefs.getString('Poolcleanip'); // Obtiene la IP almacenada

  // Si la IP no está en cache, consulta la API
  if (poolCleanIp == null) {
    // Recupera el token de autenticación y el ID de usuario
    String? authToken = prefs.getString('auth_token');
    int? userId = prefs.getInt('user_id');

    // Verifica que el token y el userId estén disponibles
    if (authToken == null || userId == null) {
      // Si no tienes los datos necesarios, no hace nada
      return;
    }

    // Consulta a la API para obtener la IP del usuario
    final response = await http.get(
      Uri.parse('https://poolcleanapi-production.up.railway.app/api/verUsuarioIp/$userId'),
      headers: {
        'Authorization': 'Bearer $authToken',
      },
    );

    // Si la respuesta es exitosa y existe una IP, la guardamos en el cache
    if (response.statusCode == 200) {
  final Map<String, dynamic> data = jsonDecode(response.body);
  String? usuarioIp = data['usuario_ip'];

  if (usuarioIp != null) {
    // Elimina las comillas adicionales si están presentes
    usuarioIp = usuarioIp.replaceAll('"', '');

    // Guarda la IP en el cache
    await prefs.setString('Poolcleanip', usuarioIp);
    poolCleanIp = usuarioIp; // Asigna la IP para usarla más tarde

    // Luego navega a HomePage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }
} else {
      // Si la consulta falla, puedes manejar el error como prefieras
      print('Error al obtener la IP del usuario desde la API');
    }
  } else {
    // Si ya hay una IP en cache, solo navega a HomePage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }
}


Future<void> _checkCurrentWiFi() async {
  String currentSSID = await WiFiForIoTPlugin.getSSID() ?? "";
  setState(() {
    _isConnectedToPoolclean = currentSSID == "Poolclean";
  });
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
    bool scanStarted = await WiFiScan.instance.startScan();
    if (!scanStarted) {
      print("No se pudo iniciar el escaneo de redes Wi-Fi.");
      return;
    }

    WiFiScan.instance.onScannedResultsAvailable
        .listen((List<WiFiAccessPoint> networks) {
      setState(() {
        _wifiNetworks = networks;
      });
    });
  }

  // Conectar al Wi-Fi y enviar la petición al ESP32
  Future<void> _connectToWiFi(String ssid, String password) async {
    final response = await http.post(
      Uri.parse(
          'http://192.168.4.1/connect'), // Asegúrate de que la IP sea correcta
      body: {'ssid': ssid, 'password': password},
    );

    if (response.statusCode == 200) {
      String poolCleanIp = _parseIpFromResponse(response.body);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('Poolcleanip', poolCleanIp);
      await prefs.setString('ssid', ssid); // Guardar SSID
      await prefs.setString('password', password); // Guardar contraseña
      await prefs.setString('Conectado', "si"); // Guardar conexion


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
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _checkCurrentWiFi,
                    child: Text("Verificar conexión",
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: GlobalColors.mainColor),
                  ),
                ],
              ),
            )
          : _wifiNetworks.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: _wifiNetworks.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title:
                          Text(_wifiNetworks[index].ssid ?? "Red desconocida"),
                      subtitle: Text(
                          _wifiNetworks[index].bssid ?? "BSSID desconocido"),
                      onTap: () {
                        setState(() {
                          _selectedSSID = _wifiNetworks[index].ssid;
                        });
                        _showPasswordDialog();
                      },
                    );
                  },
                ),
    );
  }

  // Muestra un diálogo para introducir la contraseña del Wi-Fi
  void _showPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Introduce la contraseña",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          content: TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: "Contraseña"),
          ),
          actions: [
            TextButton(
              child: Text("Cancelar",
                  style: GoogleFonts.poppins(color: GlobalColors.textColor)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("Conectar",
                  style: GoogleFonts.poppins(color: GlobalColors.textColor)),
              onPressed: () {
                _connectToWiFi(_selectedSSID ?? "", _passwordController.text);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
