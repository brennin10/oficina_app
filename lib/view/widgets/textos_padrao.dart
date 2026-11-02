import 'package:flutter/material.dart';

import '../../core/utils/formatadores.dart';

class TituloSecao extends StatelessWidget {
  final String texto;

  const TituloSecao(this.texto, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(texto, style: Theme.of(context).textTheme.titleMedium);
  }
}

class TextoSecundario extends StatelessWidget {
  final String texto;

  const TextoSecundario(this.texto, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(texto, style: Theme.of(context).textTheme.bodySmall);
  }
}

class TextoPreco extends StatelessWidget {
  final double valor;
  final TextStyle? estilo;

  const TextoPreco({super.key, required this.valor, this.estilo});

  @override
  Widget build(BuildContext context) {
    return Text(
      formatarPreco(valor),
      style: estilo ??
          Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}