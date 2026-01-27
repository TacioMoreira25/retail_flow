import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import '../../../data/model/venda_isar_model.dart';
import '../../../data/services/isar_service.dart';

class VendasScreen extends StatefulWidget {
  const VendasScreen({super.key});

  @override
  State<VendasScreen> createState() => _VendasScreenState();
}

class _VendasScreenState extends State<VendasScreen> {
  final _valorController = TextEditingController();
  final _descController = TextEditingController();
  final _isarService = GetIt.I<IsarService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrar Venda")),
      body: Column(
        children: [
          // --- ÁREA DE CADASTRO RÁPIDO ---
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Input de Valor (Bem grande)
                TextField(
                  controller: _valorController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  decoration: const InputDecoration(
                    labelText: "Valor (R\$)",
                    prefixText: "R\$ ",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                // Input de Descrição (Opcional)
                TextField(
                  controller: _descController,
                  decoration: const InputDecoration(
                    labelText: "Descrição (Ex: Vestido longo)",
                    prefixIcon: Icon(Icons.label_outline),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                // Botão Gigante
                FilledButton.icon(
                  onPressed: _registrarVenda,
                  icon: const Icon(Icons.attach_money),
                  label: const Text("REGISTRAR ENTRADA"),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.green[700], // Verde dinheiro
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // --- LISTA DE VENDAS DE HOJE ---
          Expanded(
            child: StreamBuilder<List<VendaIsarModel>>(
              stream: _isarService.listenToVendasDoDia(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 60,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 10),
                        const Text("Nenhuma venda hoje ainda."),
                      ],
                    ),
                  );
                }

                final vendas = snapshot.data!;
                // Calcula o total do dia na hora
                final totalDia = vendas.fold(
                  0.0,
                  (sum, item) => sum + item.valor,
                );

                return Column(
                  children: [
                    // Cabeçalho da Lista com Total
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Histórico de Hoje",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Total: ${NumberFormat.simpleCurrency(locale: 'pt_BR').format(totalDia)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontSize: 16,
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
                            leading: CircleAvatar(
                              backgroundColor: Colors.green[100],
                              child: const Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                            ),
                            title: Text(
                              venda.descricao?.isEmpty == true
                                  ? "Venda Diversa"
                                  : venda.descricao!,
                            ),
                            subtitle: Text(
                              DateFormat('HH:mm').format(venda.data),
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

  void _registrarVenda() {
    final valorTexto = _valorController.text.replaceAll(',', '.');
    final valor = double.tryParse(valorTexto);

    if (valor != null && valor > 0) {
      _isarService.addVenda(valor, _descController.text);

      // Limpa os campos e foca no valor de novo para a próxima venda rápida
      _valorController.clear();
      _descController.clear();

      // Feedback rápido
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Venda registrada! 💰"),
          duration: Duration(milliseconds: 800),
        ),
      );
    }
  }
}
