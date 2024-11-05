import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poolclean/utils/global.colors.dart';

class DispositvoPage extends StatelessWidget {
  const DispositvoPage({super.key});

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
                  color: GlobalColors.textColor),
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
                      'Bluetooth: Conectado',
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    Row(
                      children: [
                        Text(
                          'Batería:',
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                        Transform.rotate(
                          angle: 1.57,
                          child: Icon(
                            Icons.battery_4_bar_rounded,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Versión: (0.1)',
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                  ],
                ),
                SizedBox(
                  width: 50,
                ),
                Image.asset(
                  'assets/dispo.png',
                  height: 100,
                ),
              ],
            ),
          ),
          SizedBox(height: 20),

          // Text(
          //   'Ajustes adicionales',
          //   style: GoogleFonts.poppins(
          //       fontSize: 18,
          //       fontWeight: FontWeight.w500,
          //       color: GlobalColors.textColor),
          // ),
          ListTile(
            shape: Border(
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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Activado',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
                Icon(Icons.arrow_forward_ios_rounded),
              ],
            ),
            onTap: () {},
          ),
          ListTile(
            shape: Border(
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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Activado',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
                Icon(Icons.arrow_forward_ios_rounded),
              ],
            ),
            onTap: () {},
          ),
          ListTile(
            shape: Border(
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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_forward_ios_rounded),
              ],
            ),
            onTap: () {},
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: GlobalColors.mainColor,
                padding:
                    EdgeInsets.symmetric(vertical: 15.0, horizontal: 100.0),
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
