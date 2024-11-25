import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poolclean/pages/detalles_piscina.dart';
import 'package:poolclean/utils/global.colors.dart';

class ConfigurarPiscinaPage extends StatefulWidget {
  const ConfigurarPiscinaPage({super.key});

  @override
  State<ConfigurarPiscinaPage> createState() => _ConfigurarPiscinaPageState();
}

class _ConfigurarPiscinaPageState extends State<ConfigurarPiscinaPage> {
  final List<String> piscinas = ['Piscina 1', 'Piscina 2', 'Piscina 3'];

  void _eliminarPiscina(int index) {
    setState(() {
      piscinas.removeAt(index);
    });
  }

  void _agregarPiscina() {
    TextEditingController piscinaController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar nueva piscina'),
          content: TextField(
            controller: piscinaController,
            decoration: InputDecoration(
              hintText: 'Ingrese el nombre de la piscina',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Agregar'),
              onPressed: () {
                if (piscinaController.text.isNotEmpty) {
                  setState(() {
                    piscinas.add(piscinaController.text);
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalColors.mainColor,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        title: Text(
          'Configurar datos de la piscina',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Piscinas registradas:',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: piscinas.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      piscinas[index],
                      style: GoogleFonts.poppins(fontSize: 16),
                    ),
                    leading: Icon(
                      Icons.pool,
                      color: GlobalColors.mainColor,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.delete_rounded,
                            color: const Color.fromARGB(255, 255, 17, 0),
                          ),
                          onPressed: () {
                            _eliminarPiscina(index);
                          },
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: GlobalColors.mainColor,
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IConfiguracionPiscina(),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _agregarPiscina,
              style: ElevatedButton.styleFrom(
                backgroundColor: GlobalColors.mainColor,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Padding(
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 30,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
