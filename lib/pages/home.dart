// ignore_for_file: depend_on_referenced_packages

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:poolclean/utils/global.colors.dart';
import 'package:http/http.dart' as http;
import 'package:poolclean/widgets/ph_card_widget.dart';
import 'package:poolclean/widgets/temperature_card_widget.dart';

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
                        color: GlobalColors.textColor),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    'Comencemos revisando los niveles de pH de tu piscina',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.grey[700]),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 15,
                            width: 15,
                            color: const Color(0xffFF0159)),
                        Container(
                            height: 15,
                            width: 15,
                            color: const Color(0xffFD5C01)),
                        Container(
                            height: 15,
                            width: 15,
                            color: const Color(0xffFCC403)),
                        Container(
                            height: 15,
                            width: 15,
                            color: const Color(0xffF8EE00)),
                        Container(
                            height: 15,
                            width: 15,
                            color: const Color(0xffADD302)),
                        Container(
                            height: 15,
                            width: 15,
                            color: const Color(0xff6CC718)),
                        Container(
                            height: 15,
                            width: 15,
                            color: const Color(0xff0EC140)),
                      ],
                    ),
                    Text(
                      'ACIDIC',
                      style: GoogleFonts.poppins(
                          color: Colors.grey[700],
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 15,
                            width: 70,
                            color: const Color(0xff009E2D)),
                      ],
                    ),
                    Text(
                      'NEUTRAL',
                      style: GoogleFonts.poppins(
                          color: Colors.grey[700],
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 15,
                            width: 15,
                            color: const Color(0xff04B666)),
                        Container(
                            height: 15,
                            width: 15,
                            color: const Color(0xff00C0B8)),
                        Container(
                            height: 15,
                            width: 15,
                            color: const Color(0xff1D92D5)),
                        Container(
                            height: 15,
                            width: 15,
                            color: const Color(0xff2D56AD)),
                        Container(
                            height: 15,
                            width: 15,
                            color: const Color(0xff5E52A8)),
                        Container(
                            height: 15,
                            width: 15,
                            color: const Color(0xff6744A2)),
                        Container(
                            height: 15,
                            width: 15,
                            color: const Color(0xff4A2D7F)),
                      ],
                    ),
                    Text(
                      'ALKALINE',
                      style: GoogleFonts.poppins(
                          color: Colors.grey[700],
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
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
                    color: GlobalColors.textColor),
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TemperatureCard(),
                          SizedBox(height: 10),
                          PhCard(),
                        ],
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: Padding(
                  //     padding: EdgeInsets.all(5.0),
                  //     child: Column(
                  //       children: [
                  //         PhCard(),
                  //         SizedBox(height: 10),
                  //         PhCard(),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
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
      final isTouched = i == 0;
      final opacity = isTouched ? 1.0 : 0.6;
      return PieChartSectionData(
        color: colors[i],
        value: 1,
        title: labels[i],
        radius: isTouched ? 60 : 50,
        titleStyle: TextStyle(
          fontSize: isTouched ? 25 : 16,
          fontWeight: isTouched ? FontWeight.bold : FontWeight.normal,
          color: Colors.white.withOpacity(opacity),
        ),
      );
    });
  }
}

class BatteryCard extends StatelessWidget {
  const BatteryCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 8.0,
      shadowColor: Colors.grey.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Text(
              'Batería',
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20), // Ajusta el padding
              child: CircularPercentIndicator(
                radius: 40,
                lineWidth: 5,
                percent: 0.7,
                progressColor: Colors.green,
                backgroundColor: Colors.grey.shade100,
                circularStrokeCap: CircularStrokeCap.round,
                center: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.battery_5_bar,
                      weight: 5,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        '70%',
                        style: GoogleFonts.poppins(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
