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
}
