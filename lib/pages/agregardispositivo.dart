import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TemperatureScreen extends StatefulWidget {
  @override
  _TemperatureScreenState createState() => _TemperatureScreenState();
}

class _TemperatureScreenState extends State<TemperatureScreen> {
  String temperature = "Cargando...";

  Future<void> fetchTemperature() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.4.1/temp')); // IP del ESP32
      if (response.statusCode == 200) {
        setState(() {
          temperature = response.body + " °C";
        });
      } else {
        setState(() {
          temperature = "Error al obtener datos";
        });
      }
    } catch (e) {
      setState(() {
        temperature = "Error: $e";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTemperature(); // Llama a la función al iniciar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Temperatura LM35')),
      body: Center(
        child: Text(
          temperature,
          style: TextStyle(fontSize: 24),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchTemperature,
        child: Icon(Icons.refresh),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: TemperatureScreen()));
}
