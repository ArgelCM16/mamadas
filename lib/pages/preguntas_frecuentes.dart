import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poolclean/utils/global.colors.dart';

class PreguntasFrecuentes extends StatelessWidget {
  const PreguntasFrecuentes({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> preguntas = [
      {
        'pregunta': '1. ¿Qué es esta aplicación y cómo funciona?',
        'respuesta':
            'Esta aplicación permite a los usuarios monitorear el estado de su piscina en tiempo real a través de un monitor especializado. La app muestra datos como la temperatura del agua, los niveles de pH y el estado de carga del dispositivo, que cuenta con paneles solares para recargar automáticamente.'
      },
      {
        'pregunta': '2. ¿Cómo puedo conectar mi monitor de piscina a la app?',
        'respuesta':
            'Al iniciar la App, sigue los pasos en la sección de “Configuración” para emparejar tu monitor con la aplicación. Asegúrate de que el monitor esté encendido y dentro del alcance de la señal para conectarse con éxito.'
      },
      {
        'pregunta': '3. ¿Qué datos monitorea el dispositivo de la piscina?',
        'respuesta':
            'El dispositivo mide la temperatura del agua, los niveles de pH y el estado de carga. Estos datos son enviados a la aplicación para que puedas ver el estado de la piscina en tiempo real.'
      },
      {
        'pregunta':
            '4. Qué debo hacer si los datos de la app no se actualizan?',
        'respuesta':
            'Revisa que el monitor esté encendido y dentro del alcance de conexión. También asegúrate de que esté expuesto a la luz solar si su batería está baja. Si persisten los problemas, intenta reiniciar la app y verificar la conexión.'
      },
      {
        'pregunta': '5. ¿Cómo interpreto los niveles de pH y temperatura?',
        'respuesta':
            'La aplicación muestra recomendaciones básicas sobre los niveles de pH ideales y las temperaturas recomendadas para una piscina saludable. Revisa estos indicadores para asegurarte de que tu piscina esté en óptimas condiciones.'
      },
    ];

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
          'Preguntas frecuentes',
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: preguntas.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              preguntas[index]['pregunta']!,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600, fontSize: 16),
            ),
            subtitle: Text(
              preguntas[index]['respuesta']!,
              style: GoogleFonts.poppins(fontSize: 12),
            ),
          );
        },
        separatorBuilder: (context, index) => const Divider(
          color: Colors.grey,
          thickness: 1,
        ),
      ),
    );
  }
}
