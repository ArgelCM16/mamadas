import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListaHistorial extends StatelessWidget {
  final String fecha;
  final double ph;
  final double temperatura;
  final double humedad;

  const ListaHistorial({
    super.key,
    required this.fecha,
    required this.ph,
    required this.temperatura,
    required this.humedad,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
            width: 1.0,
          ),
        ),
      ),
      child: ListTile(
        trailing: Text(
          'Fecha: $fecha',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'pH: $ph',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[900],
              ),
            ),
            Text(
              'Temperatura: $temperatura°C',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[900],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
