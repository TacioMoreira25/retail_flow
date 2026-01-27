import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get_it/get_it.dart';
import '../../../data/model/boleto_isar_model.dart';
import '../../../data/services/isar_service.dart';
import '../../../data/services/notification_service.dart';

class BoletoCard extends StatelessWidget {
  final BoletoIsarModel boleto;

  const BoletoCard({super.key, required this.boleto});

  @override
  Widget build(BuildContext context) {
    final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final dataFormatada = DateFormat('dd/MM/yyyy').format(boleto.vencimento!);

    // Cores dinâmicas
    final corStatus = boleto.isPago ? Colors.green : Colors.orange[800];
    final iconeStatus = boleto.isPago
        ? Icons.check_circle
        : Icons.warning_amber_rounded;

    return Card(
      elevation: 2, // Sombra leve
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 6,
      ), // Espaçamento lateral
      child: ListTile(
        contentPadding: const EdgeInsets.all(12), // Mais espaço interno
        // --- AQUI ESTÁ A MÁGICA DO CLIQUE ---
        leading: InkWell(
          onTap: () => _alternarStatusPagamento(context),
          borderRadius: BorderRadius.circular(50),
          child: CircleAvatar(
            backgroundColor: corStatus?.withOpacity(0.2), // Fundo clarinho
            radius: 24,
            child: Icon(iconeStatus, color: corStatus, size: 28),
          ),
        ),

        title: Text(
          boleto.fornecedor ?? "Sem nome",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            // Risco no texto se estiver pago (efeito visual bacana)
            decoration: boleto.isPago ? TextDecoration.lineThrough : null,
            color: boleto.isPago ? Colors.grey : Colors.black87,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            boleto.isPago ? "PAGO" : "Vence em: $dataFormatada",
            style: TextStyle(
              color: boleto.isPago ? Colors.green : Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        trailing: Text(
          formatador.format(boleto.valor),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: boleto.isPago ? Colors.grey : Colors.blueGrey[900],
          ),
        ),
      ),
    );
  }

  void _alternarStatusPagamento(BuildContext context) async {
    final isarService = GetIt.I<IsarService>();
    final notificationService = GetIt.I<NotificationService>();

    // 1. Inverte o status
    boleto.isPago = !boleto.isPago;

    // 2. Salva no banco (Isar entende que se tem ID, é uma atualização)
    await isarService.saveBoleto(boleto);

    // 3. Gerencia o Alarme
    if (boleto.isPago) {
      await notificationService.cancelBoletoAlert(boleto.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Conta paga! Alarme cancelado."),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      // Se desmarcou, agenda de novo (se for futuro)
      if (boleto.vencimento!.isAfter(DateTime.now())) {
        await notificationService.scheduleBoletoAlert(
          boleto.id,
          boleto.fornecedor,
          boleto.vencimento!,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Boleto reativado. Alarme agendado."),
            duration: Duration(seconds: 1),
          ),
        );
      }
    }
  }
}
