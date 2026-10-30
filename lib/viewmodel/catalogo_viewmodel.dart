import 'package:flutter/foundation.dart';

import '../core/network/erro_api.dart';
import '../core/state/estado_tela.dart';
import '../model/material.dart';
import '../repository/material_repository.dart';

class CatalogoViewModel extends ChangeNotifier {
  final MaterialRepository _repositorio;
  bool _descartado = false;

  CatalogoViewModel(this._repositorio);

  List<Material> _materiais = [];
  EstadoTela _estado = EstadoTela.inicial;
  String? _mensagemErro;

  List<Material> get materiais => List.unmodifiable(_materiais);
  EstadoTela get estado => _estado;
  String? get mensagemErro => _mensagemErro;

  Future<void> carregar() async {
    _estado = EstadoTela.carregando;
    _mensagemErro = null;
    notifyListeners();

    try {
      _materiais = await _repositorio.listar();
      _estado = EstadoTela.sucesso;
    } on ErroApi catch (erro) {
      _estado = EstadoTela.erro;
      _mensagemErro = erro.mensagem;
    } catch (_) {
      _estado = EstadoTela.erro;
      _mensagemErro = 'Não foi possível carregar o catálogo.';
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
