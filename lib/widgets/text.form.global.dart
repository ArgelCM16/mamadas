import 'package:flutter/material.dart';

class TextGeneralForm extends StatefulWidget {
  TextGeneralForm({
    super.key,
    required this.controller,
    this.validator,
    this.maxLength,
    required this.text,
    required this.textInputType,
    required this.obscure,
  });

  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String text;
  final TextInputType textInputType;
  final bool obscure;
  final int? maxLength;

  @override
  _TextGeneralFormState createState() => _TextGeneralFormState();
}

class _TextGeneralFormState extends State<TextGeneralForm> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscure;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 3, left: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 7,
          ),
        ],
      ),
      child: Row( // Utilizamos Row para alinear el campo de texto y el icono
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              obscureText: _obscureText,
              keyboardType: widget.textInputType,
              maxLength: widget.maxLength,
              decoration: InputDecoration(
                hintText: widget.text,
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(0),
                hintStyle: TextStyle(height: 1),
                counterText: "",
              ),
            ),
          ),
          // Aquí agregamos el icono solo si el texto es "contraseña"
          if (widget.text.toLowerCase() == "contraseña")
            IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: _togglePasswordVisibility,
            ),
        ],
      ),
    );
  }
}
