import 'package:flutter/material.dart';

import '../repository/repositorios.dart';
import '../viewmodel/cadastro_usuario_viewmodel.dart';
import 'widgets/campo_formulario.dart';

class TelaCadastroUsuario extends StatefulWidget {
  final Repositorios repositorios;

  const TelaCadastroUsuario({super.key, required this.repositorios});

  @override
  State<TelaCadastroUsuario> createState() => _TelaCadastroUsuarioState();
}

class _TelaCadastroUsuarioState extends State<TelaCadastroUsuario> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarController = TextEditingController();
  late final CadastroUsuarioViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = CadastroUsuarioViewModel(widget.repositorios.usuarios);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final cadastrado = await _viewModel.cadastrar(
      nome: _nomeController.text.trim(),
      email: email,
      senha: _senhaController.text,
    );
    if (!mounted || !cadastrado) return;

    Navigator.of(context).pop(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar conta')),
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
                      validador: (valor) {
                        if (valor == null || valor.trim().isEmpty) {
                          return 'Informe seu nome.';
                        }
                        return null;
                      },
                    ),
                    CampoFormulario(
                      controller: _emailController,
                      rotulo: 'E-mail',
                      teclado: TextInputType.emailAddress,
                      validador: (valor) {
                        if (valor == null || !valor.contains('@')) {
                          return 'Informe um e-mail válido.';
                        }
                        return null;
                      },
                    ),
                    CampoFormulario(
                      controller: _senhaController,
                      rotulo: 'Senha',
                      ocultar: true,
                      validador: (valor) {
                        if (valor == null || valor.length < 6) {
                          return 'A senha deve ter pelo menos 6 caracteres.';
                        }
                        return null;
                      },
                    ),
                    CampoFormulario(
                      controller: _confirmarController,
                      rotulo: 'Confirmar senha',
                      ocultar: true,
                      validador: (valor) {
                        if (valor != _senhaController.text) {
                          return 'As senhas não coincidem.';
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
                          : const Text('Criar conta'),
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
