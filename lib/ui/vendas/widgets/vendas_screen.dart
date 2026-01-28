import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/services.dart';
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

  // 0 = Hoje, 1 = Mês Atual, 2 = Ano, 3 = Mês Específico (Personalizado)
  int _filtroIndex = 0;
  DateTime _mesPersonalizado =
      DateTime.now(); // Guarda o mês que o usuário escolheu

  @override
  Widget build(BuildContext context) {
    // --- LÓGICA DE DATAS ---
    final agora = DateTime.now();
    DateTime inicio, fim;

    if (_filtroIndex == 0) {
      // HOJE
      inicio = DateTime(agora.year, agora.month, agora.day);
      fim = DateTime(agora.year, agora.month, agora.day, 23, 59, 59);
    } else if (_filtroIndex == 1) {
      // ESTE MÊS
      inicio = DateTime(agora.year, agora.month, 1);
      fim = DateTime(agora.year, agora.month + 1, 0, 23, 59, 59);
    } else if (_filtroIndex == 2) {
      // ESTE ANO
      inicio = DateTime(agora.year, 1, 1);
      fim = DateTime(agora.year, 12, 31, 23, 59, 59);
    } else {
      // MÊS PERSONALIZADO (Index 3)
      inicio = DateTime(_mesPersonalizado.year, _mesPersonalizado.month, 1);
      fim = DateTime(
        _mesPersonalizado.year,
        _mesPersonalizado.month + 1,
        0,
        23,
        59,
        59,
      );
    }

    // Texto para o cabeçalho
    String tituloTotal = "Total:";
    if (_filtroIndex == 0)
      tituloTotal = "Hoje:";
    else if (_filtroIndex == 1)
      tituloTotal = "Neste Mês:";
    else if (_filtroIndex == 2)
      tituloTotal = "Neste Ano:";
    else
      tituloTotal = DateFormat(
        'MMMM/yy',
        'pt_BR',
      ).format(_mesPersonalizado).toUpperCase(); // Ex: JANEIRO/25

    return Scaffold(
      appBar: AppBar(
        title: const Text("Caixa (Vendas)"),
        actions: [
          // BOTÃO DE CALENDÁRIO
          IconButton(
            tooltip: "Escolher outro mês",
            icon: const Icon(Icons.calendar_month),
            onPressed: _abrirSeletorDeMes,
          ),
        ],
      ),
      body: Column(
        children: [
          // --- 1. CADASTRO RÁPIDO ---
          ExpansionTile(
            title: const Text(
              "Nova Venda",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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
                        labelText: "Valor da Venda",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _descController,
                      decoration: const InputDecoration(
                        labelText: "Descrição (Ex: Vestido)",
                        border: OutlineInputBorder(),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _registrarVenda,
                        icon: const Icon(Icons.check),
                        label: const Text("LANÇAR VENDA"),
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

          // --- 2. FILTROS (TEXTO MAIS CURTO PARA NÃO CORTAR) ---
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              // Garante que não quebre em telas muito pequenas
              scrollDirection: Axis.horizontal,
              child: SegmentedButton<int>(
                segments: [
                  const ButtonSegment(value: 0, label: Text("Hoje")),
                  const ButtonSegment(
                    value: 1,
                    label: Text("Mês"),
                  ), // Texto encurtado
                  const ButtonSegment(
                    value: 2,
                    label: Text("Ano"),
                  ), // Texto encurtado
                  // O botão "Outro" aparece quando selecionamos pelo calendário
                  if (_filtroIndex == 3)
                    const ButtonSegment(
                      value: 3,
                      label: Text("Outro"),
                      icon: Icon(Icons.filter_alt),
                    ),
                ],
                selected: {_filtroIndex},
                onSelectionChanged: (Set<int> newSelection) {
                  setState(() => _filtroIndex = newSelection.first);
                },
                showSelectedIcon: false,
                style: ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
          ),

          // --- 3. LISTA E TOTAL ---
          Expanded(
            child: StreamBuilder<List<VendaIsarModel>>(
              stream: _isarService.listenToVendasPorPeriodo(inicio, fim),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.sell_outlined,
                          size: 60,
                          color: Colors.grey[300],
                        ),
                        Text(
                          "Sem vendas neste período",
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  );
                }

                final vendas = snapshot.data!;
                final totalPeriodo = vendas.fold(
                  0.0,
                  (sum, item) => sum + item.valor,
                );

                return Column(
                  children: [
                    // BARRA DE TOTAL
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      color: Colors.green[50],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tituloTotal,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            NumberFormat.simpleCurrency(
                              locale: 'pt_BR',
                            ).format(totalPeriodo),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // LISTAGEM
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
                                Icons.attach_money,
                                color: Colors.green,
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

  // Função para abrir calendário e escolher mês
  Future<void> _abrirSeletorDeMes() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _filtroIndex == 3 ? _mesPersonalizado : DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      helpText: "ESCOLHA UM DIA DO MÊS DESEJADO",
    );

    if (picked != null) {
      setState(() {
        _mesPersonalizado = picked; // Guarda a data
        _filtroIndex = 3; // Muda a aba para "Outro" (Personalizado)
      });
    }
  }

  void _registrarVenda() {
    final valor = UtilBrasilFields.converterMoedaParaDouble(
      _valorController.text,
    );
    if (valor > 0) {
      _isarService.addVenda(valor, _descController.text);
      _valorController.clear();
      _descController.clear();
      // Fecha o teclado
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Venda registrada!")));
    }
  }
}
