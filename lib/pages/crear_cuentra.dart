import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poolclean/pages/login.dart';
import 'package:poolclean/utils/global.colors.dart';
import 'package:poolclean/widgets/button.global.dart';
import 'package:poolclean/widgets/text.form.global.dart';

class CrearCuentaPage extends StatelessWidget {
  CrearCuentaPage({super.key});
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController contraController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ClipPath(
            clipper: CurvedHeaderClipper(),
            child: Container(
              height: 250,
              color: GlobalColors.mainColor,
              child: Center(
                child: Text(
                  'POOL CLEAN',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 150),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 80),
                    Center(
                      child: Text(
                        'Bienvenido registrate aquí',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          TextGeneralForm(
                            controller: nombreController,
                            text: 'Nombre',
                            obscure: false,
                            textInputType: TextInputType.name,
                          ),
                          SizedBox(height: 15),
                          TextGeneralForm(
                            controller: apellidosController,
                            text: 'Apellido',
                            obscure: false,
                            textInputType: TextInputType.name,
                          ),
                          SizedBox(height: 15),
                          TextGeneralForm(
                            controller: correoController,
                            text: 'Correo',
                            obscure: false,
                            textInputType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: 15),
                          TextGeneralForm(
                            controller: contraController,
                            text: 'Contraseña',
                            obscure: true,
                            textInputType: TextInputType.text,
                          ),
                          SizedBox(height: 15),
                          ButtonGlobalCuenta(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 50,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¿Ya tienes cuenta?',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
              child: Text(
                'Inicia sesión',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: GlobalColors.mainColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
