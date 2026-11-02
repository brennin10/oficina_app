import 'package:flutter/foundation.dart';

import '../core/network/erro_api.dart';
import '../core/state/estado_tela.dart';
import '../model/kit.dart';
import '../repository/kit_repository.dart';

class KitViewModel extends ChangeNotifier {
  final KitRepository _repositorio;
  final int usuarioId;
  bool _descartado = false;
  bool _jaCarregado = false;

  KitViewModel(this._repositorio, {required this.usuarioId})
      : _kit = Kit(usuarioId: usuarioId, itens: const []);

  Kit _kit;
  EstadoTela _estado = EstadoTela.inicial;
  String? _mensagemErro;
  String? _mensagemSucesso;

  Kit get kit => _kit;
  EstadoTela get estado => _estado;
  String? get mensagemErro => _mensagemErro;
  String? get mensagemSucesso => _mensagemSucesso;
  bool get carregando => _estado == EstadoTela.carregando;
  bool get jaCarregado => _jaCarregado;

  // GET /kit?usuarioId=
  Future<bool> carregar() {
    return _executar(() => _repositorio.consultar(usuarioId));
  }

  // POST /kit (a API soma a quantidade)
  Future<bool> adicionar({required int materialId, required int quantidade}) {
    return _executar(
      () => _repositorio.adicionar(
        usuarioId: usuarioId,
        materialId: materialId,
        quantidade: quantidade,
      ),
      sucesso: 'Material adicionado ao kit.',
    );
  }

  // PATCH /kit/:materialId (a API substitui a quantidade)
  Future<bool> alterarQuantidade({
    required int materialId,
    required int quantidade,
  }) {
    return _executar(
      () => _repositorio.alterarQuantidade(
        usuarioId: usuarioId,
        materialId: materialId,
        quantidade: quantidade,
      ),
      sucesso: 'Quantidade atualizada.',
    );
  }

  // DELETE /kit/:materialId?usuarioId=
  Future<bool> remover(int materialId) {
    return _executar(
      () => _repositorio.remover(usuarioId: usuarioId, materialId: materialId),
      sucesso: 'Item removido do kit.',
    );
  }

  // DELETE /kit?usuarioId=
  Future<bool> limpar() {
    return _executar(
      () => _repositorio.limpar(usuarioId),
      sucesso: 'Kit esvaziado.',
    );
  }

  Future<bool> _executar(
    Future<Kit> Function() operacao, {
    String? sucesso,
  }) async {
    if (carregando) return false;

    _estado = EstadoTela.carregando;
    _mensagemErro = null;
    _mensagemSucesso = null;
    notifyListeners();

    try {
      _kit = await operacao();
      _jaCarregado = true;
      _estado = EstadoTela.sucesso;
      _mensagemSucesso = sucesso;
      return true;
    } on ErroApi catch (erro) {
      _estado = EstadoTela.erro;
      _mensagemErro = erro.mensagem;
    } catch (_) {
      _estado = EstadoTela.erro;
      _mensagemErro = 'Não foi possível concluir a operação no kit.';
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