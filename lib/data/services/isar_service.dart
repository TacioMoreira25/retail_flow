import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../model/boleto_isar_model.dart';
import '../model/nota_isar_model.dart';
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
        NotaIsarModelSchema,
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

  // Atualiza um boleto existente
  Future<void> updateBoleto(BoletoIsarModel boleto) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.boletoIsarModels.put(boleto);
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

  Stream<List<VendaIsarModel>> listenToVendasPorPeriodo(
    DateTime inicio,
    DateTime fim,
  ) async* {
    final isar = await db;
    yield* isar.vendaIsarModels
        .filter()
        .dataBetween(inicio, fim)
        .sortByDataDesc() // Mais recentes primeiro
        .watch(fireImmediately: true);
  }

  // 3. Apagar Venda
  Future<void> deleteVenda(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.vendaIsarModels.delete(id);
    });
  }

  // 1. Calcula quanto vendeu hoje (Soma total)
  Stream<double> watchTotalVendasHoje() async* {
    final isar = await db;
    final hoje = DateTime.now();
    // Define o intervalo do dia inteiro (00:00 até 23:59)
    final inicio = DateTime(hoje.year, hoje.month, hoje.day);
    final fim = DateTime(hoje.year, hoje.month, hoje.day, 23, 59, 59);

    yield* isar.vendaIsarModels
        .filter()
        .dataBetween(inicio, fim)
        .watch(fireImmediately: true) // Ouve mudanças
        .map(
          (vendas) => vendas.fold(0.0, (soma, v) => soma + v.valor),
        ); // Soma tudo
  }

  // 2. Calcula quanto tem para pagar hoje (Apenas o que NÃO está pago)
  Stream<double> watchTotalPagarHoje() async* {
    final isar = await db;
    final hoje = DateTime.now();
    final inicio = DateTime(hoje.year, hoje.month, hoje.day);
    final fim = DateTime(hoje.year, hoje.month, hoje.day, 23, 59, 59);

    yield* isar.boletoIsarModels
        .filter()
        .vencimentoBetween(inicio, fim)
        .isPagoEqualTo(
          false,
        ) // Só mostra o que falta pagar. Se pagar, some daqui!
        .watch(fireImmediately: true)
        .map((boletos) => boletos.fold(0.0, (soma, b) => soma + b.valor));
  }

  // 3. Lista apenas os Boletos Urgentes (Vencidos ou Vencendo Hoje/Amanhã)
  Stream<List<BoletoIsarModel>> watchBoletosUrgentes() async* {
    final isar = await db;
    final hoje = DateTime.now();
    final amanha = hoje.add(const Duration(days: 1));
    final fimAmanha = DateTime(
      amanha.year,
      amanha.month,
      amanha.day,
      23,
      59,
      59,
    );

    yield* isar.boletoIsarModels
        .filter()
        .isPagoEqualTo(false) // Só os pendentes
        .vencimentoLessThan(
          fimAmanha,
        ) // Vence até o fim de amanhã (pega atrasados também)
        .sortByVencimento()
        .watch(fireImmediately: true);
  }

  // null = Todos, false = Pendentes, true = Pagos
  Stream<List<BoletoIsarModel>> watchBoletosFiltrados(bool? isPago) async* {
    final isar = await db;

    // CAMINHO 1: Tem filtro (Pago ou Pendente)
    if (isPago != null) {
      yield* isar.boletoIsarModels
          .filter()
          .isPagoEqualTo(isPago) // Aplica o filtro
          .sortByVencimento()
          .watch(fireImmediately: true);
    }
    // CAMINHO 2: Sem filtro (Trazer todos)
    else {
      yield* isar.boletoIsarModels
          .filter()
          .idGreaterThan(-1)
          .sortByVencimento()
          .watch(fireImmediately: true);
    }
  }

  Future<void> addNota(String titulo, String conteudo) async {
    final isar = await db;
    final nota = NotaIsarModel()
      ..titulo = titulo
      ..conteudo = conteudo
      ..data = DateTime.now();

    await isar.writeTxn(() async {
      await isar.notaIsarModels.put(nota);
    });
  }

  Future<void> deleteNota(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.notaIsarModels.delete(id);
    });
  }

  Stream<List<NotaIsarModel>> listenToNotas() async* {
    final isar = await db;
    // Ordena por ID decrescente (as mais novas aparecem primeiro)
    yield* isar.notaIsarModels
        .filter()
        .idGreaterThan(-1)
        .sortByDataDesc()
        .watch(fireImmediately: true);
  }
}
