import 'package:flutter/material.dart';
import 'package:poolclean/pages/ajustes_iniciales.dart';
import 'package:poolclean/utils/global.colors.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';
// Asegúrate de agregar wifi_iot a tu pubspec.yaml e importarlo aquí
import 'package:wifi_iot/wifi_iot.dart';

class WiFiConnectionPage extends StatefulWidget {
  @override
  _WiFiConnectionPageState createState() => _WiFiConnectionPageState();
}

class _WiFiConnectionPageState extends State<WiFiConnectionPage> {
  List<WiFiAccessPoint> _wifiNetworks = [];

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      _scanForWiFi();
    } else {
      print("Permiso de ubicación denegado. No se puede escanear redes Wi-Fi.");
    }
  }

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

  Future<void> _connectToWiFi(String ssid) async {
    // Intenta conectarte a la red Wi-Fi (modifica este ejemplo según el paquete que utilices)
    bool isConnected = await WiFiForIoTPlugin.connect(ssid, joinOnce: true);

    if (isConnected) {
      _showConnectionSuccessDialog(ssid);
    } else {
      print("No se pudo conectar a la red Wi-Fi $ssid");
    }
  }

  void _showConnectionSuccessDialog(String ssid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Conectado",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          content: Text(
            "Te has conectado a la red Wi-Fi: $ssid",
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              child: Text(
                "Aceptar",
                style: GoogleFonts.poppins(
                  color: GlobalColors.textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AjustesInicialesPage()),
                );
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
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        title: Text(
          'Conéctate a una red Wi-Fi',
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
      ),
      body: _wifiNetworks.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _wifiNetworks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_wifiNetworks[index].ssid ?? "Red desconocida"),
                  subtitle:
                      Text(_wifiNetworks[index].bssid ?? "BSSID desconocido"),
                  onTap: () {
                    _connectToWiFi(
                        _wifiNetworks[index].ssid ?? "Red desconocida");
                  },
                );
              },
            ),
    );
  }
}
