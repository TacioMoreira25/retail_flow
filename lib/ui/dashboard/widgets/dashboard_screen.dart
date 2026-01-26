import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visão Geral'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.store_mall_directory,
              size: 80,
              color: Colors.teal,
            ),
            const SizedBox(height: 20),
            Text(
              'Bem-vinda ao RetailFlow!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            const Text('Seu gestor financeiro offline.'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Futuramente aqui abrirá o cadastro de Boleto
          print("Clicou em Adicionar");
        },
        label: const Text('Novo Boleto'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
