import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:poolclean/pages/ajustes_iniciales.dart';
import 'package:poolclean/pages/connection.wife.dart';
import 'package:poolclean/pages/detalles_piscina.dart';
import 'package:poolclean/pages/inicio.dart';
import 'package:poolclean/utils/provider.dart';
import 'package:provider/provider.dart'; // Importar Provider
import 'package:poolclean/pages/configuracion.wife.dart';
import 'package:poolclean/pages/login.dart';
import 'package:poolclean/pages/splash.dart';
import 'package:poolclean/pages/home.dart';
import 'package:poolclean/widgets/menu.navegacion.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Bloquea la orientación a vertical
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(const PoolClean());
  });
}
class PoolClean extends StatelessWidget {
  const PoolClean({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => const Splash()),
          GetPage(name: '/home', page: () => const HomePage()),
          GetPage(name: '/sesion', page: () => LoginPage()),
          GetPage(name: '/inicio', page: () => const InicioPage()),
          GetPage(name: '/wife', page: () => ConfiguracionWife()),
          GetPage(name: '/ajustespiscina', page: () => const AjustesInicialesPage()),
          GetPage(name: '/editarpiscina', page: () => const IConfiguracionPiscina()),
          GetPage(name: '/conectarwife', page: () => WiFiConnectionPage()),
        ],
      ),
    );
  }
}
