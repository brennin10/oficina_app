class Usuario {
  final int id;
  final String nome;
  final String email;

  const Usuario({required this.id, required this.nome, required this.email});

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: (json['id'] as num).toInt(),
      nome: (json['nome'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'nome': nome, 'email': email};
}