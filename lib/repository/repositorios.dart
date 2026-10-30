import '../core/network/cliente_api.dart';
import 'kit_repository.dart';
import 'material_repository.dart';
import 'usuario_repository.dart';

class Repositorios {
  final UsuarioRepository usuarios;
  final MaterialRepository materiais;
  final KitRepository kit;

  const Repositorios({
    required this.usuarios,
    required this.materiais,
    required this.kit,
  });

  factory Repositorios.criar(ClienteApi cliente) {
    return Repositorios(
      usuarios: UsuarioRepository(cliente),
      materiais: MaterialRepository(cliente),
      kit: KitRepository(cliente),
    );
  }
}
