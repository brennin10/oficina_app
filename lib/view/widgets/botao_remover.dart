import 'package:flutter/material.dart';

class BotaoRemover extends StatelessWidget {
  final VoidCallback? aoPressionar;
  final String tooltip;

  const BotaoRemover({
    super.key,
    required this.aoPressionar,
    this.tooltip = 'Remover',
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: aoPressionar,
      icon: Icon(
        Icons.delete_outline,
        color: aoPressionar == null
            ? null
            : Theme.of(context).colorScheme.error,
      ),
    );
  }
}
