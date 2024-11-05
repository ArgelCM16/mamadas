import 'package:flutter/material.dart';

class TextGeneralForm extends StatelessWidget {
  TextGeneralForm(
      {super.key,
      required this.controller,
      this.validator,
      this.maxLength,
      required this.text,
      required this.textInputType,
      required this.obscure});
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String text;
  final TextInputType textInputType;
  final bool obscure;
  final int? maxLength;
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
            )
          ]),
      child: TextFormField(
        controller: controller,
        keyboardType: textInputType,
        obscureText: obscure,
        maxLength: maxLength,
        decoration: InputDecoration(
          hintText: text,
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(0),
          hintStyle: TextStyle(height: 1),
          counterText: "",
        ),
        validator: validator,
      ),
    );
  }
}
