// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_weight.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCalendarWeightCollection on Isar {
  IsarCollection<CalendarWeight> get calendarWeights => this.collection();
}

const CalendarWeightSchema = CollectionSchema(
  name: r'CalendarWeight',
  id: 8902327684144921,
  properties: {
    r'dateId': PropertySchema(
      id: 0,
      name: r'dateId',
      type: IsarType.long,
    ),
    r'hashCode': PropertySchema(
      id: 1,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'impedance': PropertySchema(
      id: 2,
      name: r'impedance',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 3,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'weight': PropertySchema(
      id: 4,
      name: r'weight',
      type: IsarType.double,
    )
  },
  estimateSize: _calendarWeightEstimateSize,
  serialize: _calendarWeightSerialize,
  deserialize: _calendarWeightDeserialize,
  deserializeProp: _calendarWeightDeserializeProp,
  idName: r'id',
  indexes: {
    r'dateId': IndexSchema(
      id: 6719847948176985255,
      name: r'dateId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'dateId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'weight': IndexSchema(
      id: 2378601697443572121,
      name: r'weight',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'weight',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _calendarWeightGetId,
  getLinks: _calendarWeightGetLinks,
  attach: _calendarWeightAttach,
  version: '3.1.0+1',
);

int _calendarWeightEstimateSize(
  CalendarWeight object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _calendarWeightSerialize(
  CalendarWeight object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.dateId);
  writer.writeLong(offsets[1], object.hashCode);
  writer.writeLong(offsets[2], object.impedance);
  writer.writeDateTime(offsets[3], object.updatedAt);
  writer.writeDouble(offsets[4], object.weight);
}

CalendarWeight _calendarWeightDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CalendarWeight();
  object.dateId = reader.readLong(offsets[0]);
  object.id = id;
  object.impedance = reader.readLong(offsets[2]);
  object.updatedAt = reader.readDateTime(offsets[3]);
  object.weight = reader.readDouble(offsets[4]);
  return object;
}

P _calendarWeightDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _calendarWeightGetId(CalendarWeight object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _calendarWeightGetLinks(CalendarWeight object) {
  return [];
}

void _calendarWeightAttach(
    IsarCollection<dynamic> col, Id id, CalendarWeight object) {
  object.id = id;
}

extension CalendarWeightQueryWhereSort
    on QueryBuilder<CalendarWeight, CalendarWeight, QWhere> {
  QueryBuilder<CalendarWeight, CalendarWeight, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterWhere> anyDateId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'dateId'),
      );
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterWhere> anyWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'weight'),
      );
    });
  }
}

extension CalendarWeightQueryWhere
    on QueryBuilder<CalendarWeight, CalendarWeight, QWhereClause> {
  QueryBuilder<CalendarWeight, CalendarWeight, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterWhereClause> idBetween(
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

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterWhereClause> dateIdEqualTo(
      int dateId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'dateId',
        value: [dateId],
      ));
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterWhereClause>
      dateIdNotEqualTo(int dateId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateId',
              lower: [],
              upper: [dateId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateId',
              lower: [dateId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateId',
              lower: [dateId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateId',
              lower: [],
              upper: [dateId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterWhereClause>
      dateIdGreaterThan(
    int dateId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dateId',
        lower: [dateId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterWhereClause>
      dateIdLessThan(
    int dateId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dateId',
        lower: [],
        upper: [dateId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterWhereClause> dateIdBetween(
    int lowerDateId,
    int upperDateId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dateId',
        lower: [lowerDateId],
        includeLower: includeLower,
        upper: [upperDateId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterWhereClause> weightEqualTo(
      double weight) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'weight',
        value: [weight],
      ));
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterWhereClause>
      weightNotEqualTo(double weight) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'weight',
              lower: [],
              upper: [weight],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'weight',
              lower: [weight],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'weight',
              lower: [weight],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'weight',
              lower: [],
              upper: [weight],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterWhereClause>
      weightGreaterThan(
    double weight, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'weight',
        lower: [weight],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterWhereClause>
      weightLessThan(
    double weight, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'weight',
        lower: [],
        upper: [weight],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterWhereClause> weightBetween(
    double lowerWeight,
    double upperWeight, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'weight',
        lower: [lowerWeight],
        includeLower: includeLower,
        upper: [upperWeight],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CalendarWeightQueryFilter
    on QueryBuilder<CalendarWeight, CalendarWeight, QFilterCondition> {
  QueryBuilder<CalendarWeight, CalendarWeight, QAfterFilterCondition>
      dateIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateId',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterFilterCondition>
      dateIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateId',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterFilterCondition>
      dateIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateId',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterFilterCondition>
      dateIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterFilterCondition>
      hashCodeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterFilterCondition>
      hashCodeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterFilterCondition>
      hashCodeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterFilterCondition>
      hashCodeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hashCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterFilterCondition>
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

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterFilterCondition>
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

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterFilterCondition> idBetween(
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

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterFilterCondition>
      impedanceEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'impedance',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterFilterCondition>
      impedanceGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'impedance',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterFilterCondition>
      impedanceLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'impedance',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterFilterCondition>
      impedanceBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'impedance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterFilterCondition>
      weightEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterFilterCondition>
      weightGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterFilterCondition>
      weightLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterFilterCondition>
      weightBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension CalendarWeightQueryObject
    on QueryBuilder<CalendarWeight, CalendarWeight, QFilterCondition> {}

extension CalendarWeightQueryLinks
    on QueryBuilder<CalendarWeight, CalendarWeight, QFilterCondition> {}

extension CalendarWeightQuerySortBy
    on QueryBuilder<CalendarWeight, CalendarWeight, QSortBy> {
  QueryBuilder<CalendarWeight, CalendarWeight, QAfterSortBy> sortByDateId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateId', Sort.asc);
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterSortBy>
      sortByDateIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateId', Sort.desc);
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterSortBy> sortByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterSortBy>
      sortByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterSortBy> sortByImpedance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'impedance', Sort.asc);
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterSortBy>
      sortByImpedanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'impedance', Sort.desc);
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterSortBy> sortByWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weight', Sort.asc);
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterSortBy>
      sortByWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weight', Sort.desc);
    });
  }
}

extension CalendarWeightQuerySortThenBy
    on QueryBuilder<CalendarWeight, CalendarWeight, QSortThenBy> {
  QueryBuilder<CalendarWeight, CalendarWeight, QAfterSortBy> thenByDateId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateId', Sort.asc);
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterSortBy>
      thenByDateIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateId', Sort.desc);
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterSortBy> thenByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterSortBy>
      thenByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterSortBy> thenByImpedance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'impedance', Sort.asc);
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterSortBy>
      thenByImpedanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'impedance', Sort.desc);
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterSortBy> thenByWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weight', Sort.asc);
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QAfterSortBy>
      thenByWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weight', Sort.desc);
    });
  }
}

extension CalendarWeightQueryWhereDistinct
    on QueryBuilder<CalendarWeight, CalendarWeight, QDistinct> {
  QueryBuilder<CalendarWeight, CalendarWeight, QDistinct> distinctByDateId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateId');
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QDistinct> distinctByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hashCode');
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QDistinct>
      distinctByImpedance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'impedance');
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<CalendarWeight, CalendarWeight, QDistinct> distinctByWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weight');
    });
  }
}

extension CalendarWeightQueryProperty
    on QueryBuilder<CalendarWeight, CalendarWeight, QQueryProperty> {
  QueryBuilder<CalendarWeight, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CalendarWeight, int, QQueryOperations> dateIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateId');
    });
  }

  QueryBuilder<CalendarWeight, int, QQueryOperations> hashCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hashCode');
    });
  }

  QueryBuilder<CalendarWeight, int, QQueryOperations> impedanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'impedance');
    });
  }

  QueryBuilder<CalendarWeight, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<CalendarWeight, double, QQueryOperations> weightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weight');
    });
  }
}
