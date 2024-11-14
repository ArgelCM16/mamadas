import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poolclean/pages/connection.wife.dart';
import 'package:poolclean/utils/global.colors.dart';

class DispositvoPage extends StatefulWidget {
  const DispositvoPage({super.key});

  @override
  _DispositvoPageState createState() => _DispositvoPageState();
}

class _DispositvoPageState extends State<DispositvoPage> {
  bool isNotificationsEnabled = false;
  bool isReminderEnabled = false;

  void _showUnlinkDeviceAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Desvincular Dispositivo',
            style: GoogleFonts.poppins(
              color: GlobalColors.textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            '¿Está seguro de que desea desvincular este dispositivo? Esta acción no puede deshacerse.',
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Aceptar',
                  style: GoogleFonts.poppins(
                    color: GlobalColors.textColor,
                    fontWeight: FontWeight.w500,
                  )),
            ),
          ],
        );
      },
    );
  }

  void _showAlert(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  if (title == 'Activar Notificaciones') {
                    isNotificationsEnabled = !isNotificationsEnabled;
                  } else if (title == 'Activar Recordatorio') {
                    isReminderEnabled = !isReminderEnabled;
                  }
                });
              },
              child: Text(
                'Aceptar',
                style: GoogleFonts.poppins(
                  color: GlobalColors.textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Conectado',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: GlobalColors.textColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wife: Conectado',
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    Text(
                      'Versión: (0.1)',
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            shape: const Border(
              bottom: BorderSide(color: Colors.grey, width: 0.2),
              top: BorderSide(color: Colors.grey, width: 0.2),
            ),
            leading: Icon(
              Icons.notifications_sharp,
              color: GlobalColors.mainColor,
            ),
            title: Text(
              'Aviso de notificaciones',
              style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.w500),
            ),
            trailing: Switch(
              value: isNotificationsEnabled,
              onChanged: (value) {
                if (!isNotificationsEnabled) {
                  _showAlert(
                    context,
                    'Activar Notificaciones',
                    'Activar esta opción permitirá a la app enviarle notificaciones importantes sobre el dispositivo.',
                  );
                } else {
                  setState(() {
                    isNotificationsEnabled = !isNotificationsEnabled;
                  });
                }
              },
            ),
          ),
          ListTile(
            shape: const Border(
              bottom: BorderSide(color: Colors.grey, width: 0.2),
              top: BorderSide(color: Colors.grey, width: 0.2),
            ),
            leading: Icon(
              Icons.notifications_on,
              color: GlobalColors.mainColor,
            ),
            title: Text(
              'Recordatorio de la aplicación',
              style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.w500),
            ),
            trailing: Switch(
              value: isReminderEnabled,
              onChanged: (value) {
                if (!isReminderEnabled) {
                  _showAlert(
                    context,
                    'Activar Recordatorio',
                    'Activar esta opción permitirá a la app enviar recordatorios importantes.',
                  );
                } else {
                  setState(() {
                    isReminderEnabled = !isReminderEnabled;
                  });
                }
              },
            ),
          ),
          ListTile(
            shape: const Border(
              bottom: BorderSide(color: Colors.grey, width: 0.2),
              top: BorderSide(color: Colors.grey, width: 0.2),
            ),
            leading: Icon(
              Icons.delete,
              color: GlobalColors.mainColor,
            ),
            title: Text(
              'Borrar datos',
              style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.w500),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
            onTap: () => _showUnlinkDeviceAlert(context),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                _showUnlinkDeviceAlert(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: GlobalColors.mainColor,
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 100.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text(
                'Desvincular',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
