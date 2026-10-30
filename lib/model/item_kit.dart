import '../core/utils/formatadores.dart';
import 'material.dart';

class ItemKit {
  final int materialId;
  final String nome;
  final String categoria;
  final String imagemUrl;
  final double preco;
  final int quantidade;

  const ItemKit({
    required this.materialId,
    required this.nome,
    required this.categoria,
    required this.imagemUrl,
    required this.preco,
    required this.quantidade,
  });

  double get subtotal => preco * quantidade;

  factory ItemKit.fromJson(Map<String, dynamic> json) {
    // Aceita tanto {materialId, quantidade, material: {...}} quanto campos soltos.
    final material = json['material'] is Map
        ? Map<String, dynamic>.from(json['material'] as Map)
        : json;

    return ItemKit(
      materialId: converterInt(json['materialId'] ?? material['id']),
      nome: (material['nome'] ?? '').toString(),
      categoria: (material['categoria'] ?? '').toString(),
      imagemUrl: Material.resolverImagem(material['imagemUrl']),
      preco: converterDouble(material['preco'] ?? json['preco']),
      quantidade: converterInt(json['quantidade']),
    );
  }

  Map<String, dynamic> toJson() => {
        'materialId': materialId,
        'nome': nome,
        'categoria': categoria,
        'imagemUrl': imagemUrl,
        'preco': preco,
        'quantidade': quantidade,
      };
}