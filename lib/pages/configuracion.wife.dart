import 'package:flutter/material.dart';
import 'package:poolclean/pages/connection.wife.dart';
import 'package:poolclean/utils/global.colors.dart';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';

class ConfiguracionWife extends StatefulWidget {
  @override
  _ConfiguracionWifeState createState() => _ConfiguracionWifeState();
}

class _ConfiguracionWifeState extends State<ConfiguracionWife>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: GlobalColors.textColor,
      end: Colors.blueAccent.shade200,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_colorAnimation.value!, GlobalColors.mainColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              );
            },
          ),
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              color: Colors.lightBlue.withOpacity(0.3),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Primero, conectémonos a la red Wi-Fi para vincular tu dispositivo y configurar los datos necesarios para gestionar tu piscina.',
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.poppins(
                          fontSize: 20.0, height: 1.5, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WiFiConnectionPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GlobalColors.colorborde,
                      padding: EdgeInsets.all(20),
                      minimumSize: Size(80, 80),
                      shape: CircleBorder(),
                    ),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      size: 40.0,
                      color: GlobalColors.textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 100);

    final firstControlPoint = Offset(size.width / 4, size.height);
    final firstEndPoint = Offset(size.width / 2, size.height - 100);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    final secondControlPoint = Offset(size.width * 3 / 4, size.height - 200);
    final secondEndPoint = Offset(size.width, size.height - 100);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
