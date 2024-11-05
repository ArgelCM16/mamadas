import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poolclean/utils/global.colors.dart';

class InfoNotificaciones {
  final String name;
  final String description;

  InfoNotificaciones({
    required this.name,
    required this.description,
  });
}

class NotificacionesPage extends StatefulWidget {
  const NotificacionesPage({super.key});

  @override
  State<NotificacionesPage> createState() => _NotificacionesPageState();
}

class _NotificacionesPageState extends State<NotificacionesPage> {
  final List<InfoNotificaciones> _info = [
    InfoNotificaciones(
        name: "Parecer ser un día soleado",
        description:
            "Es momento de comenzar darle mantenimeinto a tu piscina)"),
    InfoNotificaciones(
        name: "Tu piscina elevo el porcentaje de pH",
        description: "Necesitas revisar los niveles de pH"),
    InfoNotificaciones(
        name: "Parecer ser un día soleado",
        description:
            "Es momento de comenzar darle mantenimeinto a tu piscina)"),
    InfoNotificaciones(
        name: "Tu piscina elevo el porcentaje de pH",
        description: "Necesitas revisar los niveles de pH"),
  ];

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
          'Notificaciones',
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 20),
        itemCount: _info.length,
        itemBuilder: (context, index) {
          return ListTile(
            selectedColor: Colors.white,
            onLongPress: () {
              _borraNotificacion(context, _info[index]);
            },
            title: Text(_info[index].name),
            subtitle: Text(
              _info[index].description,
              style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.w400),
            ),
            leading: CircleAvatar(
              backgroundColor: GlobalColors.mainColor,
              child: Text(
                _info[index].name.substring(0, 1),
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }

  void _borraNotificacion(BuildContext context, InfoNotificaciones info) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Notificación'),
          content: const Text('¿Deseas eliminar esta notificación?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _info.remove(info);
                });
                Navigator.pop(context);
              },
              child: Text(
                'Eliminar',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
