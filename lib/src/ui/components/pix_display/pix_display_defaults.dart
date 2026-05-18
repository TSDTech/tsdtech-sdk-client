const List<String> defaultPixInstructions = [
  'Abra o app do seu banco e acesse a área Pix.',
  'Escolha a opção "Pagar com QR Code" ou "Pix Copia e Cola".',
  'Aponte a câmera para o QR Code ou cole o código copiado.',
  'Confira os dados e confirme o pagamento.',
  'O pagamento é confirmado em até 1 minuto.',
];

String formatPixDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return hours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
}
