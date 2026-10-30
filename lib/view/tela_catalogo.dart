import 'package:flutter/material.dart' hide Material;

import '../core/state/estado_tela.dart';
import '../model/material.dart';
import '../model/usuario.dart';
import '../repository/repositorios.dart';
import '../viewmodel/catalogo_viewmodel.dart';
import 'tela_detalhes.dart';
import 'tela_login.dart';
import 'widgets/material_card.dart';
import 'widgets/mensagens_estado.dart';

class TelaCatalogo extends StatefulWidget {
  final Usuario usuario;
  final Repositorios repositorios;

  const TelaCatalogo({
    super.key,
    required this.usuario,
    required this.repositorios,
  });

  @override
  State<TelaCatalogo> createState() => _TelaCatalogoState();
}

class _TelaCatalogoState extends State<TelaCatalogo> {
  late final CatalogoViewModel _viewModel;
  String _busca = '';
  String? _categoriaSelecionada;

  @override
  void initState() {
    super.initState();
    _viewModel = CatalogoViewModel(widget.repositorios.materiais);
    _viewModel.carregar();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _sair() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (_) => TelaLogin(repositorios: widget.repositorios),
      ),
      (rota) => false,
    );
  }

  void _abrirDetalhes(Material material) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => TelaDetalhes(
          materialId: material.id,
          usuario: widget.usuario,
          repositorios: widget.repositorios,
        ),
      ),
    );
  }

  List<Material> _filtrar(List<Material> todos) {
    final termo = _busca.trim().toLowerCase();
    return todos.where((material) {
      final combinaNome = material.nome.toLowerCase().contains(termo);
      final combinaCategoria =
          _categoriaSelecionada == null ||
          material.categoria == _categoriaSelecionada;
      return combinaNome && combinaCategoria;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Olá, ${widget.usuario.nome}'),
        actions: [
          IconButton(
            tooltip: 'Sair / trocar de conta',
            icon: const Icon(Icons.logout),
            onPressed: _sair,
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          switch (_viewModel.estado) {
            case EstadoTela.inicial:
            case EstadoTela.carregando:
              return const IndicadorCarregando(texto: 'Carregando catálogo...');
            case EstadoTela.erro:
              return MensagemErro(
                mensagem:
                    _viewModel.mensagemErro ?? 'Erro ao carregar o catálogo.',
                aoTentarNovamente: _viewModel.carregar,
              );
            case EstadoTela.sucesso:
              return _conteudo(_viewModel.materiais);
          }
        },
      ),
    );
  }

  Widget _conteudo(List<Material> todos) {
    final categorias =
        todos
            .map((material) => material.categoria)
            .where((categoria) => categoria.isNotEmpty)
            .toSet()
            .toList()
          ..sort();
    final filtrados = _filtrar(todos);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              labelText: 'Pesquisar por nome',
              border: OutlineInputBorder(),
            ),
            onChanged: (valor) => setState(() => _busca = valor),
          ),
        ),
        SizedBox(
          height: 48,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: const Text('Todas'),
                  selected: _categoriaSelecionada == null,
                  onSelected: (_) =>
                      setState(() => _categoriaSelecionada = null),
                ),
              ),
              for (final categoria in categorias)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(categoria),
                    selected: _categoriaSelecionada == categoria,
                    onSelected: (_) =>
                        setState(() => _categoriaSelecionada = categoria),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: filtrados.isEmpty
              ? const Center(child: Text('Nenhum material encontrado.'))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  itemCount: filtrados.length,
                  itemBuilder: (context, indice) {
                    final material = filtrados[indice];
                    return MaterialCard(
                      material: material,
                      aoTocar: () => _abrirDetalhes(material),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
