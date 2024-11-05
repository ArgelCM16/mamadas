import 'package:flutter/material.dart';

class WaveAnimation extends StatelessWidget {
  final Animation<double> animation;

  const WaveAnimation({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
        bottom: animation.value,
        left: 0,
        right: 0,
        child: ClipPath(
          clipper: BottomWaveClipper(),
          child: Opacity(
            opacity: 0.5,
            child: Container(
              color: Colors.blue,
              width: MediaQuery.of(context).size.width,
              height: 200,
            ),
          ),
        ),
      ),
      Positioned(
        bottom: animation.value - 100,
        left: 0,
        right: 0,
        child: ClipPath(
          clipper: BottomWaveClipper(),
          child: Opacity(
            opacity: 0.5,
            child: Container(
              color: const Color.fromARGB(255, 20, 94, 155),
              width: MediaQuery.of(context).size.width,
              height: 200,
            ),
          ),
        ),
      ),
    ]);
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0.0, 40.0);
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 40.0);

    for (int i = 0; i < 10; i++) {
      if (i % 2 == 0) {
        path.quadraticBezierTo(
          size.width - (size.width / 16) - (i * size.width / 8),
          0.0,
          size.width - ((i + 1) * size.width / 8),
          size.height - 160,
        );
      } else {
        path.quadraticBezierTo(
          size.width - (size.width / 16) - (i * size.width / 8),
          size.height - 120,
          size.width - ((i + 1) * size.width / 8),
          size.height - 160,
        );
      }
    }

    path.lineTo(0.0, 40.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
