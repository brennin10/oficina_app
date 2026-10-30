import 'package:dio/dio.dart';

import '../core/network/cliente_api.dart';
import '../core/network/erro_api.dart';
import '../model/material.dart';

class MaterialRepository {
  final ClienteApi _cliente;

  MaterialRepository(this._cliente);

  Future<List<Material>> listar() async {
    try {
      final resposta = await _cliente.dio.get('/materiais');
      final dados = resposta.data;
      final lista = dados is List
          ? dados
          : (dados is Map ? (dados['materiais'] as List? ?? []) : []);
      return lista
          .map((e) => Material.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } on DioException catch (erro) {
      throw ErroApi.deDio(erro);
    }
  }

  Future<Material> buscarPorId(int id) async {
    try {
      final resposta = await _cliente.dio.get('/materiais/$id');
      return Material.fromJson(_extrair(resposta.data));
    } on DioException catch (erro) {
      throw ErroApi.deDio(erro);
    }
  }

  Future<Material> criar({
    required String nome,
    required String descricao,
    required String categoria,
    required double preco,
    String? imagemUrl,
  }) async {
    final corpo = <String, dynamic>{
      'nome': nome,
      'descricao': descricao,
      'categoria': categoria,
      'preco': preco,
    };
    if (imagemUrl != null && imagemUrl.trim().isNotEmpty) {
      corpo['imagemUrl'] = imagemUrl.trim();
    }

    try {
      final resposta = await _cliente.dio.post('/materiais', data: corpo);
      return Material.fromJson(_extrair(resposta.data));
    } on DioException catch (erro) {
      throw ErroApi.deDio(erro);
    }
  }

  Map<String, dynamic> _extrair(dynamic dados) {
    if (dados is Map && dados['material'] is Map) {
      return Map<String, dynamic>.from(dados['material'] as Map);
    }
    return Map<String, dynamic>.from(dados as Map);
  }
}