import 'package:flutter/material.dart';
import 'package:poolclean/pages/ajustes_iniciales.dart';
import 'package:poolclean/utils/global.colors.dart';
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
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkCurrentWiFi();
    _requestPermissions();
  }

  // Verifica si ya estás conectado a la red Poolclean
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

    // Escucha los resultados del escaneo y actualiza la lista de redes Wi-Fi disponibles
    WiFiScan.instance.onScannedResultsAvailable.listen((List<WiFiAccessPoint> networks) {
      setState(() {
        _wifiNetworks = networks;
      });
    });
  }

  // Conectar al Wi-Fi y enviar la petición al ESP32
  Future<void> _connectToWiFi(String ssid, String password) async {
    final response = await http.post(
      Uri.parse('http://192.168.4.1/connect'),  // Asegúrate de que la IP sea correcta
      body: {'ssid': ssid, 'password': password},
    );

    if (response.statusCode == 200) {
      // Si la conexión es exitosa, extraemos la IP del cuerpo de la respuesta
      String poolCleanIp = _parseIpFromResponse(response.body);

      // Guardamos la IP en SharedPreferences para su uso posterior
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('Poolcleanip', poolCleanIp);
      await prefs.setString('ssid', ssid);  // Guardamos el SSID
      await prefs.setString('password', password);  // Guardamos la contraseña

      // Muestra el diálogo de éxito
      _showConnectionSuccessDialog(poolCleanIp);
    } else {
      // Si ocurre un error, mostramos un mensaje de error
      _showConnectionErrorDialog();
    }
  }

  // Analiza el cuerpo de la respuesta para obtener la IP del Poolclean
String _parseIpFromResponse(String body) {

  // Usamos una expresión regular para extraer la IP
  final regex = RegExp(r"IP del ESP32: (\d+\.\d+\.\d+\.\d+)");
  final match = regex.firstMatch(body);

  if (match != null) {
    // Extraemos la IP del primer grupo capturado
    return match.group(1)!;
  } else {
    return "";
  }
}
  // Muestra un diálogo cuando la conexión es exitosa
  void _showConnectionSuccessDialog(String poolCleanIp) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Conexión exitosa", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          content: Text("Te has conectado correctamente a Poolclean.\nIP: $poolCleanIp", style: GoogleFonts.poppins()),
          actions: [
            TextButton(
              child: Text("Aceptar", style: GoogleFonts.poppins(color: GlobalColors.textColor, fontWeight: FontWeight.w500)),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AjustesInicialesPage()));
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
          title: Text("Error de conexión", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          content: Text("La contraseña es incorrecta o hubo un problema con la conexión. Intenta nuevamente.", style: GoogleFonts.poppins()),
          actions: [
            TextButton(
              child: Text("Aceptar", style: GoogleFonts.poppins(color: GlobalColors.textColor, fontWeight: FontWeight.w500)),
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
        title: Text('Conéctate a una red Wi-Fi', style: GoogleFonts.poppins(color: Colors.white)),
      ),
      body: !_isConnectedToPoolclean
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Necesitas estar conectado a la red Wi-Fi Poolclean para continuar", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _checkCurrentWiFi();
                    },
                    child: Text("Verificar conexión", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: GlobalColors.mainColor),
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
                      title: Text(_wifiNetworks[index].ssid ?? "Red desconocida"),
                      subtitle: Text(_wifiNetworks[index].bssid ?? "BSSID desconocido"),
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
          title: Text("Introduce la contraseña", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          content: TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: "Contraseña"),
          ),
          actions: [
            TextButton(
              child: Text("Cancelar", style: GoogleFonts.poppins(color: GlobalColors.textColor)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("Conectar", style: GoogleFonts.poppins(color: GlobalColors.textColor)),
              onPressed: () {
                _connectToWiFi(_selectedSSID ?? "", _passwordController.text);
              },
            ),
          ],
        );
      },
    );
  }
}
