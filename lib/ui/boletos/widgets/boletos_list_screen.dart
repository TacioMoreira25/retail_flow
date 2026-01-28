import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import '../../../data/model/boleto_isar_model.dart';
import '../../../data/services/isar_service.dart';
import 'boleto_card.dart';

class BoletosListScreen extends StatefulWidget {
  const BoletosListScreen({super.key});

  @override
  State<BoletosListScreen> createState() => _BoletosListScreenState();
}

class _BoletosListScreenState extends State<BoletosListScreen> {
  final _isarService = GetIt.I<IsarService>();

  // 0 = Todos, 1 = Pendentes, 2 = Pagos
  int _filtroIndex = 1; // Começa mostrando "Pendentes" que é o mais importante

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Minhas Contas"), centerTitle: true),
      body: Column(
        children: [
          // --- BARRA DE FILTROS ---
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: SegmentedButton<int>(
                segments: const [
                  ButtonSegment(
                    value: 0,
                    label: Text("Todos"),
                    icon: Icon(Icons.list),
                  ),
                  ButtonSegment(
                    value: 1,
                    label: Text("A Pagar"),
                    icon: Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.orange,
                    ),
                  ),
                  ButtonSegment(
                    value: 2,
                    label: Text("Pagos"),
                    icon: Icon(Icons.check_circle_outline, color: Colors.green),
                  ),
                ],
                selected: {_filtroIndex},
                onSelectionChanged: (Set<int> newSelection) {
                  setState(() {
                    _filtroIndex = newSelection.first;
                  });
                },
                style: ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
          ),

          // --- LISTA DINÂMICA ---
          Expanded(
            child: StreamBuilder<List<BoletoIsarModel>>(
              // Converte o índice (0, 1, 2) para o booleano que o Isar entende (null, false, true)
              stream: _isarService.watchBoletosFiltrados(_getFiltroBooleano()),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final boletos = snapshot.data!;

                if (boletos.isEmpty) {
                  return _buildEmptyState();
                }

                // Soma total da lista atual (ex: total só dos pendentes)
                final totalLista = boletos.fold(0.0, (sum, b) => sum + b.valor);

                return Column(
                  children: [
                    // Resuminho da lista atual
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Total desta lista: ",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          Text(
                            NumberFormat.simpleCurrency(
                              locale: 'pt_BR',
                            ).format(totalLista),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

                    // A Lista em si
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.only(
                          bottom: 80,
                          left: 16,
                          right: 16,
                        ),
                        itemCount: boletos.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final boleto = boletos[index];

                          // Swipe to Delete (Arrastar para apagar)
                          return Dismissible(
                            key: Key(boleto.id.toString()),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: Colors.red[400],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.delete_outline,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (direction) {
                              _isarService.deleteBoleto(boleto.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "${boleto.fornecedor} removido",
                                  ),
                                ),
                              );
                            },
                            child: BoletoCard(boleto: boleto),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Lógica auxiliar para converter o botão selecionado em filtro de banco
  bool? _getFiltroBooleano() {
    switch (_filtroIndex) {
      case 1:
        return false; // A Pagar
      case 2:
        return true; // Pagos
      default:
        return null; // Todos
    }
  }

  Widget _buildEmptyState() {
    String mensagem = "Nenhum boleto encontrado.";
    IconData icone = Icons.search_off;

    if (_filtroIndex == 1) {
      mensagem = "Tudo pago! Você está em dia. 🎉";
      icone = Icons.thumb_up_alt_outlined;
    } else if (_filtroIndex == 2) {
      mensagem = "Nenhum pagamento registrado ainda.";
      icone = Icons.receipt_long;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icone, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            mensagem,
            style: TextStyle(color: Colors.grey[500], fontSize: 16),
          ),
        ],
      ),
    );
  }
}
