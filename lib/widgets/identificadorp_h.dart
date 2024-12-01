// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class identificadorpH extends StatelessWidget {
  const identificadorpH({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
