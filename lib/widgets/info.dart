import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SensorScreen extends StatefulWidget {
  @override
  _SensorScreenState createState() => _SensorScreenState();
}

class _SensorScreenState extends State<SensorScreen> {



  String temperature = "Cargando...";
  String ph = "Cargando...";
  String connectionStatus = "Cargando...";
  String batteryPercentage = "Cargando...";


  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.4.1/data')); // IP del ESP32

      if (response.statusCode == 200) {
        // Suponiendo que el ESP32 devuelve un JSON con los datos
        final data = response.body; // Cambia esto para parsear el JSON si es necesario
        setState(() {
          // Aquí deberías dividir la respuesta en sus respectivos valores
          // Asegúrate de que el formato sea correcto, aquí hay un ejemplo básico
          final parsedData = data.split(','); // Cambia esto según el formato real
          temperature = "${parsedData[0]} °C"; // Temperatura
          ph = "${parsedData[1]}"; // pH
          connectionStatus = parsedData[2] == '1' ? "Conectado" : "Desconectado"; // Estado de conexión
          batteryPercentage = "${parsedData[3]} %"; // Porcentaje de batería
        });
      } else {
        setState(() {
          temperature = "Error al obtener datos";
          ph = "Error al obtener datos";
          connectionStatus = "Error al obtener datos";
          batteryPercentage = "Error al obtener datos";
        });
      }
    } catch (e) {
      setState(() {
        temperature = "Error: $e";
        ph = "Error: $e";
        connectionStatus = "Error: $e";
        batteryPercentage = "Error: $e";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // Llama a la función al iniciar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Datos del Sensor')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Temperatura: $temperature', style: TextStyle(fontSize: 24)),
            SizedBox(height: 16),
            Text('pH: $ph', style: TextStyle(fontSize: 24)),
            SizedBox(height: 16),
            Text('Estado de conexión: $connectionStatus', style: TextStyle(fontSize: 24)),
            SizedBox(height: 16),
            Text('Porcentaje de batería: $batteryPercentage', style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchData,
        child: Icon(Icons.refresh),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: SensorScreen()));
}
