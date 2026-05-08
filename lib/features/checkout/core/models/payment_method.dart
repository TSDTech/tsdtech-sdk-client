enum PaymentMethod {
  pix(0, 'Pix'),
  card(1, 'Cartão de crédito'),
  boleto(2, 'Boleto/GRU');

  final int value;
  final String label;
  const PaymentMethod(this.value, this.label);

  static PaymentMethod fromIndex(int i) =>
      PaymentMethod.values.firstWhere((e) => e.value == i, orElse: () => PaymentMethod.pix);
}
