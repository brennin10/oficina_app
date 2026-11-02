import 'package:flutter/material.dart' hide Material;

import '../core/state/estado_tela.dart';
import '../model/material.dart';
import '../repository/repositorios.dart';
import '../viewmodel/detalhes_viewmodel.dart';
import '../viewmodel/kit_viewmodel.dart';
import 'widgets/mensagens_estado.dart';
import 'widgets/seletor_quantidade.dart';
import 'widgets/textos_padrao.dart';

class TelaDetalhes extends StatefulWidget {
  final int materialId;
  final KitViewModel kitViewModel;
  final Repositorios repositorios;

  const TelaDetalhes({
    super.key,
    required this.materialId,
    required this.kitViewModel,
    required this.repositorios,
  });

  @override
  State<TelaDetalhes> createState() => _TelaDetalhesState();
}

class _TelaDetalhesState extends State<TelaDetalhes> {
  late final DetalhesViewModel _viewModel;
  int _quantidade = 1;

  @override
  void initState() {
    super.initState();
    _viewModel = DetalhesViewModel(widget.repositorios.materiais);
    _viewModel.carregar(widget.materialId);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _adicionarAoKit(Material material) async {
    final kitVm = widget.kitViewModel;
    final quantidadeEscolhida = _quantidade;

    final ok = await kitVm.adicionar(
      materialId: material.id,
      quantidade: quantidadeEscolhida,
    );
    if (!mounted) return;

    final texto = ok
        ? 'Adicionado ao kit: ${material.nome} (x$quantidadeEscolhida).'
        : (kitVm.mensagemErro ?? 'Não foi possível adicionar ao kit.');
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(texto)));

    if (ok) setState(() => _quantidade = 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do material')),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          switch (_viewModel.estado) {
            case EstadoTela.inicial:
            case EstadoTela.carregando:
              return const IndicadorCarregando();
            case EstadoTela.erro:
              return MensagemErro(
                mensagem:
                    _viewModel.mensagemErro ?? 'Erro ao carregar o material.',
                aoTentarNovamente: () =>
                    _viewModel.carregar(widget.materialId),
              );
            case EstadoTela.sucesso:
              return _conteudo(_viewModel.material!);
          }
        },
      ),
    );
  }

  Widget _conteudo(Material material) {
    final tema = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              material.imagemUrl,
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
              errorBuilder: (context, erro, pilha) => const SizedBox(
                height: 220,
                child: Center(
                  child: Icon(Icons.image_not_supported_outlined, size: 64),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(material.nome, style: tema.headlineSmall),
          Text(material.categoria, style: tema.bodyMedium),
          const SizedBox(height: 12),
          Text(material.descricao),
          const SizedBox(height: 16),
          Row(
            children: [
              const TextoSecundario('Preço unitário: '),
              TextoPreco(valor: material.preco),
            ],
          ),
          const SizedBox(height: 24),
          const TituloSecao('Quantidade'),
          const SizedBox(height: 8),
          SeletorQuantidade(
            quantidade: _quantidade,
            aoAlterar: (novoValor) => setState(() => _quantidade = novoValor),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const TituloSecao('Total'),
              TextoPreco(
                valor: material.preco * _quantidade,
                estilo: tema.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 24),
          ListenableBuilder(
            listenable: widget.kitViewModel,
            builder: (context, _) {
              return SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: widget.kitViewModel.carregando
                      ? null
                      : () => _adicionarAoKit(material),
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Adicionar ao kit'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}