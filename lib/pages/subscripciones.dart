import 'package:flutter/material.dart';
import 'package:poolclean/utils/global.colors.dart';
import 'package:google_fonts/google_fonts.dart';

class SubscripcionesPage extends StatelessWidget {
  const SubscripcionesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalColors.mainColor,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        title: Text(
          'Subscripciones',
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1.5,
          ),
          itemCount: 3,
          itemBuilder: (context, index) {
            return Card(
              elevation: 8.0,
              shadowColor: Colors.grey.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: index == 0
                        ? const Color(0xff8fbfec)
                        : index == 1
                            ? const Color(0xff64a6e3)
                            : const Color(0xff3e8fd8)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      index == 0
                          ? 'Plan Free'
                          : index == 1
                              ? 'Plan Premium'
                              : 'Plan Pro',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      index == 0
                          ? 'El plan básico para mantener tu piscina en óptimas condiciones.'
                          : index == 1
                              ? 'El plan completo para un control total de tu piscina.'
                              : ' La solución definitiva para profesionales del cuidado de piscinas.',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        'Seleccionar Plan',
                        style: TextStyle(
                            fontSize: 16, color: GlobalColors.mainColor),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
