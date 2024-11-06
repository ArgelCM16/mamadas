import 'package:flutter/material.dart';
import 'package:poolclean/utils/global.colors.dart';

class CardPhotoPerfil extends StatelessWidget {
  const CardPhotoPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    double baseWidth = 400;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 1000,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: GlobalColors.colorborde),
        margin: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: [
                  Container(
                    width: fem * 80,
                    height: fem * 80,
                    decoration: BoxDecoration(
                        color: GlobalColors.mainColor, shape: BoxShape.circle),
                    child: const Icon(
                      Icons.person_2_rounded,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}