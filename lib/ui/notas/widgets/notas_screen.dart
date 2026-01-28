import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import '../../../data/model/nota_isar_model.dart';
import '../../../data/services/isar_service.dart';

class NotasScreen extends StatefulWidget {
  const NotasScreen({super.key});

  @override
  State<NotasScreen> createState() => _NotasScreenState();
}

class _NotasScreenState extends State<NotasScreen> {
  final _isarService = GetIt.I<IsarService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bloco de Notas")),
      body: StreamBuilder<List<NotaIsarModel>>(
        stream: _isarService.listenToNotas(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sticky_note_2_outlined,
                    size: 60,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 10),
                  const Text("Nenhuma nota ainda."),
                ],
              ),
            );
          }

          final notas = snapshot.data!;

          // GridView cria o efeito de grade (2 colunas)
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 notas por linha
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85, // Altura um pouco maior que a largura
            ),
            itemCount: notas.length,
            itemBuilder: (context, index) {
              final nota = notas[index];
              return _buildNotaCard(nota);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarDialogoNovaNota(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildNotaCard(NotaIsarModel nota) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.yellow[100], // Cor de Post-it
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  nota.titulo,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Botãozinho discreto para apagar
              GestureDetector(
                onTap: () => _isarService.deleteNota(nota.id),
                child: const Icon(Icons.close, size: 18, color: Colors.brown),
              ),
            ],
          ),
          const Divider(color: Colors.brown, thickness: 0.5),
          Expanded(
            child: Text(
              nota.conteudo,
              style: const TextStyle(fontSize: 14, height: 1.2),
              maxLines: 6,
              overflow: TextOverflow.fade,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('dd/MM HH:mm').format(nota.data),
            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  // Janela flutuante para criar nota
  void _mostrarDialogoNovaNota(BuildContext context) {
    final tituloController = TextEditingController();
    final conteudoController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Nova Nota"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: tituloController,
              decoration: const InputDecoration(
                labelText: "Título (Ex: Ligar)",
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: conteudoController,
              decoration: const InputDecoration(
                labelText: "Mensagem",
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          FilledButton(
            onPressed: () {
              if (tituloController.text.isNotEmpty) {
                _isarService.addNota(
                  tituloController.text,
                  conteudoController.text,
                );
                Navigator.pop(context);
              }
            },
            child: const Text("Salvar"),
          ),
        ],
      ),
    );
  }
}
