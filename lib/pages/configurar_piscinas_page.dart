// import 'package:flutter/material.dart';
// // ignore: depend_on_referenced_packages
// import 'package:google_fonts/google_fonts.dart';
// import 'package:poolclean/utils/global.colors.dart';

// class ConfigurarPiscinaPage extends StatefulWidget {
//   const ConfigurarPiscinaPage({super.key});

//   @override
//   State<ConfigurarPiscinaPage> createState() => _ConfigurarPiscinaPageState();
// }

// class _ConfigurarPiscinaPageState extends State<ConfigurarPiscinaPage> {
//   final List<String> piscinas = ['Piscina 1', 'Piscina 2', 'Piscina 3'];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: GlobalColors.mainColor,
//         title: Text(
//           'Configurar datos de la piscina',
//           style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Piscinas registradas:',
//               style: GoogleFonts.poppins(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: piscinas.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(piscinas[index],
//                         style: GoogleFonts.poppins(fontSize: 16)),
//                     leading: Icon(Icons.pool, color: GlobalColors.mainColor),
//                     trailing: const Icon(Icons.arrow_forward_ios),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ConfigurarDetallesPiscinaPage(
//                               piscina: piscinas[index]),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: GlobalColors.mainColor,
//                 padding: const EdgeInsets.symmetric(vertical: 16.0),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//               child: Text(
//                 'Agregar nueva piscina',
//                 style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ConfigurarDetallesPiscinaPage extends StatefulWidget {
//   final String piscina;

//   const ConfigurarDetallesPiscinaPage({super.key, required this.piscina});

//   @override
//   State<ConfigurarDetallesPiscinaPage> createState() =>
//       _ConfigurarDetallesPiscinaPageState();
// }

// class _ConfigurarDetallesPiscinaPageState
//     extends State<ConfigurarDetallesPiscinaPage> {
//   final TextEditingController _nombreController = TextEditingController();
//   final TextEditingController _tamanioController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     // Inicializa los campos con los datos de la piscina seleccionada (si los tuviera)
//     _nombreController.text = widget.piscina;
//     // Aquí puedes cargar más datos si tienes persistencia
//   }

//   @override
//   void dispose() {
//     _nombreController.dispose();
//     _tamanioController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: GlobalColors.mainColor,
//         title: Text(
//           'Detalles de ${widget.piscina}',
//           style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _nombreController,
//               decoration: InputDecoration(
//                 labelText: 'Nombre de la piscina',
//                 prefixIcon: const Icon(Icons.pool),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _tamanioController,
//               decoration: InputDecoration(
//                 labelText: 'Tamaño (m³)',
//                 prefixIcon: const Icon(Icons.aspect_ratio),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//               keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Aquí puedes guardar los datos modificados o realizar la lógica que necesites
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Datos guardados')),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: GlobalColors.mainColor,
//                 padding: const EdgeInsets.symmetric(vertical: 16.0),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//               child: Text(
//                 'Guardar cambios',
//                 style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


//DESHABILITADA TEMPORALMENTE: LUIS NAAL 05/11/2024
