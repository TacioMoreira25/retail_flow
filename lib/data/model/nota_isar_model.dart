import 'package:isar/isar.dart';

part 'nota_isar_model.g.dart';

@collection
class NotaIsarModel {
  Id id = Isar.autoIncrement;

  late String titulo;
  late String conteudo;
  late DateTime data;
}
