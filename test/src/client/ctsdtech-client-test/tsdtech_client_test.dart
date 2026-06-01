import 'package:flutter_test/flutter_test.dart';
import 'package:tsdtech_client_sdk/src/client/tsdtech-client/tsdtech_client.dart';

void main() {
  // Teste 1: Garante que o app grita se alguém tentar usar o client sem inicializar no main
  test(
    'TsdtechClient.instance lança Exception se acessado antes do initialize',
    () {
      // Usamos uma função anônima () => para o expect conseguir capturar o erro
      expect(() => TsdtechClient.instance, throwsException);
    },
  );

  // Teste 2: O caminho feliz
  test(
    'TsdtechClient inicializa o GatewayService e o Orchestrator quando o gatewayBaseUrl é fornecido',
    () {
      // Inicializamos o Singleton
      TsdtechClient.initialize(
        baseUrl: 'http://api.local',
        gatewayBaseUrl: 'https://gateway.tsdtech.com',
        gatewayApiKey: 'secret_key',
      );

      // Pegamos a instância gerada
      final client = TsdtechClient.instance;

      // Verificamos se os serviços foram criados com sucesso
      expect(client.gateway, isNotNull);
      expect(client.orchestrator, isNotNull);
    },
  );
}
