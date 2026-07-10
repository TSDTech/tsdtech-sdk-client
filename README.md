# TSDTech Client SDK

[![Pub Version](https://img.shields.io/pub/v/tsdtech_client_sdk)](https://pub.dev/packages/tsdtech_client_sdk)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Dart CI](https://github.com/tsdtech/tsdtech-client-sdk/actions/workflows/dart.yml/badge.svg)](https://github.com/tsdtech/tsdtech-client-sdk/actions/workflows/dart.yml)

SDK oficial da TSDTech para integração de pagamentos, serviços e UI nativa em aplicativos Flutter e Dart.

## ✨ Features

- **UI Drop-in Pronta**: `CheckoutWidget` e telas de fluxo completo (`TsdtechUi`) nativos para integrar pagamentos em poucas linhas de código.
- **Orquestração Inteligente**: `CheckoutOrchestrator` que gerencia o fluxo completo (Pedido -> Gateway -> PIX Polling com WebSocket).
- **Segurança Nativa (PCI)**: Criptografia de cartão `RSA/ECB/OAEP` nativa via `CardEncryptor`.
- **Checkout Headless**: APIs diretas para pagamentos via cartão, PIX e boleto se preferir criar sua própria UI.
- **Ecossistema Completo**: Login e cadastro, catálogo de serviços, listagem de vouchers, memberships e gestão de pedidos.

## 📦 Instalação

Adicione ao seu `pubspec.yaml`:

```yaml
dependencies:
  tsdtech_client_sdk: ^.2.1
```

ou

```
flutter pub add tsdtech_client_sdk
```

## 🚀 Inicialização e Configuração

A inicialização foi simplificada. No `main.dart` do seu app, chame a inicialização global antes de rodar a aplicação. O SDK já configura a UI e o motor de pagamentos "por debaixo dos panos".

```dart
import 'package:flutter/material.dart';
import 'package:tsdtech_client_sdk/tsdtech_sdk_client.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa o SDK completo (Motor + UI Config)
  TsdtechClient.initialize(
    baseUrl: '[https://api.seudominio.com](https://api.seudominio.com)',
    gatewayBaseUrl: '[https://gateway.seudominio.com](https://gateway.seudominio.com)',
    gatewayApiKey: 'sua_api_key_publica',
  );

  runApp(const MyApp());
}
```

## 💳 Exemplo de Uso (UI Nativa)

Você pode usar as telas completas e prontas do SDK através da classe `TsdtechUi`.

### Abrindo a Tela de Checkout (Navegação Completa)

```dart
import 'package:tsdtech_client_sdk/tsdtech_sdk_ui.dart';

TsdtechUi.pushCheckoutScreen(
  context: context,
  items: meusCartItems,
  administratorId: 'admin_123',
  onSuccess: () => print('Pagamento aprovado!'),
  onCancel: () => print('Fluxo cancelado pelo usuário.'),
);
```

### Usando o Checkout em BottomSheet ou Dialog

```dart
// Como Bottom Sheet
TsdtechUi.showCheckoutSheet(
  context: context,
  items: meusCartItems,
  administratorId: 'admin_123',
  onSuccess: () {},
  onCancel: () {},
);

// Como Dialog
TsdtechUi.showCheckoutDialog(
  context: context,
  items: meusCartItems,
  administratorId: 'admin_123',
  onSuccess: () {},
  onCancel: () {},
);
```

### Componente Embutido (Drop-in)

Se quiser colocar o formulário de checkout dentro de uma tela já existente sua:

```dart
CheckoutWidget(
  store: CheckoutStore(), // Store nativa do SDK
  items: meusCartItems,
  administratorId: 'admin_123',
  onSuccess: (PaymentResult result) {
    print('Sucesso: ${result.transactionId}');
  },
  onError: (String error) {
    print('Erro: $error');
  },
);
```

## 💻 Exemplo de Uso (Headless / Via Código)

Se você preferir construir 100% da sua própria interface, o `CheckoutOrchestrator` faz o trabalho de segurança e comunicação com o Gateway:

### Checkout com PIX

```dart
final orchestrator = TsdtechClient.instance.orchestrator!;

// O orchestrator cuida da conversão do depósito para PIX
final result = await orchestrator.payWithPix('id_do_deposito_gerado');

if (result.isSuccess) {
  final pixData = result.value; // DepositPixResponse
  print('PIX QR Code: ${pixData.textQrCode}');
}
```

### Checkout com Cartão de Crédito

O Orquestrador busca a chave pública, criptografa os dados e envia para o gateway de forma transparente:

```dart
final orchestrator = TsdtechClient.instance.orchestrator!;

final cardData = CardPaymentData(
  cardHolderName: 'JOAO DA SILVA',
  cardNumber: '1234567890123456',
  cardExpiryDate: '202812',
  securityCode: '123',
);

// Envia a requisição do carrinho junto com os dados sensíveis do cartão
final result = await orchestrator.payWithCard(checkoutRequest, cardData);

if (result.isSuccess) {
  print('Pagamento processado! Status: ${result.value.status}');
}
```

### Pagamento com Cartão via Gateway (deposit request existente)

Se você já possui um `depositRequestId` (deposit request criado previamente), o
`TsdtechClient` expõe um método de conveniência que orquestra o fluxo completo
com o Gateway: busca a chave pública, criptografa os dados do cartão e envia o
pagamento. Requer inicialização com `gatewayBaseUrl`:

```dart
// No main.dart
TsdtechClient.initialize(
  baseUrl: 'https://api.seudominio.com',
  gatewayBaseUrl: 'https://gateway.seudominio.com',
  gatewayApiKey: 'sua_api_key_publica',
);

// No fluxo de pagamento
final cardData = CardPaymentData(
  cardHolderName: 'JOAO DA SILVA',
  cardNumber: '1234567890123456',
  cardExpiryDate: '202812',
  securityCode: '123',
);

final result = await TsdtechClient.instance.payWithCard(
  depositRequestId: 'id_do_deposito_gerado',
  cardData: cardData,
  installmentNumber: 3, // opcional
);

if (result.isSuccess) {
  print('Pagamento processado! Status: ${result.value?.status}');
} else {
  print('Erro: ${result.error}');
}

// Consulta posterior do status do pagamento
final status = await TsdtechClient.instance.getCardPaymentStatus(
  'id_do_deposito_gerado',
);
print('Status atual: ${status.value?.status}');
```

### Autenticação de Usuários Cliente

```dart
final authService = AuthServiceClientUser.instance;

final result = await authService.login(
  email: 'usuario@exemplo.com',
  password: 'sua-senha',
  administratorId: 'admin-123',
);

result.fold(
  (loginResponse) {
    // Configure o token global para habilitar requisições privadas na API base
    BaseApi.setToken(loginResponse.token);
  },
  (error) => print('Erro no login: $error'),
);
```

## 🔧 Estrutura do SDK

```text
lib/
├── core/
│   ├── constants/            # Configurações e URLs Base
│   └── services/             # Cliente HTTP base (Dio) e IntraApi modules
├── src/
│   ├── client/               # Instâncias do TsdtechClient e GatewayClient
│   ├── crypto/               # Módulo de Criptografia RSA (CardEncryptor)
│   ├── services/             # CheckoutOrchestrator
│   └── ui/                   # Componentes Visuais, MobX Stores, e Theme Configs
├── models/                   # DTOs padronizados (Vouchers, Services, Orders)
├── tsdtech_sdk_client.dart   # Barrel file principal (Lógica)
└── tsdtech_sdk_ui.dart       # Barrel file de Interface (Widgets)
```

## 📚 API Reference

| Módulo/Serviço | Descrição | Principais Métodos |
|---------|-----------|-------------------|
| `TsdtechClient` | Fluxo gateway orquestrado | `payWithCard()`, `getCardPaymentStatus()` |
| `CheckoutOrchestrator` | Pagamentos seguros | `payWithCard()`, `payWithPix()`, `payWithBill()` |
| `CheckoutsService` | Gestão de depósitos | `createCheckout()`, `calculateCart()`, `getPixStatus()` |
| `AuthServiceClientUser`| Autenticação | `login()`, `signup()` |
| `VouchersService` | Gestão de Vouchers | `getVouchersClient()` |
| `ServicesService` | Catálogo de Serviços | `getPublicServices()`, `submitServiceForm()` |
| `OrdersService` | Histórico de Pedidos | `getAllOrders()` |
| `ProviderRequestsService` | Gestão de provedores | `getProviderRequestsClient()` |

### Gerenciamento de Token e Erros

```dart
// Definir token JWT após o login
BaseApi.setToken('seu-jwt-token');

// Remover token (Logout)
BaseApi.resetToken();

// Habilitar modo debug (logs do Dio)
BaseApi.setDebugMode(true);
```

### Tratamento de Retornos (ValueResult)

O SDK não usa `throw` para regras de negócio. Todas as requisições devolvem um `ValueResult<T>` seguro e tipado:

```dart
final result = await SubaccountService.instance.patchClient(name: 'Novo Nome');

// Usando fold funcional
result.fold(
  (client) => print('Sucesso: ${client.firstName}'),
  (error) => print('Erro da API: $error'), // Já extrai a mensagem limpa do JSON
);

// Ou checagem imperativa
if (result.isSuccess) {
  print(result.value);
} else {
  print(result.error);
}
```

## ⚠️ Notas Importantes

- **Módulos Híbridos**: As services e a API (`core/` e `models/`) são isoladas e podem ser usadas em Dart Puro. A pasta `src/ui/` contém os componentes dependentes do Flutter.
- **Gerenciamento de Sessão**: O SDK não persiste tokens localmente (SharedPreferences) de forma automática para o `BaseApi`. É responsabilidade do aplicativo chamador gerenciar a sessão e invocar `BaseApi.setToken()`.
- **Criptografia**: O envio de pagamentos por cartão nunca trafega dados sensíveis abertos. O `CardEncryptor` utiliza a chave pública do Gateway para proteger a transação.

## 📄 License

Este projeto está sob a licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.