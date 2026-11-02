import 'package:flutter/material.dart';

import '../repository/repositorios.dart';
import '../viewmodel/cadastro_material_viewmodel.dart';
import 'widgets/campo_formulario.dart';

class TelaCadastroMaterial extends StatefulWidget {
  final Repositorios repositorios;

  const TelaCadastroMaterial({super.key, required this.repositorios});

  @override
  State<TelaCadastroMaterial> createState() => _TelaCadastroMaterialState();
}

class _TelaCadastroMaterialState extends State<TelaCadastroMaterial> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _categoriaController = TextEditingController();
  final _precoController = TextEditingController();
  final _imagemController = TextEditingController();
  late final CadastroMaterialViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = CadastroMaterialViewModel(widget.repositorios.materiais);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _nomeController.dispose();
    _descricaoController.dispose();
    _categoriaController.dispose();
    _precoController.dispose();
    _imagemController.dispose();
    super.dispose();
  }

  double? _lerPreco(String valor) {
    return double.tryParse(valor.trim().replaceAll(',', '.'));
  }

  String? _obrigatorio(String? valor, String mensagem) {
    if (valor == null || valor.trim().isEmpty) return mensagem;
    return null;
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final cadastrado = await _viewModel.cadastrar(
      nome: _nomeController.text.trim(),
      descricao: _descricaoController.text.trim(),
      categoria: _categoriaController.text.trim(),
      preco: _lerPreco(_precoController.text)!,
      imagemUrl: _imagemController.text,
    );
    if (!mounted || !cadastrado) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Material cadastrado com sucesso.')),
    );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo material')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ListenableBuilder(
            listenable: _viewModel,
            builder: (context, _) {
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CampoFormulario(
                      controller: _nomeController,
                      rotulo: 'Nome',
                      validador: (valor) =>
                          _obrigatorio(valor, 'Informe o nome do material.'),
                    ),
                    CampoFormulario(
                      controller: _descricaoController,
                      rotulo: 'Descrição',
                      linhas: 3,
                      validador: (valor) =>
                          _obrigatorio(valor, 'Informe a descrição.'),
                    ),
                    CampoFormulario(
                      controller: _categoriaController,
                      rotulo: 'Categoria',
                      validador: (valor) =>
                          _obrigatorio(valor, 'Informe a categoria.'),
                    ),
                    CampoFormulario(
                      controller: _precoController,
                      rotulo: 'Preço (R\$)',
                      teclado: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validador: (valor) {
                        final preco = _lerPreco(valor ?? '');
                        if (preco == null || !preco.isFinite || preco <= 0) {
                          return 'Informe um preço maior que zero.';
                        }
                        return null;
                      },
                    ),
                    CampoFormulario(
                      controller: _imagemController,
                      rotulo: 'URL da imagem (opcional)',
                      teclado: TextInputType.url,
                      validador: (valor) {
                        final texto = (valor ?? '').trim();
                        if (texto.isNotEmpty && !texto.startsWith('http')) {
                          return 'Use uma URL que comece com http.';
                        }
                        return null;
                      },
                    ),
                    if (_viewModel.mensagemErro != null) ...[
                      Text(
                        _viewModel.mensagemErro!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    FilledButton(
                      onPressed: _viewModel.carregando ? null : _salvar,
                      child: _viewModel.carregando
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Cadastrar material'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
