import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poolclean/pages/ajustes_formula_litraje.dart';
import 'package:poolclean/utils/global.colors.dart';
import 'package:poolclean/widgets/litros_modal.dart';
import 'package:poolclean/widgets/wave_animation.dart';

class AjustesInicialesPage extends StatefulWidget {
  const AjustesInicialesPage({super.key});

  @override
  State<AjustesInicialesPage> createState() => _AjustesInicialesPageState();
}

class _AjustesInicialesPageState extends State<AjustesInicialesPage>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    animation = Tween<double>(begin: 0, end: 100).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showLitrosModal() {
    showDialog(
      context: context,
      builder: (context) {
        return LitrosModal(
          onContinue: (litros) {},
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 200,
              child: WaveAnimation(animation: animation),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¿Sabes cuántos litros de agua tiene tu piscina?',
                    style: GoogleFonts.poppins(
                      color: GlobalColors.mainColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: _showLitrosModal,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GlobalColors.mainColor,
                        padding: const EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Sí, conozco la cantidad de litros de mi piscina.',
                        style: GoogleFonts.poppins(
                            fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CalcularLitrajePage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GlobalColors.colorborde,
                        padding: const EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        '¿No sabes cuántos litros tiene tu piscina? Haz clic aquí.',
                        style: GoogleFonts.poppins(
                            fontSize: 16, color: GlobalColors.textColor),
                      ),
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
