// ignore_for_file: depend_on_referenced_packages
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poolclean/utils/global.colors.dart';
import 'agregardispositivo.dart';

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hola parece ser un gran día',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: GlobalColors.textColor,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    'Comencemos revisando los niveles de pH de tu piscina',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            AspectRatio(
              aspectRatio: 1.8,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 60,
                      startDegreeOffset: -90,
                      sections: getSections(),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'pH',
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'SCALE',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    'Sin dispositivo vinculado',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.red, // Color para resaltar
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TemperatureScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GlobalColors.mainColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Agregar Dispositivo',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [],
            ),
            const SizedBox(height: 20),
            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Informes sobre el estado de tu piscina ',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: GlobalColors.textColor,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> getSections() {
    final colors = [
      const Color(0xffFF0109),
      const Color(0xffFD5C01),
      const Color(0xffFCC403),
      const Color(0xffF8EE00),
      const Color(0xffADD302),
      const Color(0xff6CC718),
      const Color(0xff0EC140),
      const Color(0xff009E2D),
      const Color(0xff04B666),
      const Color(0xff00C0B8),
      const Color(0xff1D92D5),
      const Color(0xff2D56AD),
      const Color(0xff5E52A8),
      const Color(0xff6744A2),
      const Color(0xff4A2D7F),
    ];

    final labels = List.generate(15, (i) => i.toString());

    return List.generate(15, (i) {
      return PieChartSectionData(
        color: colors[i],
        value: 1,
        title: labels[i],
        titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
        radius: 50,
      );
    });
  }
}
