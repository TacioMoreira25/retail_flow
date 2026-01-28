import 'package:flutter/material.dart';
import '../../../data/repositories/boleto_repository.dart';
import '../../../domain/models/boleto_model.dart';

class BoletoViewModel extends ChangeNotifier {
  final BoletoRepository _repository = BoletoRepository();

  bool isLoading = false;
  String? erro;

  Future<void> salvarBoleto({
    int? id,
    required String fornecedor,
    required double valor,
    required DateTime vencimento,
    String? fotoPath,
    int parcelas = 1, // <--- NOVO PARÂMETRO (Padrão é 1x)
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      // MODO EDIÇÃO (Só edita um boleto específico, não gera parcelas novas)
      if (id != null) {
        final boletoModel = Boleto(
          fornecedor: fornecedor,
          valor: valor,
          vencimento: vencimento,
          imagePath: fotoPath,
        );
        await _repository.atualizarBoleto(id, boletoModel);
      } else {
        for (int i = 0; i < parcelas; i++) {
          final dataParcela = DateTime(
            vencimento.year,
            vencimento.month + i,
            vencimento.day,
          );

          String nomeFornecedor = fornecedor;
          if (parcelas > 1) {
            nomeFornecedor = "$fornecedor (${i + 1}/$parcelas)";
          }

          final novoBoleto = Boleto(
            fornecedor: nomeFornecedor,
            valor: valor, // O valor aqui é o valor DA PARCELA
            vencimento: dataParcela,
            imagePath: fotoPath,
          );

          await _repository.adicionarBoleto(novoBoleto);
        }
      }

      erro = null;
    } catch (e, s) {
      print("ERRO: $e $s");
      erro = "Erro ao salvar: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
