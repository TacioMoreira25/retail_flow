import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../view_models/boletos_view_model.dart';

class BoletoFormScreen extends StatefulWidget {
  const BoletoFormScreen({super.key});

  @override
  State<BoletoFormScreen> createState() => _BoletoFormScreenState();
}

class _BoletoFormScreenState extends State<BoletoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fornecedorController = TextEditingController();
  final _valorController = TextEditingController();
  final _viewModel = BoletoViewModel();

  DateTime _dataVencimento = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Novo Boleto")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // 1. Campo Fornecedor
              TextFormField(
                controller: _fornecedorController,
                decoration: const InputDecoration(
                  labelText: "Nome do Fornecedor / Loja",
                  prefixIcon: Icon(Icons.store),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? "Digite o nome" : null,
              ),
              const SizedBox(height: 16),

              // 2. Campo Valor
              TextFormField(
                controller: _valorController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Valor (R\$)",
                  prefixIcon: Icon(Icons.monetization_on),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? "Digite o valor" : null,
              ),
              const SizedBox(height: 16),

              // 3. Seletor de Data (Para não ter erro de digitação)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Data de Vencimento"),
                subtitle: Text(
                  DateFormat('dd/MM/yyyy').format(_dataVencimento),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _selecionarData,
              ),
              const Divider(),
              const SizedBox(height: 24),

              // 4. Botão Salvar com Feedback de Carregamento
              ListenableBuilder(
                listenable: _viewModel,
                builder: (context, _) {
                  return _viewModel.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : FilledButton.icon(
                          onPressed: _salvar,
                          icon: const Icon(Icons.save),
                          label: const Text("SALVAR E AGENDAR ALERTA"),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (data != null) {
      setState(() => _dataVencimento = data);
    }
  }

  void _salvar() async {
    if (_formKey.currentState!.validate()) {
      // Converte texto para double (tratando vírgula)
      final valor =
          double.tryParse(_valorController.text.replaceAll(',', '.')) ?? 0.0;

      await _viewModel.salvarBoleto(
        fornecedor: _fornecedorController.text,
        valor: valor,
        vencimento: _dataVencimento,
      );

      if (mounted) {
        if (_viewModel.erro != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_viewModel.erro!),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Boleto Salvo! Alarme criado.")),
          );
          Navigator.pop(context); // Volta para o Dashboard
        }
      }
    }
  }
}
