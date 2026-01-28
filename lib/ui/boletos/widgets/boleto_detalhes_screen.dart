import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import '../../../data/model/boleto_isar_model.dart';
import '../../../data/services/isar_service.dart';
import '../../../data/services/notification_service.dart';
import '../../dashboard/widgets/foto_full_screen.dart';
import 'boletos_screen.dart';

class BoletoDetalhesScreen extends StatefulWidget {
  final BoletoIsarModel boletoInicial;

  const BoletoDetalhesScreen({super.key, required this.boletoInicial});

  @override
  State<BoletoDetalhesScreen> createState() => _BoletoDetalhesScreenState();
}

class _BoletoDetalhesScreenState extends State<BoletoDetalhesScreen> {
  late BoletoIsarModel _boleto;

  @override
  void initState() {
    super.initState();
    _boleto = widget.boletoInicial;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatador = NumberFormat.simpleCurrency(locale: 'pt_BR');
    final dataFormatada = DateFormat('dd/MM/yyyy').format(_boleto.vencimento!);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes da Conta"),
        actions: [
          IconButton(
            onPressed: _navegarParaEdicao,
            icon: const Icon(Icons.edit),
            tooltip: "Editar",
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- ÁREA DA FOTO (CLICÁVEL) ---
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: _boleto.fotoPath != null
                  ? _abrirFotoFullScreen
                  : null, // Clique aqui
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _boleto.fotoPath != null
                      ? Image.file(
                          File(_boleto.fotoPath!),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildPlaceholderFoto(),
                        )
                      : _buildPlaceholderFoto(),

                  // Ícone de lupa para indicar que pode clicar
                  if (_boleto.fotoPath != null)
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(Icons.zoom_in, color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // --- INFORMAÇÕES ---
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _boleto.isPago
                            ? Icons.check_circle
                            : Icons.warning_amber_rounded,
                        color: _boleto.isPago
                            ? Colors.green
                            : Colors.orange[800],
                        size: 28,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _boleto.isPago ? "PAGO" : "PENDENTE",
                        style: TextStyle(
                          color: _boleto.isPago
                              ? Colors.green
                              : Colors.orange[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _boleto.fornecedor ?? "Sem nome",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatador.format(_boleto.valor),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Vence em: $dataFormatada",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // --- BOTÃO PAGAR ---
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton.icon(
                      onPressed: _alternarPagamento,
                      style: FilledButton.styleFrom(
                        backgroundColor: _boleto.isPago
                            ? Colors.grey[400]
                            : Colors.green[700],
                      ),
                      icon: Icon(_boleto.isPago ? Icons.undo : Icons.check),
                      label: Text(
                        _boleto.isPago
                            ? "DESFAZER PAGAMENTO"
                            : "MARCAR COMO PAGO",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderFoto() {
    return Container(
      color: Colors.grey[100],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: 60,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 8),
          Text(
            "Sem foto do comprovante",
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  void _abrirFotoFullScreen() {
    if (_boleto.fotoPath != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FotoFullScreen(imagePath: _boleto.fotoPath!),
        ),
      );
    }
  }

  void _navegarParaEdicao() async {
    // Abre a tela de form passando o boleto atual
    final atualizou = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BoletoFormScreen(boletoParaEditar: _boleto),
      ),
    );

    // Se salvou (retornou true), recarrega os dados do banco
    if (atualizou == true) {
      final isarService = GetIt.I<IsarService>();
      final isar = await isarService.db;
      final boletoAtualizado = await isar.boletoIsarModels.get(_boleto.id);

      if (boletoAtualizado != null) {
        setState(() {
          _boleto = boletoAtualizado;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Dados atualizados!")));
      }
    }
  }

  void _alternarPagamento() async {
    final isarService = GetIt.I<IsarService>();
    final notificationService = GetIt.I<NotificationService>();

    setState(
      () => _boleto.isPago = !_boleto.isPago,
    ); // Atualiza visualmente na hora

    await isarService.updateBoleto(_boleto); // Salva no banco

    // Lógica de alarme
    if (_boleto.isPago) {
      await notificationService.cancelBoletoAlert(_boleto.id);
    } else if (_boleto.vencimento!.isAfter(DateTime.now())) {
      await notificationService.scheduleBoletoAlert(
        _boleto.id,
        _boleto.fornecedor!,
        _boleto.vencimento!,
      );
    }
  }
}
