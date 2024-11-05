import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poolclean/utils/global.colors.dart';

class TerminosCondiciones extends StatelessWidget {
  const TerminosCondiciones({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> preguntas = [
      {
        'pregunta': '1. Introducción',
        'respuesta':
            'Estos términos y condiciones rigen el uso de nuestra aplicación de monitoreo de piscinas. Al descargar o utilizar la app, el usuario acepta los términos aquí descritos.'
      },
      {
        'pregunta': '2. Uso de la Aplicación',
        'respuesta':
            'La app es una herramienta de monitoreo informativa que permite a los usuarios revisar en tiempo real los datos de temperatura, pH y carga de su piscina. No es un sustituto de mantenimiento profesional o inspecciones de seguridad.'
      },
      {
        'pregunta': '3. Responsabilidad del Usuario',
        'respuesta':
            'Es responsabilidad del usuario asegurarse de que el monitor esté correctamente instalado y expuesto a condiciones de carga solar para garantizar su buen funcionamiento. La app proporciona datos en función de la información enviada por el monitor, y el usuario es responsable de interpretar estos datos correctamente para el mantenimiento de la piscina.'
      },
      {
        'pregunta': '4. Limitaciones de la Aplicación',
        'respuesta':
            'La precisión de los datos puede depender de factores externos, como la ubicación del monitor, la intensidad de luz solar para carga y la estabilidad de la conexión a internet. No nos hacemos responsables de la precisión absoluta de los datos proporcionados ni de daños que puedan surgir por el mal funcionamiento del monitor o errores en la app.'
      },
      {
        'pregunta': '5. Política de Privacidad',
        'respuesta':
            'Los datos de los usuarios se almacenan de manera segura y se utilizan únicamente para brindar el servicio de monitoreo. No se comparten ni venden a terceros, y los usuarios pueden solicitar la eliminación de sus datos en cualquier momento.'
      },
      {
        'pregunta': '6. Modificaciones de los Términos',
        'respuesta':
            'Nos reservamos el derecho de modificar estos términos y condiciones en cualquier momento. Los usuarios serán notificados de cualquier cambio importante y se les pedirá que revisen y acepten los nuevos términos.'
      },
      {
        'pregunta': '7. Soporte y Contacto',
        'respuesta':
            'Para cualquier duda, problema técnico o consulta sobre el uso de la aplicación, los usuarios pueden contactar al soporte técnico a través del apartado de “Ayuda” en la aplicación o enviando un correo electrónico a [poolclean@email.com].'
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
