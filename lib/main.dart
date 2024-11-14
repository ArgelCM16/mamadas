import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poolclean/pages/splash.dart';

void main() {
    WidgetsFlutterBinding.ensureInitialized();
  runApp(const PoolClean());
}

class PoolClean extends StatelessWidget {
  const PoolClean({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}
