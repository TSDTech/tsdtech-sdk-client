# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.12] - 2026-06-22

- Adicionado suporte ao Environment para produção com a nova url

## [0.2.11] - 2026-06-12
- Fix no Constants para poder utilizar o SDK em prod

## [0.2.10] - 2026-06-10
- Fix no Constants que impedia funcionar em dev 

## [0.2.9] - 2026-06-10
- Implementação da função de exibir taxas no checkout
- Bugfixes
- Correção no Changelog

## [0.2.8] - 2026-06-03
- Refactor do constants para stage

## [0.2.7] - 2026-06-01
- Resolvido falhas nos arquivos de testes
- Resolvido erros de formatação

## [0.2.6] - 2026-06-01
- Resolvido algumas mensagens de avisos do codigo
- Removido o uso de withOpacity e alterado para withValues 

## [0.2.5] - 2026-06-01
- Implementação do estilo padrão SPA no componente `CheckoutWidget`, além de todos seus componentes filhos
- Resolvido vários erros menores de compilação e formatação nos arquivos de testes

## [0.2.4] - 2026-06-01
- Corrigido bug na url dinâmica

## [0.2.3] - 2026-06-01
- Alterado url dinâmica para todos os ambientes

## [0.2.2] - 2026-05-29

- Alterado `TsdtechClient` para o mesmo inicializar configurações da UI sem necessidade do usuário
- Alterado comentários importantes para geração dos docs

## [0.2.1] - 2026-05-27

- Alterado `CheckoutWidget` para buscar os items do pedido
- Alterado parâmetro `gatewayBaseUrl` para opcional ao inicializar o `TsdtechClient` 

## [0.2.0] - 2026-05-27

- Implementação do `CheckoutOrchestrator` para gestão de fluxo de pagamentos.
- Rework completo do `CheckoutsService` para suporte a PIX dinâmico e WebSocket.
- Inclusão do módulo de criptografia (`CardEncryptor`) usando RSA/ECB/OAEP (Padrão PCI).
- Implementação de `GatewayClient` e `GatewayService`.
- Adição de novos DTOs públicos (`PublicKeyResponse`, `CardPaymentRequest`, `PaymentStatusResponse`).

## [0.1.0] - 2026-05-11

- Base inicial do SDK para integração do cliente TsdTech
- BaseApi: Cliente HTTP estático usando Dio para realizar requisições de API
- IntraApi: Classe base para comunicação de API entre microsserviços
- ValueResult<T>: Tipo de retorno para lidar com respostas de sucesso ou falha
- VouchersService: Gestão de vouchers do cliente (listar, buscar)
- CheckoutsService: Fluxo de checkout de pagamento (calcular, criar, status do PIX)
- AuthServiceClientUser: Autenticação de usuário cliente (login, cadastro)
- OrdersService: Gestão de pedidos do cliente
- ClientsService: Gestão de perfil do cliente
- AdministratorsService: Operações de administrador
- MembershipsService: Gestão de assinaturas/vínculos (memberships)
- ApiKeysService: Gestão de chaves de API (API keys)
- ServicesService: Gestão do catálogo de serviços
- ServiceTypesService: Definições de tipos de serviço
- ProviderRequestsService: Gestão de solicitações de provedores
- Autenticação baseada em tokens (Bearer tokens)
- Tratamento de erros com mensagens amigáveis para o usuário
- Suporte a paginação para operações de listagem
- Suporte para métodos de pagamento via cartão e PIX