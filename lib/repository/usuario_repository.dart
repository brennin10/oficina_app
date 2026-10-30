import 'package:dio/dio.dart';

import '../core/network/cliente_api.dart';
import '../core/network/erro_api.dart';
import '../model/usuario.dart';

class UsuarioRepository {
  final ClienteApi _cliente;

  UsuarioRepository(this._cliente);

  Future<Usuario> login(String email, String senha) async {
    try {
      final resposta = await _cliente.dio.post(
        '/login',
        data: {'email': email, 'senha': senha},
      );
      return Usuario.fromJson(_extrair(resposta.data));
    } on DioException catch (erro) {
      final status = erro.response?.statusCode;
      if (status == 400 || status == 401 || status == 404) {
        throw const ErroApi('E-mail ou senha incorretos.');
      }
      throw ErroApi.deDio(erro);
    }
  }

  Future<Usuario> cadastrar({
    required String nome,
    required String email,
    required String senha,
  }) async {
    try {
      final resposta = await _cliente.dio.post(
        '/usuarios',
        data: {'nome': nome, 'email': email, 'senha': senha},
      );
      return Usuario.fromJson(_extrair(resposta.data));
    } on DioException catch (erro) {
      throw ErroApi.deDio(erro);
    }
  }

  Map<String, dynamic> _extrair(dynamic dados) {
    if (dados is Map && dados['usuario'] is Map) {
      return Map<String, dynamic>.from(dados['usuario'] as Map);
    }
    return Map<String, dynamic>.from(dados as Map);
  }
}