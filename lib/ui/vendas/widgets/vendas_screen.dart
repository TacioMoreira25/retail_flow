import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import '../../../data/model/venda_isar_model.dart';
import '../../../data/services/isar_service.dart';
import 'package:flutter/services.dart';
import 'package:brasil_fields/brasil_fields.dart';

class VendasScreen extends StatefulWidget {
  const VendasScreen({super.key});

  @override
  State<VendasScreen> createState() => _VendasScreenState();
}

class _VendasScreenState extends State<VendasScreen> {
  final _valorController = TextEditingController();
  final _descController = TextEditingController();
  final _isarService = GetIt.I<IsarService>();

  // 0 = Dia, 1 = Mês, 2 = Ano
  int _filtroIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Calcula as datas com base no filtro selecionado
    final agora = DateTime.now();
    DateTime inicio, fim;

    if (_filtroIndex == 0) {
      // DIA
      inicio = DateTime(agora.year, agora.month, agora.day);
      fim = DateTime(agora.year, agora.month, agora.day, 23, 59, 59);
    } else if (_filtroIndex == 1) {
      // MÊS
      inicio = DateTime(agora.year, agora.month, 1);
      fim = DateTime(
        agora.year,
        agora.month + 1,
        0,
        23,
        59,
        59,
      ); // Dia 0 do prox mês = ultimo desse
    } else {
      // ANO
      inicio = DateTime(agora.year, 1, 1);
      fim = DateTime(agora.year, 12, 31, 23, 59, 59);
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Caixa (Entradas)")),
      body: Column(
        children: [
          // --- 1. ÁREA DE CADASTRO RÁPIDO ---
          ExpansionTile(
            title: const Text(
              "Nova Venda Rápida",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            initiallyExpanded: false,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  children: [
                    TextField(
                      controller: _valorController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CentavosInputFormatter(moeda: true),
                      ],
                      decoration: const InputDecoration(
                        labelText: "Valor",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _descController,
                      decoration: const InputDecoration(
                        labelText: "Descrição (Opcional)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _registrarVenda,
                        icon: const Icon(Icons.attach_money),
                        label: const Text("REGISTRAR"),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.green[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Divider(height: 1),

          // --- 2. FILTROS (DIA / MÊS / ANO) ---
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text("Hoje")),
                ButtonSegment(value: 1, label: Text("Este Mês")),
                ButtonSegment(value: 2, label: Text("Este Ano")),
              ],
              selected: {_filtroIndex},
              onSelectionChanged: (Set<int> newSelection) {
                setState(() => _filtroIndex = newSelection.first);
              },
              showSelectedIcon: false,
            ),
          ),

          // --- 3. LISTA E TOTAL ---
          Expanded(
            child: StreamBuilder<List<VendaIsarModel>>(
              stream: _isarService.listenToVendasPorPeriodo(inicio, fim),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("Nenhuma venda neste período."),
                  );
                }

                final vendas = snapshot.data!;
                final totalPeriodo = vendas.fold(
                  0.0,
                  (sum, item) => sum + item.valor,
                );

                return Column(
                  children: [
                    // Cabeçalho de Total
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      color: Colors.green[50],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _getTextoTotal(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            NumberFormat.simpleCurrency(
                              locale: 'pt_BR',
                            ).format(totalPeriodo),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Lista
                    Expanded(
                      child: ListView.separated(
                        itemCount: vendas.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final venda = vendas[index];
                          return ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.green,
                              radius: 15,
                              child: Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              venda.descricao?.isEmpty == true
                                  ? "Venda Diversa"
                                  : venda.descricao!,
                            ),
                            subtitle: Text(
                              DateFormat('dd/MM - HH:mm').format(venda.data),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  NumberFormat.simpleCurrency(
                                    locale: 'pt_BR',
                                  ).format(venda.valor),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  onPressed: () =>
                                      _isarService.deleteVenda(venda.id),
                                ),
                              ],
                            ),
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

  String _getTextoTotal() {
    switch (_filtroIndex) {
      case 0:
        return "Total de Hoje:";
      case 1:
        return "Total do Mês:";
      case 2:
        return "Total do Ano:";
      default:
        return "Total:";
    }
  }

  void _registrarVenda() {
    // CONVERSÃO INTELIGENTE:
    final valor = UtilBrasilFields.converterMoedaParaDouble(
      _valorController.text,
    );

    if (valor > 0) {
      _isarService.addVenda(valor, _descController.text);
      _valorController.clear();
      _descController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Venda registrada!"),
          duration: Duration(milliseconds: 800),
        ),
      );
    }
  }
}
