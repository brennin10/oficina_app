import 'package:flutter/foundation.dart';

import '../core/network/erro_api.dart';
import '../core/state/estado_tela.dart';
import '../model/material.dart';
import '../repository/material_repository.dart';

class DetalhesViewModel extends ChangeNotifier {
  final MaterialRepository _repositorio;
  bool _descartado = false;

  DetalhesViewModel(this._repositorio);

  Material? _material;
  EstadoTela _estado = EstadoTela.inicial;
  String? _mensagemErro;

  Material? get material => _material;
  EstadoTela get estado => _estado;
  String? get mensagemErro => _mensagemErro;

  Future<void> carregar(int id) async {
    _estado = EstadoTela.carregando;
    _mensagemErro = null;
    notifyListeners();

    try {
      _material = await _repositorio.buscarPorId(id);
      _estado = EstadoTela.sucesso;
    } on ErroApi catch (erro) {
      _estado = EstadoTela.erro;
      _mensagemErro = erro.mensagem;
    } catch (_) {
      _estado = EstadoTela.erro;
      _mensagemErro = 'Não foi possível carregar o material.';
    } finally {
      if (!_descartado) notifyListeners();
    }
  }

  @override
  void dispose() {
    _descartado = true;
    super.dispose();
  }
}
