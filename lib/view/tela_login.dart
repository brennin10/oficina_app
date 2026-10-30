import 'package:flutter/material.dart';

import 'repository/repositorios.dart';
import 'viewmodel/login_viewmodel.dart';
import 'widgets/tela_catalogo.dart';

class TelaLogin extends StatefulWidget {
  final Repositorios repositorios;

  const TelaLogin({super.key, required this.repositorios});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'ana@ifs.edu.br');
  final _senhaController = TextEditingController(text: '123456');
  late final LoginViewModel _viewModel;
  bool _ocultarSenha = true;

  @override
  void initState() {
    super.initState();
    _viewModel = LoginViewModel(widget.repositorios.usuarios);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    if (!_formKey.currentState!.validate()) return;

    final entrou = await _viewModel.entrar(
      _emailController.text,
      _senhaController.text,
    );
    if (!mounted || !entrou) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => TelaCatalogo(
          usuario: _viewModel.usuario!,
          repositorios: widget.repositorios,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: ListenableBuilder(
                listenable: _viewModel,
                builder: (context, _) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 64,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Kits para oficinas',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'E-mail',
                            border: OutlineInputBorder(),
                          ),
                          validator: (valor) {
                            if (valor == null || !valor.contains('@')) {
                              return 'Informe um e-mail válido.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _senhaController,
                          obscureText: _ocultarSenha,
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(_ocultarSenha
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () => setState(
                                  () => _ocultarSenha = !_ocultarSenha),
                            ),
                          ),
                          validator: (valor) {
                            if (valor == null || valor.isEmpty) {
                              return 'Informe a senha.';
                            }
                            return null;
                          },
                        ),
                        if (_viewModel.mensagemErro != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            _viewModel.mensagemErro!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: _viewModel.carregando ? null : _entrar,
                          child: _viewModel.carregando
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Entrar'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}