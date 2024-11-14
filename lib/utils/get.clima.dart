import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

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

  // Obtiene la ubicación actual del usuario
  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
}

// Función para obtener el clima utilizando OpenWeatherMap API
Future<Map<String, dynamic>> _getWeather(double lat, double lon) async {
  String apiKey = "4618861c9f397932000720f218c04e8a";
  String url =
      "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=$apiKey";

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      // Imprimir la respuesta para depuración
      print("Respuesta de la API: $responseData");

      // Verificar si la clave "main" y "temp" existen en la respuesta
      if (responseData["main"] != null &&
          responseData["main"]["temp"] != null &&
          responseData["name"] != null) {
        // Acceder a la temperatura y el nombre del lugar
        double temperature = responseData["main"]["temp"];
        String name = responseData["name"];

        // Retornar un Map con la temperatura y el nombre del lugar
        return {
          "temperature": temperature,
          "name": name,
        };
      } else {
        // Lanzar una excepción si la temperatura o el nombre no están disponibles
        throw Exception("No se pudo obtener el clima: Información faltante.");
      }
    } else {
      throw Exception("Error de red: ${response.statusCode}");
    }
  } catch (e) {
    print("Error al obtener el clima: $e");
    throw Exception("No se pudo obtener el clima.");
  }
}

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  String _locationMessage = "Obteniendo ubicación...";
  String _weatherMessage = "Obteniendo clima...";

  void _getLocationAndWeather() async {
    try {
      Position position = await _getUserLocation();
      print("Ubicación obtenida: ${position.latitude}, ${position.longitude}");

      setState(() {
        _locationMessage =
            "Lat: ${position.latitude}, Long: ${position.longitude}";
      });

      // Llamada a _getWeather que devuelve un Map con la temperatura y el nombre
      var weatherData =
          await _getWeather(position.latitude, position.longitude);

      // Extraer la temperatura y el nombre del lugar del Map
      double temperature = weatherData["temperature"];
      String locationName = weatherData["name"];

      print("Temperatura obtenida: $temperature");
      print("Nombre del lugar: $locationName");

      setState(() {
        _weatherMessage = "$locationName: ${temperature.toStringAsFixed(1)}°C";
      });
    } catch (e) {
      setState(() {
        _locationMessage = "Error obteniendo ubicación";
        _weatherMessage = "Error obteniendo clima: $e";
      });
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _getLocationAndWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Text(_weatherMessage);
  }
}
