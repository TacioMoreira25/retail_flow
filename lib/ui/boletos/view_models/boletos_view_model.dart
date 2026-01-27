import 'package:flutter/material.dart';
import '../../../data/repositories/boleto_repository.dart';
import '../../../domain/models/boleto_model.dart';

class BoletoViewModel extends ChangeNotifier {
  final BoletoRepository _repository = BoletoRepository();

  bool isLoading = false;
  String? erro;

  Future<void> salvarBoleto({
    required String fornecedor,
    required double valor,
    required DateTime vencimento,
  }) async {
    try {
      isLoading = true;
      notifyListeners(); // Avisa a tela para mostrar "Carregando..."

      final novoBoleto = Boleto(
        fornecedor: fornecedor,
        valor: valor,
        vencimento: vencimento,
      );

      await _repository.adicionarBoleto(novoBoleto);

      erro = null;
    } catch (e) {
      erro = "Erro ao salvar: $e";
    } finally {
      isLoading = false;
      notifyListeners(); // Avisa a tela que terminou
    }
  }
}
