import '../core/config/api_config.dart';
import '../core/utils/formatadores.dart';

class Material {
  final int id;
  final String nome;
  final String descricao;
  final String categoria;
  final double preco;
  final String imagemUrl;

  const Material({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.categoria,
    required this.preco,
    required this.imagemUrl,
  });

  factory Material.fromJson(Map<String, dynamic> json) {
    return Material(
      id: converterInt(json['id']),
      nome: (json['nome'] ?? '').toString(),
      descricao: (json['descricao'] ?? '').toString(),
      categoria: (json['categoria'] ?? '').toString(),
      preco: converterDouble(json['preco']),
      imagemUrl: resolverImagem(json['imagemUrl']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'descricao': descricao,
        'categoria': categoria,
        'preco': preco,
        'imagemUrl': imagemUrl,
      };

  /// Se a API mandar só "/imagens/x.png", completa com o endereço do servidor.
  static String resolverImagem(Object? valor) {
    final texto = (valor ?? '').toString().trim();
    if (texto.isEmpty) return '';
    if (texto.startsWith('http')) return texto;

    var base = ApiConfig.baseUrl;
    if (base.endsWith('/')) base = base.substring(0, base.length - 1);
    return texto.startsWith('/') ? '$base$texto' : '$base/$texto';
  }
}