import 'package:flutter/foundation.dart';

import '../core/network/erro_api.dart';
import '../core/state/estado_tela.dart';
import '../repository/usuario_repository.dart';

class CadastroUsuarioViewModel extends ChangeNotifier {
  final UsuarioRepository _repositorio;
  bool _descartado = false;

  CadastroUsuarioViewModel(this._repositorio);

  EstadoTela _estado = EstadoTela.inicial;
  String? _mensagemErro;

  EstadoTela get estado => _estado;
  String? get mensagemErro => _mensagemErro;
  bool get carregando => _estado == EstadoTela.carregando;

  // POST /usuarios
  Future<bool> cadastrar({
    required String nome,
    required String email,
    required String senha,
  }) async {
    if (carregando) return false;

    _estado = EstadoTela.carregando;
    _mensagemErro = null;
    notifyListeners();

    try {
      await _repositorio.cadastrar(nome: nome, email: email, senha: senha);
      _estado = EstadoTela.sucesso;
      return true;
    } on ErroApi catch (erro) {
      _estado = EstadoTela.erro;
      _mensagemErro = erro.mensagem;
    } catch (_) {
      _estado = EstadoTela.erro;
      _mensagemErro = 'Não foi possível criar a conta.';
    } finally {
      if (!_descartado) notifyListeners();
    }
    return false;
  }

  @override
  void dispose() {
    _descartado = true;
    super.dispose();
  }
}
