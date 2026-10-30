import 'package:flutter/material.dart' hide Material;

import '../../core/utils/formatadores.dart';
import '../../model/material.dart';

class MaterialCard extends StatelessWidget {
  final Material material;
  final VoidCallback? aoTocar;
  final Widget? acao;

  const MaterialCard({
    super.key,
    required this.material,
    this.aoTocar,
    this.acao,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: aoTocar,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  material.imagemUrl,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                  errorBuilder: (context, erro, pilha) => const SizedBox(
                    width: 72,
                    height: 72,
                    child: Icon(Icons.image_not_supported_outlined),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(material.nome, style: tema.titleMedium),
                    Text(material.categoria, style: tema.bodySmall),
                    const SizedBox(height: 4),
                    Text(formatarPreco(material.preco), style: tema.titleSmall),
                  ],
                ),
              ),
              if (acao != null) acao!,
            ],
          ),
        ),
      ),
    );
  }
}
