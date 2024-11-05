import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:poolclean/utils/global.colors.dart';
import 'package:http/http.dart' as http; // Importa la librería http

class HomePageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
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
            SizedBox(height: 10),
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
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 15, width: 15, color: Color(0xffFF0159)),
                        Container(
                            height: 15, width: 15, color: Color(0xffFD5C01)),
                        Container(
                            height: 15, width: 15, color: Color(0xffFCC403)),
                        Container(
                            height: 15, width: 15, color: Color(0xffF8EE00)),
                        Container(
                            height: 15, width: 15, color: Color(0xffADD302)),
                        Container(
                            height: 15, width: 15, color: Color(0xff6CC718)),
                        Container(
                            height: 15, width: 15, color: Color(0xff0EC140)),
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
                SizedBox(width: 20),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 15, width: 70, color: Color(0xff009E2D)),
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
                SizedBox(width: 20),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 15, width: 15, color: Color(0xff04B666)),
                        Container(
                            height: 15, width: 15, color: Color(0xff00C0B8)),
                        Container(
                            height: 15, width: 15, color: Color(0xff1D92D5)),
                        Container(
                            height: 15, width: 15, color: Color(0xff2D56AD)),
                        Container(
                            height: 15, width: 15, color: Color(0xff5E52A8)),
                        Container(
                            height: 15, width: 15, color: Color(0xff6744A2)),
                        Container(
                            height: 15, width: 15, color: Color(0xff4A2D7F)),
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
            SizedBox(height: 20),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Informes sobre el estado de tu piscina ',
                style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: GlobalColors.textColor),
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: [
                          // Card de temperatura
                          TemperatureCard(),
                          SizedBox(height: 10),
                          PhCard(),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: [
                          // Card de temperatura
                          PhCard(),
                          SizedBox(height: 10),
                          PhCard(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> getSections() {
    final colors = [
      Color(0xffFF0109),
      Color(0xffFD5C01),
      Color(0xffFCC403),
      Color(0xffF8EE00),
      Color(0xffADD302),
      Color(0xff6CC718),
      Color(0xff0EC140),
      Color(0xff009E2D),
      Color(0xff04B666),
      Color(0xff00C0B8),
      Color(0xff1D92D5),
      Color(0xff2D56AD),
      Color(0xff5E52A8),
      Color(0xff6744A2),
      Color(0xff4A2D7F),
    ];

    final labels = List.generate(15, (i) => i.toString());

    return List.generate(15, (i) {
      final isTouched = i == 0; // Cambia esto según el índice tocado
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
        padding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 20), // Ajusta el padding
        child: Column(
          children: [
            Text(
              'Batería',
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 20), // Espacio entre el título y el indicador
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20), // Ajusta el padding
              child: CircularPercentIndicator(
                radius: 40,
                lineWidth: 5,
                percent: 0.7, // Cambia el porcentaje según lo que necesites
                progressColor: Colors.green,
                backgroundColor: Colors.grey.shade100,
                circularStrokeCap: CircularStrokeCap.round,
                center: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.battery_5_bar,
                      weight: 5,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 5), // Espacio entre el ícono y el texto
                    Expanded(
                      // Usa Expanded para ajustar el texto
                      child: Text(
                        '70%', // Cambia esto por el valor que necesites
                        style: GoogleFonts.poppins(fontSize: 16),
                        overflow: TextOverflow
                            .ellipsis, // Agrega "..." si el texto es muy largo
                        maxLines: 1, // Limita a una línea
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

class TemperatureCard extends StatefulWidget {
  @override
  _TemperatureCardState createState() => _TemperatureCardState();
}

class PhCard extends StatefulWidget {
  @override
  _PhCardState createState() => _PhCardState();
}

class _TemperatureCardState extends State<TemperatureCard> {
  double? temperature; // Variable para almacenar la temperatura

  @override
  void initState() {
    super.initState();
    fetchTemperature(); // Llama a la función al iniciar el estado
  }

  Future<void> fetchTemperature() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.4.1/temp'));
      if (response.statusCode == 200) {
        setState(() {
          temperature = double.parse(response.body);
        });
      } else {
        throw Exception('Error al obtener la temperatura');
      }
    } catch (e) {
      print(e);
    }
  }

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
        padding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 20), // Ajusta el padding
        child: Column(
          children: [
            Text('Temperatura',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w700)),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.thermostat_rounded,
                  color: GlobalColors.mainColor,
                ),
                SizedBox(width: 8), // Espacio entre el ícono y el texto
                Expanded(
                  // Usa Expanded para ajustar el texto
                  child: Text(
                    temperature != null
                        ? '${temperature!.toStringAsFixed(1)} °C'
                        : 'Cargando...',
                    style: GoogleFonts.poppins(
                        color: Colors.grey[700],
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow
                        .ellipsis, // Agrega "..." si el texto es muy largo
                    maxLines: 1, // Limita a una línea
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _PhCardState extends State<PhCard> {
  double? ph; // Variable para almacenar el pH

  @override
  void initState() {
    super.initState();
    fetchPh(); // Llama a la función al iniciar el estado
  }

  Future<void> fetchPh() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.4.1/ph'));
      if (response.statusCode == 200) {
        setState(() {
          ph = double.parse(response.body);
        });
      } else {
        throw Exception('Error al obtener el pH');
      }
    } catch (e) {
      print(e);
    }
  }

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
        padding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 20), // Ajusta el padding
        child: Column(
          children: [
            Text('pH',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w700)),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.water_drop_rounded,
                  color: GlobalColors.mainColor,
                ),
                SizedBox(width: 8), // Espacio entre el ícono y el texto
                Expanded(
                  // Usa Expanded para ajustar el texto
                  child: Text(
                    ph != null ? '${ph!.toStringAsFixed(1)}' : 'Cargando...',
                    style: GoogleFonts.poppins(
                        color: Colors.grey[700],
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow
                        .ellipsis, // Agrega "..." si el texto es muy largo
                    maxLines: 1, // Limita a una línea
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
