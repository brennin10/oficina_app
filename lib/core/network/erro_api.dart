import 'package:dio/dio.dart';

class ErroApi implements Exception {
  final String mensagem;
  final int? statusCode;

  const ErroApi(this.mensagem, {this.statusCode});

  factory ErroApi.deDio(DioException erro) {
    final status = erro.response?.statusCode;
    final dados = erro.response?.data;

    if (dados is Map) {
      final valor = dados['mensagem'] ??
          dados['erro'] ??
          dados['message'] ??
          dados['error'];
      if (valor is String && valor.isNotEmpty) {
        return ErroApi(valor, statusCode: status);
      }
    }

    switch (erro.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ErroApi('Tempo de conexão esgotado. Tente novamente.');
      case DioExceptionType.connectionError:
        return const ErroApi('Sem conexão com o servidor.');
      default:
        return ErroApi(
          'Erro na requisição${status != null ? ' ($status)' : ''}.',
          statusCode: status,
        );
    }
  }

  @override
  String toString() => mensagem;
}