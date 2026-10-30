import 'package:dio/dio.dart';

import '../core/network/cliente_api.dart';
import '../core/network/erro_api.dart';
import '../model/kit.dart';

class KitRepository {
  final ClienteApi _cliente;

  KitRepository(this._cliente);

  Future<Kit> consultar(int usuarioId) async {
    try {
      final resposta = await _cliente.dio.get(
        '/kit',
        queryParameters: {'usuarioId': usuarioId},
      );
      return _lerKit(resposta.data, usuarioId) ??
          Kit(usuarioId: usuarioId, itens: const []);
    } on DioException catch (erro) {
      throw ErroApi.deDio(erro);
    }
  }

  Future<Kit> adicionar({
    required int usuarioId,
    required int materialId,
    required int quantidade,
  }) async {
    try {
      final resposta = await _cliente.dio.post('/kit', data: {
        'usuarioId': usuarioId,
        'materialId': materialId,
        'quantidade': quantidade,
      });
      return _lerKit(resposta.data, usuarioId) ?? await consultar(usuarioId);
    } on DioException catch (erro) {
      throw ErroApi.deDio(erro);
    }
  }

  Future<Kit> alterarQuantidade({
    required int usuarioId,
    required int materialId,
    required int quantidade,
  }) async {
    try {
      final resposta = await _cliente.dio.patch(
        '/kit/$materialId',
        data: {'usuarioId': usuarioId, 'quantidade': quantidade},
      );
      return _lerKit(resposta.data, usuarioId) ?? await consultar(usuarioId);
    } on DioException catch (erro) {
      throw ErroApi.deDio(erro);
    }
  }

  Future<Kit> remover({
    required int usuarioId,
    required int materialId,
  }) async {
    try {
      final resposta = await _cliente.dio.delete(
        '/kit/$materialId',
        queryParameters: {'usuarioId': usuarioId},
      );
      return _lerKit(resposta.data, usuarioId) ?? await consultar(usuarioId);
    } on DioException catch (erro) {
      throw ErroApi.deDio(erro);
    }
  }

  Future<Kit> limpar(int usuarioId) async {
    try {
      final resposta = await _cliente.dio.delete(
        '/kit',
        queryParameters: {'usuarioId': usuarioId},
      );
      return _lerKit(resposta.data, usuarioId) ??
          Kit(usuarioId: usuarioId, itens: const []);
    } on DioException catch (erro) {
      throw ErroApi.deDio(erro);
    }
  }

  /// Devolve o Kit se a resposta parecer um kit; senão null.
  Kit? _lerKit(dynamic dados, int usuarioId) {
    if (dados is List) {
      return Kit.fromJson({'itens': dados}, usuarioId: usuarioId);
    }
    if (dados is Map) {
      final mapa = Map<String, dynamic>.from(dados);
      if (mapa['kit'] != null) return _lerKit(mapa['kit'], usuarioId);
      if (mapa.containsKey('itens') || mapa.containsKey('items')) {
        return Kit.fromJson(mapa, usuarioId: usuarioId);
      }
    }
    return null;
  }
}