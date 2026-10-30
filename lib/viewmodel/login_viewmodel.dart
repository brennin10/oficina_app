import 'package:flutter/foundation.dart';

import '../core/network/erro_api.dart';
import '../core/state/estado_tela.dart';
import '../model/usuario.dart';
import '../repository/usuario_repository.dart';

class LoginViewModel extends ChangeNotifier {
  final UsuarioRepository _repositorio;
  bool _descartado = false;

  LoginViewModel(this._repositorio);

  EstadoTela _estado = EstadoTela.inicial;
  String? _mensagemErro;
  Usuario? _usuario;

  EstadoTela get estado => _estado;
  String? get mensagemErro => _mensagemErro;
  Usuario? get usuario => _usuario;
  bool get carregando => _estado == EstadoTela.carregando;

  Future<bool> entrar(String email, String senha) async {
    if (carregando) return false;

    _estado = EstadoTela.carregando;
    _mensagemErro = null;
    _usuario = null;
    notifyListeners();

    try {
      _usuario = await _repositorio.login(email.trim(), senha);
      _estado = EstadoTela.sucesso;
      return true;
    } on ErroApi catch (erro) {
      _estado = EstadoTela.erro;
      _mensagemErro = erro.mensagem;
    } catch (_) {
      _estado = EstadoTela.erro;
      _mensagemErro = 'Não foi possível entrar. Tente novamente.';
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
