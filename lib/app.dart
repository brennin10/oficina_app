import 'package:flutter/material.dart';

import 'core/network/cliente_api.dart';
import 'core/theme/tema_app.dart';
import 'repository/repositorios.dart';
import 'view/tela_login.dart';

class OficinaApp extends StatefulWidget {
  const OficinaApp({super.key});

  @override
  State<OficinaApp> createState() => _OficinaAppState();
}

class _OficinaAppState extends State<OficinaApp> {
  late final Repositorios _repositorios;

  @override
  void initState() {
    super.initState();
    _repositorios = Repositorios.criar(ClienteApi());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kits para oficinas',
      theme: temaApp,
      home: TelaLogin(repositorios: _repositorios),
    );
  }
}