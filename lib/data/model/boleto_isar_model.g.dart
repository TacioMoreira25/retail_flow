// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'boleto_isar_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBoletoIsarModelCollection on Isar {
  IsarCollection<BoletoIsarModel> get boletoIsarModels => this.collection();
}

const BoletoIsarModelSchema = CollectionSchema(
  name: r'BoletoIsarModel',
  id: 508833800094426141,
  properties: {
    r'fornecedor': PropertySchema(
      id: 0,
      name: r'fornecedor',
      type: IsarType.string,
    ),
    r'fotoPath': PropertySchema(
      id: 1,
      name: r'fotoPath',
      type: IsarType.string,
    ),
    r'isPago': PropertySchema(
      id: 2,
      name: r'isPago',
      type: IsarType.bool,
    ),
    r'valor': PropertySchema(
      id: 3,
      name: r'valor',
      type: IsarType.double,
    ),
    r'vencimento': PropertySchema(
      id: 4,
      name: r'vencimento',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _boletoIsarModelEstimateSize,
  serialize: _boletoIsarModelSerialize,
  deserialize: _boletoIsarModelDeserialize,
  deserializeProp: _boletoIsarModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _boletoIsarModelGetId,
  getLinks: _boletoIsarModelGetLinks,
  attach: _boletoIsarModelAttach,
  version: '3.1.0+1',
);

int _boletoIsarModelEstimateSize(
  BoletoIsarModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.fornecedor.length * 3;
  {
    final value = object.fotoPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _boletoIsarModelSerialize(
  BoletoIsarModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.fornecedor);
  writer.writeString(offsets[1], object.fotoPath);
  writer.writeBool(offsets[2], object.isPago);
  writer.writeDouble(offsets[3], object.valor);
  writer.writeDateTime(offsets[4], object.vencimento);
}

BoletoIsarModel _boletoIsarModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BoletoIsarModel();
  object.fornecedor = reader.readString(offsets[0]);
  object.fotoPath = reader.readStringOrNull(offsets[1]);
  object.id = id;
  object.isPago = reader.readBool(offsets[2]);
  object.valor = reader.readDouble(offsets[3]);
  object.vencimento = reader.readDateTime(offsets[4]);
  return object;
}

P _boletoIsarModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _boletoIsarModelGetId(BoletoIsarModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _boletoIsarModelGetLinks(BoletoIsarModel object) {
  return [];
}

void _boletoIsarModelAttach(
    IsarCollection<dynamic> col, Id id, BoletoIsarModel object) {
  object.id = id;
}

extension BoletoIsarModelQueryWhereSort
    on QueryBuilder<BoletoIsarModel, BoletoIsarModel, QWhere> {
  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BoletoIsarModelQueryWhere
    on QueryBuilder<BoletoIsarModel, BoletoIsarModel, QWhereClause> {
  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BoletoIsarModelQueryFilter
    on QueryBuilder<BoletoIsarModel, BoletoIsarModel, QFilterCondition> {
  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterFilterCondition>
      fornecedorEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fornecedor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterFilterCondition>
      fornecedorGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fornecedor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterFilterCondition>
      fornecedorLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fornecedor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterFilterCondition>
      fornecedorBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fornecedor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterFilterCondition>
      fornecedorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fornecedor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterFilterCondition>
      fornecedorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fornecedor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterFilterCondition>
      fornecedorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fornecedor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterFilterCondition>
      fornecedorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fornecedor',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterFilterCondition>
      fornecedorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fornecedor',
        value: '',
      ));
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterFilterCondition>
      fornecedorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fornecedor',
        value: '',
      ));
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterFilterCondition>
      fotoPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fotoPath',
      ));
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterFilterCondition>
      fotoPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fotoPath',
      ));
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterFilterCondition>
      fotoPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fotoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterFilterCondition>
      fotoPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fotoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterFilterCondition>
      fotoPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fotoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterFilterCondition>
      fotoPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fotoPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterFilterCondition>
      fotoPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fotoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterFilterCondition>
      fotoPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fotoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterFilterCondition>
      fotoPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fotoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterFilterCondition>
      fotoPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fotoPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterFilterCondition>
      fotoPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fotoPath',
        value: '',
      ));
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterFilterCondition>
      fotoPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fotoPath',
        value: '',
      ));
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterFilterCondition>
      isPagoEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isPago',
        value: value,
      ));
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterFilterCondition>
      valorEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'valor',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterFilterCondition>
      valorGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'valor',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterFilterCondition>
      valorLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'valor',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterFilterCondition>
      valorBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'valor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterFilterCondition>
      vencimentoEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vencimento',
        value: value,
      ));
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterFilterCondition>
      vencimentoGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vencimento',
        value: value,
      ));
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterFilterCondition>
      vencimentoLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vencimento',
        value: value,
      ));
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterFilterCondition>
      vencimentoBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vencimento',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BoletoIsarModelQueryObject
    on QueryBuilder<BoletoIsarModel, BoletoIsarModel, QFilterCondition> {}

extension BoletoIsarModelQueryLinks
    on QueryBuilder<BoletoIsarModel, BoletoIsarModel, QFilterCondition> {}

extension BoletoIsarModelQuerySortBy
    on QueryBuilder<BoletoIsarModel, BoletoIsarModel, QSortBy> {
  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterSortBy>
      sortByFornecedor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fornecedor', Sort.asc);
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterSortBy>
      sortByFornecedorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fornecedor', Sort.desc);
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterSortBy>
      sortByFotoPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fotoPath', Sort.asc);
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterSortBy>
      sortByFotoPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fotoPath', Sort.desc);
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterSortBy> sortByIsPago() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPago', Sort.asc);
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterSortBy>
      sortByIsPagoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPago', Sort.desc);
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterSortBy> sortByValor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valor', Sort.asc);
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterSortBy>
      sortByValorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valor', Sort.desc);
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterSortBy>
      sortByVencimento() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vencimento', Sort.asc);
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterSortBy>
      sortByVencimentoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vencimento', Sort.desc);
    });
  }
}

extension BoletoIsarModelQuerySortThenBy
    on QueryBuilder<BoletoIsarModel, BoletoIsarModel, QSortThenBy> {
  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterSortBy>
      thenByFornecedor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fornecedor', Sort.asc);
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterSortBy>
      thenByFornecedorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fornecedor', Sort.desc);
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterSortBy>
      thenByFotoPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fotoPath', Sort.asc);
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterSortBy>
      thenByFotoPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fotoPath', Sort.desc);
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterSortBy> thenByIsPago() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPago', Sort.asc);
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterSortBy>
      thenByIsPagoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPago', Sort.desc);
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterSortBy> thenByValor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valor', Sort.asc);
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterSortBy>
      thenByValorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valor', Sort.desc);
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterSortBy>
      thenByVencimento() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vencimento', Sort.asc);
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QAfterSortBy>
      thenByVencimentoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vencimento', Sort.desc);
    });
  }
}

extension BoletoIsarModelQueryWhereDistinct
    on QueryBuilder<BoletoIsarModel, BoletoIsarModel, QDistinct> {
  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QDistinct>
      distinctByFornecedor({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fornecedor', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QDistinct> distinctByFotoPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fotoPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QDistinct> distinctByIsPago() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isPago');
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QDistinct> distinctByValor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'valor');
    });
  }

  QueryBuilder<BoletoIsarModel, BoletoIsarModel, QDistinct>
      distinctByVencimento() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vencimento');
    });
  }
}

extension BoletoIsarModelQueryProperty
    on QueryBuilder<BoletoIsarModel, BoletoIsarModel, QQueryProperty> {
  QueryBuilder<BoletoIsarModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BoletoIsarModel, String, QQueryOperations> fornecedorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fornecedor');
    });
  }

  QueryBuilder<BoletoIsarModel, String?, QQueryOperations> fotoPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fotoPath');
    });
  }

  QueryBuilder<BoletoIsarModel, bool, QQueryOperations> isPagoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isPago');
    });
  }

  QueryBuilder<BoletoIsarModel, double, QQueryOperations> valorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'valor');
    });
  }

  QueryBuilder<BoletoIsarModel, DateTime, QQueryOperations>
      vencimentoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vencimento');
    });
  }
}
