import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../data/model/boleto_isar_model.dart';
import '../view_models/boletos_view_model.dart';
import 'package:flutter/services.dart';
import 'package:brasil_fields/brasil_fields.dart';

class BoletoFormScreen extends StatefulWidget {
  final BoletoIsarModel? boletoParaEditar;

  const BoletoFormScreen({super.key, this.boletoParaEditar});

  @override
  State<BoletoFormScreen> createState() => _BoletoFormScreenState();
}

class _BoletoFormScreenState extends State<BoletoFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fornecedorController = TextEditingController();
  final _valorController = TextEditingController();
  final _parcelasController = TextEditingController(text: "1"); // Começa com 1

  final _viewModel = BoletoViewModel();

  late DateTime _dataVencimento;
  String? _caminhoFoto;

  int _qtdParcelasVisual = 1;

  @override
  void initState() {
    super.initState();

    if (widget.boletoParaEditar != null) {
      final b = widget.boletoParaEditar!;
      _fornecedorController.text = b.fornecedor ?? "";
      _valorController.text = b.valor.toStringAsFixed(2);
      _dataVencimento = b.vencimento ?? DateTime.now();
      _caminhoFoto = b.fotoPath;
      // Na edição, não mexemos nas parcelas (bloqueado)
      _parcelasController.text = "1";
    } else {
      _dataVencimento = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ehEdicao = widget.boletoParaEditar != null;

    return Scaffold(
      appBar: AppBar(title: Text(ehEdicao ? "Editar Boleto" : "Novo Boleto")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // --- ÁREA DA FOTO ---
              GestureDetector(
                onTap: _tirarFoto,
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[400]!),
                    image: _caminhoFoto != null
                        ? DecorationImage(
                            image: FileImage(File(_caminhoFoto!)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _caminhoFoto == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 40,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(height: 8),
                            const Text("Toque para fotografar"),
                          ],
                        )
                      : null,
                ),
              ),
              if (_caminhoFoto != null)
                TextButton.icon(
                  onPressed: () => setState(() => _caminhoFoto = null),
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text("Remover foto"),
                ),

              const SizedBox(height: 24),

              // --- CAMPO FORNECEDOR ---
              TextFormField(
                controller: _fornecedorController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: "Fornecedor / Loja",
                  prefixIcon: Icon(Icons.store),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Digite o nome" : null,
              ),
              const SizedBox(height: 16),

              // --- LINHA DUPLA: VALOR E PARCELAS (Lado a Lado) ---
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _valorController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        // Formata automaticamente como R$ 0,00
                        CentavosInputFormatter(moeda: true),
                      ],
                      decoration: const InputDecoration(
                        labelText: "Valor",
                        prefixIcon: Icon(Icons.monetization_on),
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => v!.isEmpty ? "Obrigatório" : null,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // 2. Campo Parcelas (Ocupa menos espaço)
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _parcelasController,
                      keyboardType: TextInputType.number,
                      enabled: !ehEdicao, // Bloqueia se for edição
                      decoration: const InputDecoration(
                        labelText: "Parcelas",
                        hintText: "Ex: 12",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                      ),
                      onChanged: (value) {
                        // Atualiza o texto de ajuda em tempo real
                        setState(() {
                          _qtdParcelasVisual = int.tryParse(value) ?? 1;
                        });
                      },
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Min 1";
                        if (int.tryParse(v) == null) return "Núm";
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              // Texto de Ajuda (Fica embaixo para não estourar a tela)
              if (_qtdParcelasVisual > 1 && !ehEdicao)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 4),
                  child: Text(
                    "⚠️ Serão gerados $_qtdParcelasVisual boletos mensais automaticamente.",
                    style: TextStyle(
                      color: Colors.orange[800],
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              // --- DATA DE VENCIMENTO ---
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("1º Vencimento"),
                subtitle: Text(
                  DateFormat('dd/MM/yyyy').format(_dataVencimento),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: const Icon(Icons.calendar_today, color: Colors.red),
                onTap: _selecionarData,
              ),
              const Divider(),
              const SizedBox(height: 24),

              // --- BOTÃO SALVAR ---
              ListenableBuilder(
                listenable: _viewModel,
                builder: (context, _) {
                  return _viewModel.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : FilledButton.icon(
                          onPressed: _salvar,
                          icon: const Icon(Icons.save),
                          label: Text(
                            ehEdicao ? "ATUALIZAR DADOS" : "SALVAR CONTA",
                          ),
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

  Future<void> _tirarFoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? foto = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (foto != null) setState(() => _caminhoFoto = foto.path);
  }

  Future<void> _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _dataVencimento,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (data != null) setState(() => _dataVencimento = data);
  }

  void _salvar() async {
    if (_formKey.currentState!.validate()) {
      // CONVERSÃO INTELIGENTE:
      // Transforma "R$ 1.234,56" em 1234.56 (double)
      final valor = UtilBrasilFields.converterMoedaParaDouble(
        _valorController.text,
      );

      final parcelas = int.tryParse(_parcelasController.text) ?? 1;

      await _viewModel.salvarBoleto(
        id: widget.boletoParaEditar?.id,
        fornecedor: _fornecedorController.text,
        valor: valor, // Usa o valor convertido
        vencimento: _dataVencimento,
        fotoPath: _caminhoFoto,
        parcelas: parcelas,
      );

      if (mounted && _viewModel.erro == null) {
        Navigator.pop(context, true);
      }
    }
  }
}
