class Boleto {
  final int? id;
  final String fornecedor;
  final double valor;
  final DateTime vencimento;
  final bool isPago;
  final String? imagePath;

  Boleto({
    this.id,
    required this.fornecedor,
    required this.valor,
    required this.vencimento,
    this.isPago = false,
    this.imagePath,
  });
}
