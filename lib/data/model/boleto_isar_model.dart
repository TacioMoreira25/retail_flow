import 'package:isar/isar.dart';

// "Gere um arquivo com o mesmo nome, mas terminando em .g.dart aqui".
part 'boleto_isar_model.g.dart';

@collection
class BoletoIsarModel {
  Id id = Isar.autoIncrement;

  late String fornecedor;
  late double valor;
  late DateTime vencimento;

  bool isPago = false;

  String? fotoPath; // Caminho da imagem no celular
}
