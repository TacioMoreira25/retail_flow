import '../../domain/models/boleto_model.dart';
import '../model/boleto_isar_model.dart';
import 'package:get_it/get_it.dart';
import '../services/isar_service.dart';
import '../services/notification_service.dart';

class BoletoRepository {
  // Pegamos os serviços já prontos do GetIt
  final IsarService _isarService = GetIt.I<IsarService>();
  final NotificationService _notificationService =
      GetIt.I<NotificationService>();

  // Salva no banco E agenda a notificação
  Future<void> adicionarBoleto(Boleto boleto) async {
    // 1. Salva no Banco (Isso é o principal)
    final boletoIsar = BoletoIsarModel()
      ..fornecedor = boleto.fornecedor
      ..valor = boleto.valor
      ..vencimento = boleto.vencimento
      ..isPago = boleto.isPago
      ..fotoPath = boleto.imagePath;

    await _isarService.saveBoleto(boletoIsar);

    // 2. Tenta agendar o alarme, mas SE FALHAR, o app continua vivo
    try {
      await _notificationService.scheduleBoletoAlert(
        boletoIsar.id,
        boletoIsar.fornecedor,
        boletoIsar.vencimento,
      );
    } catch (e) {
      // Apenas loga o erro no console, mas o usuário vê o boleto salvo na tela!
      print("AVISO: Boleto salvo, mas o alarme falhou: $e");
    }
  }

  Future<List<BoletoIsarModel>> buscarTodos() async {
    return await _isarService.getAllBoletos();
  }

  Future<void> atualizarBoleto(int id, Boleto boletoAtualizado) async {
    // 1. Busca o antigo no banco
    final isar = await _isarService.db;
    final boletoAntigo = await isar.boletoIsarModels.get(id);

    if (boletoAntigo != null) {
      // 2. Atualiza os campos
      boletoAntigo
        ..fornecedor = boletoAtualizado.fornecedor
        ..valor = boletoAtualizado.valor
        ..vencimento = boletoAtualizado.vencimento
        ..fotoPath = boletoAtualizado.imagePath;
      // Nota: Não mudamos o isPago na edição, só no botão de pagar

      // 3. Salva no banco
      await _isarService.updateBoleto(boletoAntigo);

      // 4. Reagenda o alarme (se não estiver pago)
      if (!boletoAntigo.isPago) {
        await _notificationService.cancelBoletoAlert(id); // Cancela o velho
        await _notificationService.scheduleBoletoAlert(
          id,
          boletoAntigo.fornecedor!,
          boletoAntigo.vencimento!,
        ); // Agenda o novo
      }
    }
  }
}
