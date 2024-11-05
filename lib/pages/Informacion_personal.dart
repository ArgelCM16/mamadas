import 'package:flutter/material.dart';
import 'package:poolclean/utils/global.colors.dart';
import 'package:google_fonts/google_fonts.dart';

class InformacionPersonal extends StatefulWidget {
  const InformacionPersonal({super.key});

  @override
  _InformacionPersonalState createState() => _InformacionPersonalState();
}

class _InformacionPersonalState extends State<InformacionPersonal> {
  final _formKey = GlobalKey<FormState>();
  String _fullName = 'Mishell Jiménez';
  String _email = 'jimene@gmail.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: GlobalColors.mainColor,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        title: Text(
          'Información personal',
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          const CardPhotoPerfil(),
          const SizedBox(
            height: 20,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                ListTile(
                  title: Row(
                    children: [
                      Text(
                        'Nombre completo:',
                        style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: TextFormField(
                          initialValue: _fullName,
                          decoration: const InputDecoration(
                            fillColor: Colors.grey,
                            border: InputBorder.none,
                            hintText: 'Ingrese su nombre completo',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese su nombre completo';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _fullName = value;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Row(
                    children: [
                      Text(
                        'Correo:',
                        style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: TextFormField(
                          initialValue: _email,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Ingrese su correo electrónico',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese su correo electrónico';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _email = value;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // TODO: Implement the update logic here
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Datos actualizados')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GlobalColors.mainColor,
                      padding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Actualizar datos',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
        margin: EdgeInsets.all(20),
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
                    child: Icon(
                      Icons.person_2_rounded,
                      color: Colors.white,
                    ),
                    decoration: BoxDecoration(
                        color: GlobalColors.mainColor, shape: BoxShape.circle),
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
