// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:poolclean/utils/global.colors.dart';
import 'package:http/http.dart' as http;
import 'package:poolclean/widgets/identificadorp_h.dart';
import 'package:poolclean/widgets/ph_card_widget.dart';
import 'package:poolclean/widgets/temperature_card_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageContent extends StatefulWidget {
  const HomePageContent({Key? key}) : super(key: key);

  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  final _litrajeController = TextEditingController();

  String piscinaId = '';

  @override
  void initState() {
    super.initState();
    _cargarDatosPiscina();
  }

  Future<void> _cargarDatosPiscina() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String id_ = (prefs.getInt('user_id') ?? 0).toString();
      String token_ = prefs.getString('auth_token') ?? '';

      if (id_.isNotEmpty && token_.isNotEmpty) {
        final url = Uri.parse(
            'https://poolcleanapi-production.up.railway.app/api/obtenerPiscinas/$id_');
        final response = await http.get(
          url,
          headers: {'Authorization': 'Bearer $token_'},
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          if (data['piscinas'] != null && data['piscinas'].isNotEmpty) {
            final piscina = data['piscinas'][0];

            setState(() {
              _litrajeController.text = piscina['litraje'] ?? '';

              piscinaId = piscina['piscina_id']; // Guardar piscina_id
            });
          }
        }
      }
    } catch (e) {
      print('Error al cargar datos: $e');
    }
  }

  Future<Map<String, double>> _calcularCloroNecesario() async {
    try {
      if (_litrajeController.text.isNotEmpty) {
        double litraje = double.parse(_litrajeController.text);
        double volumen = litraje / 1000; // Convertir litros a m³

        // Cálculo de cloro
        double cloroLiquido = volumen * 0.1;
        double cloroGranulado = volumen * 10;
        double pastilla200 = volumen / 20;
        double pastilla250 = volumen / 20;

        return {
          "cloroLiquido": cloroLiquido,
          "cloroGranulado": cloroGranulado,
          "pastilla200": pastilla200,
          "pastilla250": pastilla250,
        };
      } else {
        throw Exception("Introduce el litraje de la piscina.");
      }
    } catch (e) {
      throw Exception("Introduce el litraje de la piscina.");
    }
  }

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
            const identificadorpH(),
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
            const Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: TemperatureCard(),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: PhCard(),
                      ),
                    ),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: cardCloro(context),
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  Card cardCloro(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: Offset(4, 4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Text('Saber la cantidad de cloro para la limpieza de mi piscina',
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final cloro = await _calcularCloroNecesario();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Calculo de cloro',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              color: GlobalColors.mainColor,
                            ),
                          ),
                          content: RichText(
                            text: TextSpan(
                              style: GoogleFonts.poppins(
                                  fontSize: 16, color: Colors.black),
                              children: [
                                TextSpan(
                                  text: 'Para la limpieza de tu piscina:\n\n',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[700]),
                                ),
                                TextSpan(
                                  text: '• Cloro líquido: ',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800]),
                                ),
                                TextSpan(
                                  text:
                                      '${cloro["cloroLiquido"]!.toStringAsFixed(2)} litros\n',
                                  style:
                                      GoogleFonts.poppins(color: Colors.black),
                                ),
                                TextSpan(
                                  text: '• Cloro granulado: ',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800]),
                                ),
                                TextSpan(
                                  text:
                                      '${cloro["cloroGranulado"]!.toStringAsFixed(2)} gramos\n',
                                  style:
                                      GoogleFonts.poppins(color: Colors.black),
                                ),
                                TextSpan(
                                  text: '• Pastillas (200g): ',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800]),
                                ),
                                TextSpan(
                                  text:
                                      '${cloro["pastilla200"]!.toStringAsFixed(2)} pastillas\n',
                                  style:
                                      GoogleFonts.poppins(color: Colors.black),
                                ),
                                TextSpan(
                                  text: '• Pastillas (250g): ',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800]),
                                ),
                                TextSpan(
                                  text:
                                      '${cloro["pastilla250"]!.toStringAsFixed(2)} pastillas\n',
                                  style:
                                      GoogleFonts.poppins(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: GlobalColors.mainColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Cerrar',
                                  style:
                                      GoogleFonts.poppins(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                      ),
                    );
                  }
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
                  'Calcular Cloro',
                  style: GoogleFonts.poppins(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
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
