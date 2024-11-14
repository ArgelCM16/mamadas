import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poolclean/pages/dispositivo.dart';
import 'package:poolclean/pages/dashboard.dart';
import 'package:poolclean/pages/home.dart';
import 'package:poolclean/pages/perfil.dart';
import 'package:poolclean/pages/notificaciones.dart';
import 'package:poolclean/utils/global.colors.dart';

Future<Position> _getUserLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('El servicio de ubicación está deshabilitado.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Permisos de ubicación denegados.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Los permisos de ubicación están denegados permanentemente.');
  }

  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
}

Future<Map<String, dynamic>> _getWeather(double lat, double lon) async {
  String apiKey = "4618861c9f397932000720f218c04e8a";
  String url =
      "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=$apiKey";

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      if (responseData["main"] != null &&
          responseData["main"]["temp"] != null &&
          responseData["name"] != null) {
        double temperature = responseData["main"]["temp"];
        String name = responseData["name"];
        return {
          "temperature": temperature,
          "name": name,
        };
      } else {
        throw Exception("No se pudo obtener el clima: Información faltante.");
      }
    } else {
      throw Exception("Error de red: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("No se pudo obtener el clima.");
  }
}

IconData _getWeatherIcon(double temperature) {
  if (temperature < 0) {
    return Icons.ac_unit;
  } else if (temperature < 20) {
    return Icons.cloud_outlined;
  } else if (temperature < 30) {
    return Icons.wb_sunny_outlined;
  } else {
    return Icons.wb_sunny_outlined;
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  String _weatherMessage = "Obteniendo clima...";
  IconData _weatherIcon = Icons.cloud_outlined;

  final List<Widget> _pages = [
    const HomePageContent(),
    const DashboardPage(),
    const DispositvoPage(),
    const PerfilPage(),
  ];

  void _getLocationAndWeather() async {
    try {
      Position position = await _getUserLocation();

      var weatherData =
          await _getWeather(position.latitude, position.longitude);

      double temperature = weatherData["temperature"];
      String locationName = weatherData["name"];

      setState(() {
        _weatherMessage = "$locationName: ${temperature.toStringAsFixed(1)}°C";
        _weatherIcon = _getWeatherIcon(temperature);
      });
    } catch (e) {
      setState(() {
        _weatherMessage = "Error obteniendo clima";
        _weatherIcon = Icons.error;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getLocationAndWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Icon(
              _weatherIcon, 
              color: GlobalColors.mainColor,
            ),
            SizedBox(width: 8),
            Text(
              _weatherMessage, 
              style: GoogleFonts.poppins(color: Colors.grey[700], fontSize: 12),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: GlobalColors.mainColor,
            ),
            tooltip: 'Notificaciones',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificacionesPage()),
              );
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        color: GlobalColors.mainColor,
        backgroundColor: Colors.white,
        items: const [
          Icon(Icons.home, color: Colors.white),
          Icon(
            Icons.dashboard,
            color: Colors.white,
          ),
          Icon(Icons.device_hub, color: Colors.white),
          Icon(Icons.person, color: Colors.white),
        ],
        index: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
