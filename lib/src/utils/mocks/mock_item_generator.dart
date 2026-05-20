import 'dart:math';
import 'package:tsdtech_client_sdk/models/services/service.model.dart';
import 'package:tsdtech_client_sdk/tsdtech_sdk_client.dart';

class MockItemGenerator {
  static final _random = Random();

  static final _serviceNames = [
    'Corte premium',
    'Barba express',
    'Sobrancelha',
    'Acabamento (Pézinho)',
    'Hidratação VIP',
    'Pigmentação de barba',
    'Corte infantil',
    'Luzes no cabelo'
  ];

  static final _descriptions = [
    'Atendimento com finalização e consultoria rápida.',
    'Modelagem simples com toalha quente.',
    'Serviço completo com os melhores produtos do mercado.',
    'Ajuste rápido para manter o visual em dia.',
    'Cuidado premium para ocasiões especiais.',
  ];

  /// Gera uma lista de [CartItem] aleatórios
  static List<CartItem> generateRandomItems({
    required int count, 
    required String administratorId,
  }) {
    return List.generate(count, (index) {
      final name = _serviceNames[_random.nextInt(_serviceNames.length)];
      final description = _descriptions[_random.nextInt(_descriptions.length)];
      
      // Gera um preço aleatório entre 20.0 e 150.0
      final price = 20.0 + _random.nextInt(130) + _random.nextDouble();
      
      // Gera uma quantidade aleatória entre 1 e 3
      final quantity = _random.nextInt(3) + 1;

      return CartItem(
        service: Service(
          id: 'svc_mock_${DateTime.now().millisecondsSinceEpoch}_$index',
          name: name,
          description: description,
          administratorId: administratorId,
          // Arredonda o preço para 2 casas decimais
          price: double.parse(price.toStringAsFixed(2)),
        ),
        quantity: quantity,
      );
    });
  }
}