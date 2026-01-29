import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
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

  // 0 = Hoje, 1 = Mês, 2 = Ano, 3 = Período Personalizado
  int _filtroIndex = 0;

  // Agora usamos um DateTimeRange para guardar início e fim
  DateTimeRange? _periodoPersonalizado;

  bool _localePronto = false;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('pt_BR', null).then((_) {
      if (mounted) setState(() => _localePronto = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_localePronto) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final agora = DateTime.now();
    DateTime inicio, fim;

    // --- LÓGICA DE DATAS ---
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
      // PERÍODO PERSONALIZADO (Index 3)
      // Se não tiver escolhido nada ainda, usa hoje como padrão
      inicio =
          _periodoPersonalizado?.start ??
          DateTime(agora.year, agora.month, agora.day);
      // O fim do range vem como 00:00, então ajustamos para 23:59:59
      final fimRange =
          _periodoPersonalizado?.end ??
          DateTime(agora.year, agora.month, agora.day);
      fim = DateTime(fimRange.year, fimRange.month, fimRange.day, 23, 59, 59);
    }

    // --- TÍTULO DO CABEÇALHO ---
    String tituloTotal = "Total:";
    if (_filtroIndex == 0)
      tituloTotal = "Hoje:";
    else if (_filtroIndex == 1)
      tituloTotal = "Neste Mês:";
    else if (_filtroIndex == 2)
      tituloTotal = "Neste Ano:";
    else {
      // Ex: 01/02 até 15/02
      final f = DateFormat('dd/MM');
      tituloTotal = "${f.format(inicio)} até ${f.format(fim)}";
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Caixa (Vendas)"),
        actions: [
          // ÍCONE MUDOU PARA DATE RANGE
          IconButton(
            tooltip: "Escolher período",
            icon: const Icon(Icons.date_range), // Ícone mais apropriado
            onPressed: _abrirSeletorDePeriodo, // <--- Nova função
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

          // --- 2. FILTROS ---
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SegmentedButton<int>(
                segments: [
                  const ButtonSegment(value: 0, label: Text("Hoje")),
                  const ButtonSegment(value: 1, label: Text("Mês")),
                  const ButtonSegment(value: 2, label: Text("Ano")),
                  // Botão "Período" aparece quando selecionado
                  if (_filtroIndex == 3)
                    const ButtonSegment(
                      value: 3,
                      label: Text("Período"),
                      icon: Icon(Icons.filter_alt),
                    ),
                ],
                selected: {_filtroIndex},
                onSelectionChanged: (Set<int> newSelection) {
                  setState(() => _filtroIndex = newSelection.first);
                },
                showSelectedIcon: false,
                style: const ButtonStyle(
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
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final vendas = snapshot.data ?? [];

                if (vendas.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.date_range_outlined,
                          size: 80,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Sem vendas no período",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                        if (_filtroIndex == 3)
                          TextButton(
                            onPressed: _abrirSeletorDePeriodo,
                            child: const Text("Mudar Datas"),
                          ),
                      ],
                    ),
                  );
                }

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

  Future<void> _abrirSeletorDePeriodo() async {
    final pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      initialDateRange: _periodoPersonalizado,
      locale: const Locale('pt', 'BR'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFB71C1C),
              primary: const Color(0xFFB71C1C),
            ),
          ),
          child: child!,
        );
      },
      helpText: "SELECIONE O INÍCIO E O FIM",
      saveText: "FILTRAR",
    );

    if (pickedRange != null) {
      setState(() {
        _periodoPersonalizado = pickedRange;
        _filtroIndex = 3;
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
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Venda registrada!")));
    }
  }
}
