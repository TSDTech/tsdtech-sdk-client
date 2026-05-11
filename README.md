# TsdTech Client SDK

[![Pub Version](https://img.shields.io/pub/v/tsdtech_client_sdk)](https://pub.dev/packages/tsdtech_client_sdk)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Dart CI](https://github.com/tsdtech/tsdtech-client-sdk/actions/workflows/dart.yml/badge.svg)](https://github.com/tsdtech/tsdtech-client-sdk/actions/workflows/dart.yml)

SDK Dart/Flutter para integração com a plataforma TsdTech de vouchers e pagamentos.

## ✨ Features

- **Autenticação**: Login e cadastro de usuários clientes
- **Vouchers**: Listagem e gerenciamento de vouchers
- **Checkout**: Pagamentos via cartão e PIX
- **Pedidos**: Gestão completa de pedidos
- **Tipos**: Suporte a múltiplos tipos de serviços e assinaturas

## 📦 Instalação

Adicione ao seu `pubspec.yaml`:

```yaml
dependencies:
  tsdtech_client_sdk: ^0.1.0
```

## 🚀 Usage

### Configuração Inicial

```dart
import 'package:tsdtech_client_sdk/core/constants/constants.dart';
import 'package:tsdtech_client_sdk/core/services/intra-api/md-authorizers/client-users/auth_service.dart';

// Configure o base URL antes de usar os serviços
Constants.setBaseUrl('https://api.seu-servidor.com');
```

### Autenticação

```dart
// Login de usuário cliente
final authService = AuthServiceClientUser.instance;

final result = await authService.login(
  email: 'usuario@exemplo.com',
  password: 'sua-senha',
);

result.fold(
  (loginResponse) {
    print('Login bem-sucedido: ${loginResponse.token}');
  },
  (error) {
    print('Erro no login: $error');
  },
);

// Cadastro de novo usuário
final signupResult = await authService.signup(
  SignupRequestClient(
    email: 'novo@exemplo.com',
    password: 'sua-senha',
    name: 'Nome do Usuário',
    // outros campos...
  ),
);
```

### Checkout com Cartão

```dart
import 'package:tsdtech_client_sdk/core/services/intra-api/md-checkout/checkouts_service.dart';
import 'package:tsdtech_client_sdk/models/checkouts/checkout_request.model.dart';

final checkoutService = CheckoutsService.instance;

// Listar meios de pagamento disponíveis
final methodsResult = await checkoutService.getPaymentMethods();
if (methodsResult.isSuccess) {
  print('Métodos: ${methodsResult.value}');
}

// Calcular carrinho
final calculateResult = await checkoutService.calculateCart(
  CalculateRequest(
    items: [/* seus itens */],
    paymentMethodId: 'card-id',
  ),
);

// Criar checkout
final checkoutResult = await checkoutService.createCheckout(
  CheckoutRequest(
    items: [/* seus itens */],
    paymentMethodId: 'card-id',
    // outros parâmetros...
  ),
);
```

### Checkout PIX

```dart
final pixResult = await checkoutService.createCheckout(
  CheckoutRequest(
    items: [/* seus itens */],
    paymentMethodId: 'pix',
  ),
);

if (pixResult.isSuccess) {
  final paymentId = pixResult.value.paymentId;
  // Exiba o QR code PIX para o usuário

  // Verifique o status do pagamento
  final statusResult = await checkoutService.getPixStatus(paymentId);
  print('Status PIX: ${statusResult.value}');
}
```

### Listagem de Vouchers

```dart
import 'package:tsdtech_client_sdk/core/services/intra-api/md-vouchers/vouchers_service.dart';
import 'package:tsdtech_client_sdk/models/common/pagination.model.dart';

final vouchersService = VouchersService.instance;

final result = await vouchersService.getVouchersClient(
  pagination: Pagination(page: 1, pageCount: 20),
  status: 'active',
);

result.fold(
  (paginatedList) {
    for (final voucher in paginatedList.items) {
      print('Voucher: ${voucher.id} - ${voucher.status}');
    }
  },
  (error) {
    print('Erro ao buscar vouchers: $error');
  },
);
```

## 🔧 Estrutura do SDK

```
lib/
├── core/
│   ├── constants/
│   │   └── constants.dart
│   ├── local_storage/
│   │   └── (auth tokens, preferences)
│   └── services/
│       ├── base.api.dart          # Cliente HTTP base (Dio)
│       └── intra-api/
│           ├── intra.api.dart     # Classe base para serviços
│           ├── md-vouchers/        # Serviço de vouchers
│           ├── md-checkout/       # Serviço de checkout/pagamentos
│           ├── md-authorizers/    # Auth, Memberships, ApiKeys
│           ├── md-orders/         # Serviço de pedidos
│           ├── md-clients/        # Serviço de clientes
│           ├── md-administrators/ # Serviço de administradores
│           ├── md-services/       # Serviços e tipos de serviço
│           └── md-providers/      # Requests de providers
└── models/
    ├── value_result.dart         # Result type
    ├── checkouts/                # Models de checkout
    ├── vouchers/                 # Models de voucher
    ├── auth/                     # Models de autenticação
    └── common/                    # Paginacao, etc.
```

## 📚 API Reference

Documentação completa disponível em: [https://tsdtech.github.io/tsdtech-client-sdk](https://tsdtech.github.io/tsdtech-client-sdk)

## ⚠️ Notas

- O SDK requer que `administratorId` esteja configurado em `AdministratorIdPrefs` antes de realizar login/signup
- Tokens de autenticação são automaticamente gerenciados pelo `BaseApi`
- O SDK converte exceções de rede em `ValueResult.failure()` com mensagens amigáveis

## 📄 License

Este projeto está sob a licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.