import 'package:flutter/material.dart';

class IndicadorCarregando extends StatelessWidget {
  final String texto;

  const IndicadorCarregando({super.key, this.texto = 'Carregando...'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 12),
          Text(texto),
        ],
      ),
    );
  }
}

class MensagemErro extends StatelessWidget {
  final String mensagem;
  final VoidCallback? aoTentarNovamente;

  const MensagemErro({
    super.key,
    required this.mensagem,
    this.aoTentarNovamente,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(mensagem, textAlign: TextAlign.center),
            if (aoTentarNovamente != null) ...[
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: aoTentarNovamente,
                child: const Text('Tentar novamente'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
