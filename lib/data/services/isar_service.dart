import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../model/boleto_isar_model.dart';
import '../model/venda_isar_model.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();

    if (Isar.instanceNames.isEmpty) {
      return await Isar.open([
        BoletoIsarModelSchema,
        VendaIsarModelSchema,
      ], directory: dir.path);
    }
    return Isar.getInstance()!;
  }

  // --- MÉTODOS CRUD (Criar, Ler, Atualizar, Deletar) ---

  // 1. Salvar um novo boleto
  Future<void> saveBoleto(BoletoIsarModel boleto) async {
    final isar = await db;
    // O writeTxn é obrigatório para qualquer escrita no banco
    await isar.writeTxn(() async {
      await isar.boletoIsarModels.put(boleto);
    });
  }

  // 2. Pegar todos os boletos
  Future<List<BoletoIsarModel>> getAllBoletos() async {
    final isar = await db;
    // Busca todos e ordena pela data de vencimento
    return await isar.boletoIsarModels.where().sortByVencimento().findAll();
  }

  // 3. Apagar um boleto
  Future<void> deleteBoleto(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.boletoIsarModels.delete(id);
    });
  }

  Stream<List<BoletoIsarModel>> listenToBoletos() async* {
    final isar = await db;
    // Isso cria um fluxo de dados em tempo real
    yield* isar.boletoIsarModels.where().watch(fireImmediately: true);
  }

  // 1. Salvar Venda
  Future<void> addVenda(double valor, String descricao) async {
    final isar = await db;
    final novaVenda = VendaIsarModel()
      ..valor = valor
      ..descricao = descricao
      ..data = DateTime.now();

    await isar.writeTxn(() async {
      await isar.vendaIsarModels.put(novaVenda);
    });
  }

  // 2. Listar Vendas de Hoje (Para o resumo)
  Stream<List<VendaIsarModel>> listenToVendasDoDia() async* {
    final isar = await db;
    // Pega o início do dia (00:00) e o fim do dia (23:59)
    final hoje = DateTime.now();
    final inicioDia = DateTime(hoje.year, hoje.month, hoje.day);
    final fimDia = DateTime(hoje.year, hoje.month, hoje.day, 23, 59, 59);

    yield* isar.vendaIsarModels
        .filter()
        .dataBetween(inicioDia, fimDia) // Só mostra o que vendeu hoje
        .sortByDataDesc() // As mais recentes primeiro
        .watch(fireImmediately: true);
  }

  // 3. Apagar Venda
  Future<void> deleteVenda(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.vendaIsarModels.delete(id);
    });
  }
}
