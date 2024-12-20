import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poolclean/utils/global.colors.dart';
import 'package:poolclean/widgets/button.global.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importar SharedPreferences

class InicioPage extends StatelessWidget {
  const InicioPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Llama a la función para verificar el token al inicio
    _checkAuthToken(context);

    return Scaffold(
      backgroundColor: GlobalColors.mainColor,
      body: Stack(
        children: [
          ClipPath(
            clipper: CurvedHeaderClipper(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 80),
                    Text(
                      'Bienvenido a ',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: GlobalColors.mainColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      'POOL CLEAN',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: GlobalColors.mainColor,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.4,
                left: 20,
                right: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    height: 150,
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: ButtonInicio(),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    child: ButtonCuenta(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _checkAuthToken(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('auth_token'); // Verifica si hay token

    if (authToken != null && authToken.isNotEmpty) {
      // Si el token existe, redirige a la página de inicio
       Navigator.pushReplacementNamed(context, '/conectarwife');
    }
  }
}

class CurvedHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
