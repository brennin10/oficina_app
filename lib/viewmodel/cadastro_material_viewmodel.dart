import 'package:flutter/foundation.dart';

import '../core/network/erro_api.dart';
import '../core/state/estado_tela.dart';
import '../repository/material_repository.dart';

class CadastroMaterialViewModel extends ChangeNotifier {
  final MaterialRepository _repositorio;
  bool _descartado = false;

  CadastroMaterialViewModel(this._repositorio);

  EstadoTela _estado = EstadoTela.inicial;
  String? _mensagemErro;

  EstadoTela get estado => _estado;
  String? get mensagemErro => _mensagemErro;
  bool get carregando => _estado == EstadoTela.carregando;

  // POST /materiais
  Future<bool> cadastrar({
    required String nome,
    required String descricao,
    required String categoria,
    required double preco,
    String? imagemUrl,
  }) async {
    if (carregando) return false;

    _estado = EstadoTela.carregando;
    _mensagemErro = null;
    notifyListeners();

    try {
      await _repositorio.criar(
        nome: nome,
        descricao: descricao,
        categoria: categoria,
        preco: preco,
        imagemUrl: imagemUrl,
      );
      _estado = EstadoTela.sucesso;
      return true;
    } on ErroApi catch (erro) {
      _estado = EstadoTela.erro;
      _mensagemErro = erro.mensagem;
    } catch (_) {
      _estado = EstadoTela.erro;
      _mensagemErro = 'Não foi possível cadastrar o material.';
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
