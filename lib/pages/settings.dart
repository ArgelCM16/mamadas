// import 'package:flutter/material.dart';
// import 'package:wifi_scan/wifi_scan.dart';  // Importa el paquete wifi_scan correcto

// class WiFiConnectionPage extends StatefulWidget {
//   @override
//   _WiFiConnectionPageState createState() => _WiFiConnectionPageState();
// }

// class _WiFiConnectionPageState extends State<WiFiConnectionPage> {
//   List<ScanResult> _wifiNetworks = [];  // Lista de redes Wi-Fi disponibles

//   @override
//   void initState() {
//     super.initState();
//     _scanForWiFi();  // Llama al escaneo de redes Wi-Fi al iniciar la vista
//   }

//   Future<void> _scanForWiFi() async {
//     try {
//       // Escanea las redes Wi-Fi cercanas usando la nueva API
//       List<ScanResult> networks = await WifiScan.scanNetworks();  // Usar WifiScan para escanear redes

//       // Verifica que se obtuvieron redes
//       print("Redes Wi-Fi disponibles: $networks");

//       if (networks.isNotEmpty) {
//         setState(() {
//           _wifiNetworks = networks;  // Almacena las redes Wi-Fi encontradas
//         });
//       } else {
//         setState(() {
//           _wifiNetworks = [];  // Si no hay redes, mantiene la lista vacía
//         });
//       }
//     } catch (e) {
//       print("Error al escanear redes Wi-Fi: $e");
//       setState(() {
//         _wifiNetworks = [];  // En caso de error, la lista se limpia
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Conéctate a una red Wi-Fi"),
//       ),
//       body: _wifiNetworks.isEmpty
//           ? Center(child: CircularProgressIndicator())  // Muestra un indicador de carga mientras se escanean redes
//           : ListView.builder(
//               itemCount: _wifiNetworks.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(_wifiNetworks[index].ssid ?? "Red desconocida"),
//                   subtitle: Text(_wifiNetworks[index].bssid ?? "BSSID desconocido"),
//                   onTap: () {
//                     // Lógica para conectar a la red seleccionada
//                     print("Conectar a: ${_wifiNetworks[index].ssid}");
//                   },
//                 );
//               },
//             ),
//     );
//   }
// }
