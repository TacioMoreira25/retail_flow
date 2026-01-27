import 'package:isar/isar.dart';

part 'venda_isar_model.g.dart';

@collection
class VendaIsarModel {
  Id id = Isar.autoIncrement;

  late double valor;
  late DateTime data;
  String? descricao;
}
