# TSDTech Client SDK

[![Pub Version](https://img.shields.io/pub/v/tsdtech_client_sdk)](https://pub.dev/packages/tsdtech_client_sdk)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Dart CI](https://github.com/tsdtech/tsdtech-client-sdk/actions/workflows/dart.yml/badge.svg)](https://github.com/tsdtech/tsdtech-client-sdk/actions/workflows/dart.yml)

SDK Dart puro para integração com a plataforma TSDTech de pagamentos.

## ✨ Features

- **Checkout**: Pagamentos via cartão (com criptografia), PIX e boleto
- **Autenticação**: Login e cadastro de usuários clientes
- **Vouchers**: Listagem e gerenciamento de vouchers
- **Serviços**: Listagem de serviços e formulários
- **Pedidos**: Gestão de pedidos

## 📦 Instalação

Adicione ao seu `pubspec.yaml`:

```yaml
dependencies:
  tsdtech_client_sdk: ^0.1.0
```

## 🚀 Usage

### Configuração Inicial

```dart
import 'package:tsdtech_client_sdk/tsdtech_sdk_client.dart';

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
  administratorId: 'admin-123',
);

result.fold(
  (loginResponse) {
    print('Login bem-sucedido: ${loginResponse.token}');
    // Configure o token para requisições autenticadas
    BaseApi.setToken(loginResponse.token);
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
  ),
  administratorId: 'admin-123',
);
```

### Checkout com PIX

```dart
import 'package:tsdtech_client_sdk/tsdtech_sdk_client.dart';

final checkoutService = CheckoutsService.instance;

// Criar checkout PIX
final result = await checkoutService.createCheckout(
  CheckoutRequest(
    items: [/* seus itens */],
    paymentMethodId: 'pix',
  ),
);

if (result.isSuccess) {
  final pixData = result.value.pix;
  // Exiba o QR code PIX para o usuário
  print('PIX QR Code: ${pixData?.qrCode}');
  print('PIX Copia e Cola: ${pixData?.qrCodeText}');

  // Verifique o status do pagamento
  final statusResult = await checkoutService.getPixStatus(result.value.paymentId);
  print('Status PIX: ${statusResult.value}');
}
```

### Checkout com Cartão (2-step)

```dart
// 1. Criar checkout para obter depositRequestId
final checkoutResult = await checkoutService.createCheckout(
  CheckoutRequest(
    items: [/* seus itens */],
    paymentMethodId: 'card',
  ),
);

if (checkoutResult.isSuccess) {
  final depositRequestId = checkoutResult.value.depositRequestId;
  
  // 2. Usar GatewayClient para criptografar e enviar dados do cartão
  // (Implementação depende de GatewayClient - ver task OPA2-470)
}
```

### Checkout com Boleto

```dart
final result = await checkoutService.createCheckout(
  CheckoutRequest(
    items: [/* seus itens */],
    paymentMethodId: 'bill',
  ),
);

if (result.isSuccess) {
  final billData = result.value.bill;
  print('Linha digitável: ${billData?.digitableLine}');
  print('URL do boleto: ${billData?.url}');
}
```

### Calcular Carrinho

```dart
final calculateResult = await checkoutService.calculateCart(
  CalculateRequest(
    items: [/* seus itens */],
    paymentMethodId: 'card-id',
  ),
);

if (calculateResult.isSuccess) {
  print('Total: ${calculateResult.value.total}');
  print('Subtotal: ${calculateResult.value.subtotal}');
}
```

### Listar Meios de Pagamento

```dart
final methodsResult = await checkoutService.getPaymentMethods();
if (methodsResult.isSuccess) {
  for (final method in methodsResult.value) {
    print('${method.id}: ${method.name}');
  }
}
```

## 🔧 Estrutura do SDK

```
lib/
├── core/
│   ├── constants/
│   │   └── constants.dart          # Configurações e URLs
│   └── services/
│       ├── base.api.dart           # Cliente HTTP base (Dio)
│       └── intra-api/
│           ├── intra.api.dart      # Classe base para serviços
│           ├── md-checkout/        # Serviço de checkout/pagamentos
│           ├── md-authorizers/     # Auth, Memberships, ApiKeys
│           ├── md-vouchers/        # Serviço de vouchers
│           ├── md-services/        # Serviços e tipos de serviço
│           ├── md-orders/          # Serviço de pedidos
│           ├── md-clients/         # Serviço de clientes
│           └── ...                 # Outros módulos
├── models/
│   ├── value_result.dart          # Result type
│   ├── checkouts/                 # Models de checkout
│   ├── vouchers/                  # Models de voucher
│   ├── auth/                      # Models de autenticação
│   └── common/                    # Paginação, etc.
└── tsdtech_sdk_client.dart        # Barrel file principal
```

## 📚 API Reference

### Services Principais

| Service | Descrição | Métodos Principais |
|---------|-----------|-------------------|
| `CheckoutsService` | Pagamentos | `createCheckout()`, `calculateCart()`, `getPaymentMethods()`, `getPixStatus()` |
| `AuthServiceClientUser` | Autenticação | `login()`, `signup()` |
| `VouchersService` | Vouchers | `getVouchersClient()`, `getVoucherById()` |
| `ServicesService` | Serviços | `getPublicServices()`, `getServiceFormModel()`, `submitServiceForm()` |
| `OrdersService` | Pedidos | `getOrders()`, `getOrderById()` |

### Token Management

```dart
// Definir token para requisições autenticadas
BaseApi.setToken('seu-jwt-token');

// Remover token
BaseApi.resetToken();

// Habilitar modo debug (logs)
BaseApi.setDebugMode(true);
```

### ValueResult

Todas as operações do SDK retornam `ValueResult<T>`:

```dart
final result = await service.someOperation();

````watch command
dart run build_runner watch --delete-conflicting-outputs

// Usando fold
result.fold(
  (value) => print('Sucesso: $value'),
  (error) => print('Erro: $error'),
);

// Usando isSuccess/isFailure
if (result.isSuccess) {
  print(result.value);
} else {
  print(result.error);
}
```

## ⚠️ Notas Importantes

- **SDK Dart Puro**: Este SDK não depende do Flutter e pode ser usado em qualquer projeto Dart
- **Gerenciamento de Token**: O SDK não armazena tokens automaticamente. Use `BaseApi.setToken()` após login
- **Debug Mode**: Use `BaseApi.setDebugMode(true)` para habilitar logs de debug

## 📄 License

Este projeto está sob a licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.
