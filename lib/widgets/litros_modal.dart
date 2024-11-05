import 'package:flutter/material.dart';
import 'package:poolclean/pages/inicio.dart';
import 'package:poolclean/utils/global.colors.dart'; 

class LitrosModal extends StatefulWidget {
  final Function(int) onContinue;

  const LitrosModal({super.key, required this.onContinue});

  @override
  // ignore: library_private_types_in_public_api
  _LitrosModalState createState() => _LitrosModalState();
}

class _LitrosModalState extends State<LitrosModal> {
  final TextEditingController _controller = TextEditingController();
  String? _errorMessage;

  void _validateAndContinue() {
    final int? litros = int.tryParse(_controller.text);
    if (litros == null || litros <= 0) {
      setState(() {
        _errorMessage = 'Por favor, ingrese un número válido de litros.';
      });
    } else {
      widget.onContinue(litros);
      Navigator.of(context).pop();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const InicioPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ingrese el litraje de su piscina'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Litros',
              errorText: _errorMessage,
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancelar',
            style: TextStyle(color: Colors.black),
          ),
        ),
        ElevatedButton(
          onPressed: _validateAndContinue,
          style: ElevatedButton.styleFrom(
            backgroundColor: GlobalColors.mainColor,
          ),
          child: const Text(
            'Continuar',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
