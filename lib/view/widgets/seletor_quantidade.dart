import 'package:flutter/material.dart';

class SeletorQuantidade extends StatelessWidget {
  final int quantidade;
  final ValueChanged<int> aoAlterar;
  final int minimo;
  final int maximo;

  const SeletorQuantidade({
    super.key,
    required this.quantidade,
    required this.aoAlterar,
    this.minimo = 1,
    this.maximo = 99,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.outlined(
          tooltip: 'Diminuir',
          onPressed: quantidade > minimo
              ? () => aoAlterar(quantidade - 1)
              : null,
          icon: const Icon(Icons.remove),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '$quantidade',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        IconButton.outlined(
          tooltip: 'Aumentar',
          onPressed: quantidade < maximo
              ? () => aoAlterar(quantidade + 1)
              : null,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
