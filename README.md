# oficina_app: Kits de materiais para oficinas

Aplicativo Flutter para planejar os materiais e o custo dos kits de oficinas acadêmicas. O usuário cria uma conta, entra, consulta o catálogo compartilhado de materiais e monta o seu kit. Cada usuário mantém quantidades próprias.

Projeto Integrador A1 da disciplina **Programação para Dispositivos Móveis**, do Bacharelado em Sistemas de Informação do **IFS, Campus Lagarto** (professor Danilo Ferreira Neves).

## Equipe

- Andreina Santana
- Tarcísio Silveira
- Brenno Costa

## Funcionalidades

- **Login e cadastro de usuário**, com mensagem para credenciais incorretas e opção de sair e trocar de conta.
- **Catálogo de materiais** com imagem, nome, categoria e preço, com pesquisa por nome e filtro por categoria.
- **Detalhes do material**, com quantidade de 1 a 99 e cálculo de preço × quantidade.
- **Kit do usuário**: adicionar materiais, alterar quantidades, remover itens e limpar o kit, com subtotal por item, soma de unidades e total.
- **Cadastro de material**, com validação de preço e URL de imagem opcional.
- Kits **independentes por conta**: alterar o kit de um usuário não afeta os outros.

## Tecnologias

- Flutter e Dart (SDK `^3.13.4`, conforme o `pubspec.yaml`)
- [Dio](https://pub.dev/packages/dio) para as requisições HTTP
- `ChangeNotifier` e `ListenableBuilder` para o estado dos ViewModels
- Material Design 3

## Arquitetura

O projeto segue uma divisão em camadas (MVVM):

| Camada | Responsabilidade |
|---|---|
| `model` | Dados da API, com listas e conversão `fromJson`/`toJson` |
| `repository` | Requisições HTTP com Dio, uma rota por método |
| `viewmodel` | Coordena as operações, guarda o estado e chama `notifyListeners()` |
| `view` | Telas e componentes reutilizáveis |
| `core` | Configuração, cliente HTTP, erros, estados, tema e formatadores |

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── config/        endereço da API
│   ├── network/       cliente Dio e tratamento de erros
│   ├── state/         estados da tela (inicial, carregando, sucesso, erro)
│   ├── theme/         tema
│   └── utils/         formatadores
├── model/             Usuario, Material, ItemKit, Kit
├── repository/        UsuarioRepository, MaterialRepository, KitRepository
├── viewmodel/         login, catálogo, detalhes, kit, cadastro de material e de usuário
└── view/
    ├── tela_login, tela_cadastro_usuario, tela_catalogo,
    │   tela_detalhes, tela_kit, tela_cadastro_material
    └── widgets/       componentes reutilizáveis
```

### Gerenciamento de estado

- **`setState`**: só para variáveis locais da tela (pesquisa, filtro de categoria, quantidade escolhida e mostrar/ocultar a senha).
- **`ChangeNotifier`**: nos ViewModels, com `notifyListeners()` ao iniciar e ao concluir cada operação. As telas acompanham com `ListenableBuilder`.

### Componentes reutilizáveis

`MaterialCard`, `SeletorQuantidade`, `BotaoRemover`, `TituloSecao`, `TextoSecundario`, `TextoPreco`, `CampoFormulario`, `IndicadorCarregando` e `MensagemErro`.

## API

O aplicativo consome a API fornecida pelo professor: `http://2.25.235.160:3000`

| Método | Rota | Uso |
|---|---|---|
| POST | `/usuarios` | Criar conta |
| POST | `/login` | Autenticar |
| GET | `/materiais` | Listar o catálogo |
| GET | `/materiais/:id` | Detalhes do material |
| POST | `/materiais` | Cadastrar material |
| GET | `/kit?usuarioId=` | Consultar o kit do usuário |
| POST | `/kit` | Adicionar ao kit (a API soma a quantidade) |
| PATCH | `/kit/:materialId` | Alterar a quantidade (a API substitui) |
| DELETE | `/kit/:materialId?usuarioId=` | Remover um material do kit |
| DELETE | `/kit?usuarioId=` | Limpar o kit |

O endereço fica em `lib/core/config/api_config.dart` e pode ser trocado na execução:

```
flutter run --dart-define=API_BASE_URL=http://outro-endereco:3000
```

## Como executar

**Pré-requisitos:** Flutter instalado (`flutter doctor` sem pendências), um emulador Android ou um dispositivo conectado, e acesso à internet para alcançar a API.

```
git clone <endereço-do-repositório>
cd oficina_app
flutter pub get
flutter run
```

Como a API usa `http://` (sem HTTPS), o `AndroidManifest.xml` já tem a permissão de internet e o `usesCleartextTraffic` habilitados.

## Contas para teste

A senha de todas as contas é `123456`.

| Usuário | E-mail |
|---|---|
| Ana | ana@ifs.edu.br |
| Bruno | bruno@ifs.edu.br |
| Carla | carla@ifs.edu.br |
| Danilo | danilo@ifs.edu.br |

Também é possível criar uma conta nova pela tela **Criar conta**.

## Limitações e melhorias

- Não é possível editar um material depois de cadastrado (a API não tem rota de alteração).
- A categoria do cadastro é um texto livre; uma melhoria seria sugerir as categorias já existentes.
- A URL da imagem precisa ser o link direto de uma imagem; se não carregar, o app mostra um ícone substituto.
- A sessão do usuário fica só em memória: ao fechar o app é preciso entrar de novo.
- Há apenas um teste automatizado (abertura da tela de login).
