import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poolclean/pages/historial.dart';
import 'package:poolclean/utils/global.colors.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estadísticas mensuales pH',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: GlobalColors.textColor,
                  ),
                ),
                Text(
                  'Porcentaje mensual sobre el pH generado por tu piscina',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 1,
                    barTouchData: BarTouchData(enabled: true),
                    titlesData: FlTitlesData(
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 42,
                          getTitlesWidget: (double xValue, TitleMeta meta) {
                            final style = TextStyle(
                              color: Colors.pink,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            );
                            String text;
                            switch (xValue.toInt()) {
                              case 0:
                                text = 'Ene';
                                break;
                              case 1:
                                text = 'Feb';
                                break;
                              case 2:
                                text = 'Mar';
                                break;
                              case 3:
                                text = 'Abr';
                                break;
                              case 4:
                                text = 'May';
                                break;
                              case 5:
                                text = 'Jun';
                                break;
                              case 6:
                                text = 'Jul';
                                break;
                              case 7:
                                text = 'Aug';
                                break;
                              case 8:
                                text = 'Sep';
                                break;
                              case 9:
                                text = 'Oct';
                                break;
                              case 10:
                                text = 'Nov';
                                break;
                              case 11:
                                text = 'Dec';
                                break;
                              default:
                                text = '';
                            }
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(text, style: style),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32,
                          interval: 0.25,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            final percentage = (value * 100).toInt();
                            return Text(
                              '$percentage%',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: _createBarGroups(),
                  ),
                ),
              ),
            ),
            Text(
              'Acidic (0.0 - 0.4), Neutral (0.4 - 0.6), Alkaline (0.6 - 1.0)',
              style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[800]),
            ),
            const SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Historial',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: GlobalColors.textColor,
                  ),
                  textAlign: TextAlign.start,
                ),
                const Divider(),
              ],
            ),
            const ListaHistorial(
              fecha: '2023-10-15',
              ph: 7.2,
              temperatura: 25.5,
              humedad: 60.0,
            ),
            const ListaHistorial(
              fecha: '2024-12-16',
              ph: 4.2,
              temperatura: 35.5,
              humedad: 70.0,
            ),
            const ListaHistorial(
              fecha: '2024-09-10',
              ph: 9.2,
              temperatura: 15.5,
              humedad: 80.0,
            ),
            SizedBox(height: 20,),
          ]),
        ),
      ),
    );
  }

  BarChartRodData makeRodData(double y, List<Color> gradientColors) {
    return BarChartRodData(
      toY: y,
      color: Colors.transparent,
      gradient: LinearGradient(
        colors: gradientColors,
      ),
      width: 10,
      borderRadius: BorderRadius.circular(5),
      backDrawRodData: BackgroundBarChartRodData(
        show: true,
        toY: 1,
        color: const Color(0xFFFCFCFC),
      ),
    );
  }

  List<BarChartGroupData> _createBarGroups() {
    final List<double> monthlyValues = [
      0.2, // Ene
      0.4, // Feb
      0.3, // Mar
      0.6, // Abr
      0.75, // May
      0.35, // Jun
      0.42, // Jul
      0.33, // Aug
      0.6, // Sep
      0.9, // Oct
      0.86, // Nov
      1.0 // Dec
    ];

    final List<List<Color>> gradientColors = [
      monthlyValues[0] <= 0.4
          ? [Color(0xffFCC403), Color(0xffFF0109)]
          : [Color(0xff04B666), Color(0xff00C0B8)], // Jan
      monthlyValues[1] <= 0.4
          ? [Color(0xffFCC403), Color(0xffFF0109)]
          : [Color(0xff04B666), Color(0xff00C0B8)], // Feb
      monthlyValues[2] <= 0.4
          ? [Color(0xffFCC403), Color(0xffFF0109)]
          : [Color(0xff04B666), Color(0xff00C0B8)], // Mar
      monthlyValues[3] <= 0.6
          ? [Color(0xff04B666), Color(0xff00C0B8)]
          : [Color(0xff1D92D5), Color(0xff6744A2)], // Apr
      monthlyValues[4] <= 0.6
          ? [Color(0xff04B666), Color(0xff00C0B8)]
          : [Color(0xff1D92D5), Color(0xff6744A2)], // May
      monthlyValues[5] <= 0.4
          ? [Color(0xffFCC403), Color(0xffFF0109)]
          : [Color(0xff04B666), Color(0xff00C0B8)], // Jun
      monthlyValues[6] <= 0.4
          ? [Color(0xffFCC403), Color(0xffFF0109)]
          : [Color(0xff04B666), Color(0xff00C0B8)], // Jul
      monthlyValues[7] <= 0.4
          ? [Color(0xffFCC403), Color(0xffFF0109)]
          : [Color(0xff04B666), Color(0xff00C0B8)], // Aug
      monthlyValues[8] <= 0.6
          ? [Color(0xff04B666), Color(0xff00C0B8)]
          : [Color(0xff1D92D5), Color(0xff6744A2)], // Sep
      monthlyValues[9] <= 0.6
          ? [Color(0xff04B666), Color(0xff00C0B8)]
          : [Color(0xff1D92D5), Color(0xff6744A2)], // Oct
      monthlyValues[10] <= 0.6
          ? [Color(0xff04B666), Color(0xff00C0B8)]
          : [Color(0xff1D92D5), Color(0xff6744A2)], // Nov
      monthlyValues[11] <= 0.6
          ? [Color(0xff04B666), Color(0xff00C0B8)]
          : [Color(0xff1D92D5), Color(0xff6744A2)], // Dec
    ];

    return List.generate(
      monthlyValues.length,
      (index) => BarChartGroupData(
        x: index,
        barRods: [
          makeRodData(monthlyValues[index], gradientColors[index]),
        ],
      ),
    );
  }
}
