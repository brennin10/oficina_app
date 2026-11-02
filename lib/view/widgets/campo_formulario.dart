import 'package:flutter/material.dart';

class CampoFormulario extends StatelessWidget {
  final TextEditingController controller;
  final String rotulo;
  final FormFieldValidator<String>? validador;
  final TextInputType? teclado;
  final int linhas;
  final bool ocultar;

  const CampoFormulario({
    super.key,
    required this.controller,
    required this.rotulo,
    this.validador,
    this.teclado,
    this.linhas = 1,
    this.ocultar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: teclado,
        obscureText: ocultar,
        minLines: linhas,
        maxLines: linhas,
        decoration: InputDecoration(
          labelText: rotulo,
          border: const OutlineInputBorder(),
        ),
        validator: validador,
      ),
    );
  }
}
