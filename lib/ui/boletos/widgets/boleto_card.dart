import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/model/boleto_isar_model.dart';
import 'boleto_detalhes_screen.dart';

class BoletoCard extends StatelessWidget {
  final BoletoIsarModel boleto;

  const BoletoCard({super.key, required this.boleto});

  @override
  Widget build(BuildContext context) {
    // Formatadores
    final formatador = NumberFormat.simpleCurrency(locale: 'pt_BR');
    final dataFormatada = DateFormat('dd/MM/yyyy').format(boleto.vencimento!);

    // Define a cor baseada no status (Verde = Pago, Laranja = Pendente)
    final corStatus = boleto.isPago ? Colors.green : Colors.orange[800];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(
        horizontal: 0,
        vertical: 6,
      ), // Margem ajustada para listas
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BoletoDetalhesScreen(boletoInicial: boleto),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // --- 1. MINIATURA DA FOTO OU ÍCONE ---
              Hero(
                tag: 'foto_${boleto.id}',
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: corStatus?.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    // Se tiver foto, mostra ela. Se não, mostra null.
                    image: boleto.fotoPath != null
                        ? DecorationImage(
                            image: FileImage(File(boleto.fotoPath!)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  // Se NÃO tiver foto, mostra o ícone no centro
                  child: boleto.fotoPath == null
                      ? Icon(
                          boleto.isPago
                              ? Icons.check_circle
                              : Icons.priority_high,
                          color: corStatus,
                          size: 30,
                        )
                      : null,
                ),
              ),

              const SizedBox(width: 16),

              // --- 2. INFORMAÇÕES DE TEXTO ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      boleto.fornecedor ?? "Fornecedor Sem Nome",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        // Risca o texto se estiver pago
                        decoration: boleto.isPago
                            ? TextDecoration.lineThrough
                            : null,
                        color: boleto.isPago ? Colors.grey : Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      boleto.isPago ? "PAGO" : "Vence em: $dataFormatada",
                      style: TextStyle(
                        color: boleto.isPago ? Colors.green : Colors.grey[600],
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // --- 3. VALOR ---
              Text(
                formatador.format(boleto.valor),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: boleto.isPago ? Colors.grey : Colors.blueGrey[900],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
