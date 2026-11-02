import 'package:flutter/material.dart';

import '../core/state/estado_tela.dart';
import '../model/item_kit.dart';
import '../model/kit.dart';
import '../viewmodel/kit_viewmodel.dart';
import 'widgets/botao_remover.dart';
import 'widgets/material_card.dart';
import 'widgets/mensagens_estado.dart';
import 'widgets/seletor_quantidade.dart';
import 'widgets/textos_padrao.dart';

class TelaKit extends StatefulWidget {
  final KitViewModel kitViewModel;

  const TelaKit({super.key, required this.kitViewModel});

  @override
  State<TelaKit> createState() => _TelaKitState();
}

class _TelaKitState extends State<TelaKit> {
  KitViewModel get _vm => widget.kitViewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _vm.carregar();
    });
  }

  void _mostrarMensagem(bool ok) {
    final texto = ok ? _vm.mensagemSucesso : _vm.mensagemErro;
    if (texto == null) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(texto)));
  }

  Future<void> _alterarQuantidade(ItemKit item, int quantidade) async {
    final ok = await _vm.alterarQuantidade(
      materialId: item.materialId,
      quantidade: quantidade,
    );
    if (!mounted) return;
    _mostrarMensagem(ok);
  }

  Future<void> _remover(ItemKit item) async {
    final ok = await _vm.remover(item.materialId);
    if (!mounted) return;
    _mostrarMensagem(ok);
  }

  Future<void> _limpar() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (contextDialogo) => AlertDialog(
        title: const Text('Limpar kit'),
        content: const Text('Remover todos os itens do kit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(contextDialogo).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(contextDialogo).pop(true),
            child: const Text('Limpar'),
          ),
        ],
      ),
    );
    if (confirmar != true || !mounted) return;

    final ok = await _vm.limpar();
    if (!mounted) return;
    _mostrarMensagem(ok);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _vm,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Meu kit'),
            actions: [
              IconButton(
                tooltip: 'Limpar kit',
                icon: const Icon(Icons.delete_sweep_outlined),
                onPressed: (_vm.kit.vazio || _vm.carregando) ? null : _limpar,
              ),
            ],
          ),
          body: _corpo(),
        );
      },
    );
  }

  Widget _corpo() {
    if (!_vm.jaCarregado) {
      if (_vm.estado == EstadoTela.erro) {
        return MensagemErro(
          mensagem: _vm.mensagemErro ?? 'Erro ao carregar o kit.',
          aoTentarNovamente: _vm.carregar,
        );
      }
      return const IndicadorCarregando(texto: 'Carregando kit...');
    }

    final kit = _vm.kit;
    if (kit.vazio) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inventory_2_outlined, size: 64),
              SizedBox(height: 12),
              Text('Seu kit está vazio.'),
              SizedBox(height: 4),
              Text('Adicione materiais pelo catálogo.'),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        if (_vm.carregando) const LinearProgressIndicator(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: kit.itens.length,
            itemBuilder: (context, indice) {
              final item = kit.itens[indice];
              return MaterialCard(
                material: item.comoMaterial,
                acao: BotaoRemover(
                  tooltip: 'Remover do kit',
                  aoPressionar:
                      _vm.carregando ? null : () => _remover(item),
                ),
                rodape: _rodapeItem(item),
              );
            },
          ),
        ),
        _resumo(kit),
      ],
    );
  }

  Widget _rodapeItem(ItemKit item) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SeletorQuantidade(
            quantidade: item.quantidade,
            aoAlterar: (novoValor) => _alterarQuantidade(item, novoValor),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const TextoSecundario('Subtotal'),
              TextoPreco(valor: item.subtotal),
            ],
          ),
        ],
      ),
    );
  }

  Widget _resumo(Kit kit) {
    return SafeArea(
      top: false,
      child: Card(
        margin: const EdgeInsets.all(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TextoSecundario('Itens diferentes'),
                  Text('${kit.itens.length}'),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TextoSecundario('Total de unidades'),
                  Text('${kit.totalUnidades}'),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TituloSecao('Total'),
                  TextoPreco(
                    valor: kit.total,
                    estilo: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}