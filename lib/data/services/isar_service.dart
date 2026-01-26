import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../model/boleto_isar_model.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();

    if (Isar.instanceNames.isEmpty) {
      return await Isar.open([BoletoIsarModelSchema], directory: dir.path);
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
}
