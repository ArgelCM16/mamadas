import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poolclean/pages/Informacion_personal.dart';
import 'package:poolclean/pages/preguntas_frecuentes.dart';
import 'package:poolclean/pages/terminos_condiciones.dart';
import 'package:poolclean/utils/global.colors.dart';
import 'package:image_picker/image_picker.dart';  

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  bool shadowColor = false;
  double? scrolledUnderElevation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const CardProfileImageSettings(),
            const SizedBox(height: 10),
  ListTile(
              shape: Border(
                bottom: BorderSide(color: Colors.grey, width: 0.2),
                top: BorderSide(color: Colors.grey, width: 0.2),
              ),
              leading: Icon(
                Icons.account_circle_rounded,
                color: GlobalColors.mainColor,
              ),
              title: Text(
                'Información personales',
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w500),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InformacionPersonal()));
              },
            ),
            ListTile(
              shape:const Border(
                bottom: BorderSide(color: Colors.grey, width: 0.2),
              ),
              leading: Icon(
                Icons.storage,
                color: GlobalColors.mainColor,
              ),
              title: Text(
                'Configurar datos de la piscina',
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w500),
              ),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
              onTap: () {},
            ),
            ListTile(
              shape:const Border(
                bottom: BorderSide(color: Colors.grey, width: 0.2),
              ),
              leading: Icon(
                Icons.description,
                color: GlobalColors.mainColor,
              ),
              title: Text(
                'Terminos y Condiciones',
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w500),
              ),
              trailing:const Icon(Icons.arrow_forward_ios_rounded),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>const TerminosCondiciones()));
              },
            ),
            ListTile(
              shape: const Border(
                bottom: BorderSide(color: Colors.grey, width: 0.2),
              ),
              leading: Icon(
                Icons.help_outline,
                color: GlobalColors.mainColor,
              ),
              title: Text(
                'Preguntas frecuentes',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PreguntasFrecuentes(),
                  ),
                );
              },
            )
          ]),
        ),
      ),
    );
  }
}

class CardProfileImageSettings extends StatefulWidget {
  const CardProfileImageSettings({super.key});

  @override
  State<CardProfileImageSettings> createState() =>
      _CardProfileImageSettingsState();
}

class _CardProfileImageSettingsState extends State<CardProfileImageSettings> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _selectImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

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
          color: GlobalColors.colorborde,
        ),
        margin:const  EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: _selectImage,
                child: Column(
                  children: [
                    Container(
                      width: fem * 80,
                      height: fem * 80,
                      child: _selectedImage != null
                          ? ClipOval(
                              child: Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                                width: fem * 80,
                                height: fem * 80,
                              ),
                            )
                          : const Icon(
                              Icons.photo_camera,
                              color: Colors.white,
                            ),
                      decoration: BoxDecoration(
                        color: GlobalColors.mainColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text(
                            'Mich Jiménez',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: Colors.grey[800]),
                          ),
                          Text(
                            'jimene@gmail.com',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Colors.grey[800]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

