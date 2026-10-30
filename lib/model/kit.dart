import 'item_kit.dart';

class Kit {
  final int usuarioId;
  final List<ItemKit> itens;

  const Kit({required this.usuarioId, required this.itens});

  bool get vazio => itens.isEmpty;
  int get totalUnidades => itens.fold(0, (soma, item) => soma + item.quantidade);
  double get total => itens.fold(0.0, (soma, item) => soma + item.subtotal);

  factory Kit.fromJson(Map<String, dynamic> json, {int usuarioId = 0}) {
    final bruto = json['itens'] ?? json['items'] ?? const [];
    final itens = (bruto as List)
        .map((e) => ItemKit.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    return Kit(usuarioId: usuarioId, itens: itens);
  }

  Map<String, dynamic> toJson() => {
        'usuarioId': usuarioId,
        'itens': itens.map((item) => item.toJson()).toList(),
      };
}