// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_shift.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCalendarShiftCollection on Isar {
  IsarCollection<CalendarShift> get calendarShifts => this.collection();
}

const CalendarShiftSchema = CollectionSchema(
  name: r'CalendarShift',
  id: -2645694456551399384,
  properties: {
    r'alarmTime': PropertySchema(
      id: 0,
      name: r'alarmTime',
      type: IsarType.dateTime,
    ),
    r'dateId': PropertySchema(
      id: 1,
      name: r'dateId',
      type: IsarType.long,
    ),
    r'hashCode': PropertySchema(
      id: 2,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'isAlarm': PropertySchema(
      id: 3,
      name: r'isAlarm',
      type: IsarType.bool,
    ),
    r'shiftConfigId': PropertySchema(
      id: 4,
      name: r'shiftConfigId',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 5,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _calendarShiftEstimateSize,
  serialize: _calendarShiftSerialize,
  deserialize: _calendarShiftDeserialize,
  deserializeProp: _calendarShiftDeserializeProp,
  idName: r'id',
  indexes: {
    r'dateId': IndexSchema(
      id: 6719847948176985255,
      name: r'dateId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'dateId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'isAlarm': IndexSchema(
      id: -4187901105435194983,
      name: r'isAlarm',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isAlarm',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'alarmTime': IndexSchema(
      id: -1608062101423484525,
      name: r'alarmTime',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'alarmTime',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _calendarShiftGetId,
  getLinks: _calendarShiftGetLinks,
  attach: _calendarShiftAttach,
  version: '3.1.0+1',
);

int _calendarShiftEstimateSize(
  CalendarShift object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _calendarShiftSerialize(
  CalendarShift object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.alarmTime);
  writer.writeLong(offsets[1], object.dateId);
  writer.writeLong(offsets[2], object.hashCode);
  writer.writeBool(offsets[3], object.isAlarm);
  writer.writeLong(offsets[4], object.shiftConfigId);
  writer.writeDateTime(offsets[5], object.updatedAt);
}

CalendarShift _calendarShiftDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CalendarShift();
  object.alarmTime = reader.readDateTimeOrNull(offsets[0]);
  object.dateId = reader.readLong(offsets[1]);
  object.id = id;
  object.isAlarm = reader.readBool(offsets[3]);
  object.shiftConfigId = reader.readLongOrNull(offsets[4]);
  object.updatedAt = reader.readDateTime(offsets[5]);
  return object;
}

P _calendarShiftDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _calendarShiftGetId(CalendarShift object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _calendarShiftGetLinks(CalendarShift object) {
  return [];
}

void _calendarShiftAttach(
    IsarCollection<dynamic> col, Id id, CalendarShift object) {
  object.id = id;
}

extension CalendarShiftByIndex on IsarCollection<CalendarShift> {
  Future<CalendarShift?> getByDateId(int dateId) {
    return getByIndex(r'dateId', [dateId]);
  }

  CalendarShift? getByDateIdSync(int dateId) {
    return getByIndexSync(r'dateId', [dateId]);
  }

  Future<bool> deleteByDateId(int dateId) {
    return deleteByIndex(r'dateId', [dateId]);
  }

  bool deleteByDateIdSync(int dateId) {
    return deleteByIndexSync(r'dateId', [dateId]);
  }

  Future<List<CalendarShift?>> getAllByDateId(List<int> dateIdValues) {
    final values = dateIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'dateId', values);
  }

  List<CalendarShift?> getAllByDateIdSync(List<int> dateIdValues) {
    final values = dateIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'dateId', values);
  }

  Future<int> deleteAllByDateId(List<int> dateIdValues) {
    final values = dateIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'dateId', values);
  }

  int deleteAllByDateIdSync(List<int> dateIdValues) {
    final values = dateIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'dateId', values);
  }

  Future<Id> putByDateId(CalendarShift object) {
    return putByIndex(r'dateId', object);
  }

  Id putByDateIdSync(CalendarShift object, {bool saveLinks = true}) {
    return putByIndexSync(r'dateId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDateId(List<CalendarShift> objects) {
    return putAllByIndex(r'dateId', objects);
  }

  List<Id> putAllByDateIdSync(List<CalendarShift> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'dateId', objects, saveLinks: saveLinks);
  }
}

extension CalendarShiftQueryWhereSort
    on QueryBuilder<CalendarShift, CalendarShift, QWhere> {
  QueryBuilder<CalendarShift, CalendarShift, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterWhere> anyDateId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'dateId'),
      );
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterWhere> anyIsAlarm() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isAlarm'),
      );
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterWhere> anyAlarmTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'alarmTime'),
      );
    });
  }
}

extension CalendarShiftQueryWhere
    on QueryBuilder<CalendarShift, CalendarShift, QWhereClause> {
  QueryBuilder<CalendarShift, CalendarShift, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<CalendarShift, CalendarShift, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterWhereClause> idBetween(
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

  QueryBuilder<CalendarShift, CalendarShift, QAfterWhereClause> dateIdEqualTo(
      int dateId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'dateId',
        value: [dateId],
      ));
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterWhereClause>
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

  QueryBuilder<CalendarShift, CalendarShift, QAfterWhereClause>
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

  QueryBuilder<CalendarShift, CalendarShift, QAfterWhereClause> dateIdLessThan(
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

  QueryBuilder<CalendarShift, CalendarShift, QAfterWhereClause> dateIdBetween(
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

  QueryBuilder<CalendarShift, CalendarShift, QAfterWhereClause> isAlarmEqualTo(
      bool isAlarm) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'isAlarm',
        value: [isAlarm],
      ));
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterWhereClause>
      isAlarmNotEqualTo(bool isAlarm) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isAlarm',
              lower: [],
              upper: [isAlarm],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isAlarm',
              lower: [isAlarm],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isAlarm',
              lower: [isAlarm],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isAlarm',
              lower: [],
              upper: [isAlarm],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterWhereClause>
      alarmTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'alarmTime',
        value: [null],
      ));
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterWhereClause>
      alarmTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'alarmTime',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterWhereClause>
      alarmTimeEqualTo(DateTime? alarmTime) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'alarmTime',
        value: [alarmTime],
      ));
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterWhereClause>
      alarmTimeNotEqualTo(DateTime? alarmTime) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'alarmTime',
              lower: [],
              upper: [alarmTime],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'alarmTime',
              lower: [alarmTime],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'alarmTime',
              lower: [alarmTime],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'alarmTime',
              lower: [],
              upper: [alarmTime],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterWhereClause>
      alarmTimeGreaterThan(
    DateTime? alarmTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'alarmTime',
        lower: [alarmTime],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterWhereClause>
      alarmTimeLessThan(
    DateTime? alarmTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'alarmTime',
        lower: [],
        upper: [alarmTime],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterWhereClause>
      alarmTimeBetween(
    DateTime? lowerAlarmTime,
    DateTime? upperAlarmTime, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'alarmTime',
        lower: [lowerAlarmTime],
        includeLower: includeLower,
        upper: [upperAlarmTime],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CalendarShiftQueryFilter
    on QueryBuilder<CalendarShift, CalendarShift, QFilterCondition> {
  QueryBuilder<CalendarShift, CalendarShift, QAfterFilterCondition>
      alarmTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'alarmTime',
      ));
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterFilterCondition>
      alarmTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'alarmTime',
      ));
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterFilterCondition>
      alarmTimeEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'alarmTime',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterFilterCondition>
      alarmTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'alarmTime',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterFilterCondition>
      alarmTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'alarmTime',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterFilterCondition>
      alarmTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'alarmTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterFilterCondition>
      dateIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateId',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterFilterCondition>
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

  QueryBuilder<CalendarShift, CalendarShift, QAfterFilterCondition>
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

  QueryBuilder<CalendarShift, CalendarShift, QAfterFilterCondition>
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

  QueryBuilder<CalendarShift, CalendarShift, QAfterFilterCondition>
      hashCodeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterFilterCondition>
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

  QueryBuilder<CalendarShift, CalendarShift, QAfterFilterCondition>
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

  QueryBuilder<CalendarShift, CalendarShift, QAfterFilterCondition>
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

  QueryBuilder<CalendarShift, CalendarShift, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterFilterCondition>
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

  QueryBuilder<CalendarShift, CalendarShift, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<CalendarShift, CalendarShift, QAfterFilterCondition> idBetween(
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

  QueryBuilder<CalendarShift, CalendarShift, QAfterFilterCondition>
      isAlarmEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isAlarm',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterFilterCondition>
      shiftConfigIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'shiftConfigId',
      ));
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterFilterCondition>
      shiftConfigIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'shiftConfigId',
      ));
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterFilterCondition>
      shiftConfigIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shiftConfigId',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterFilterCondition>
      shiftConfigIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'shiftConfigId',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterFilterCondition>
      shiftConfigIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'shiftConfigId',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterFilterCondition>
      shiftConfigIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'shiftConfigId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterFilterCondition>
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

  QueryBuilder<CalendarShift, CalendarShift, QAfterFilterCondition>
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

  QueryBuilder<CalendarShift, CalendarShift, QAfterFilterCondition>
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
}

extension CalendarShiftQueryObject
    on QueryBuilder<CalendarShift, CalendarShift, QFilterCondition> {}

extension CalendarShiftQueryLinks
    on QueryBuilder<CalendarShift, CalendarShift, QFilterCondition> {}

extension CalendarShiftQuerySortBy
    on QueryBuilder<CalendarShift, CalendarShift, QSortBy> {
  QueryBuilder<CalendarShift, CalendarShift, QAfterSortBy> sortByAlarmTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alarmTime', Sort.asc);
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterSortBy>
      sortByAlarmTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alarmTime', Sort.desc);
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterSortBy> sortByDateId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateId', Sort.asc);
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterSortBy> sortByDateIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateId', Sort.desc);
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterSortBy> sortByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterSortBy>
      sortByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterSortBy> sortByIsAlarm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAlarm', Sort.asc);
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterSortBy> sortByIsAlarmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAlarm', Sort.desc);
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterSortBy>
      sortByShiftConfigId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shiftConfigId', Sort.asc);
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterSortBy>
      sortByShiftConfigIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shiftConfigId', Sort.desc);
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension CalendarShiftQuerySortThenBy
    on QueryBuilder<CalendarShift, CalendarShift, QSortThenBy> {
  QueryBuilder<CalendarShift, CalendarShift, QAfterSortBy> thenByAlarmTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alarmTime', Sort.asc);
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterSortBy>
      thenByAlarmTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alarmTime', Sort.desc);
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterSortBy> thenByDateId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateId', Sort.asc);
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterSortBy> thenByDateIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateId', Sort.desc);
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterSortBy> thenByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterSortBy>
      thenByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterSortBy> thenByIsAlarm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAlarm', Sort.asc);
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterSortBy> thenByIsAlarmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAlarm', Sort.desc);
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterSortBy>
      thenByShiftConfigId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shiftConfigId', Sort.asc);
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterSortBy>
      thenByShiftConfigIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shiftConfigId', Sort.desc);
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension CalendarShiftQueryWhereDistinct
    on QueryBuilder<CalendarShift, CalendarShift, QDistinct> {
  QueryBuilder<CalendarShift, CalendarShift, QDistinct> distinctByAlarmTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'alarmTime');
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QDistinct> distinctByDateId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateId');
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QDistinct> distinctByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hashCode');
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QDistinct> distinctByIsAlarm() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isAlarm');
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QDistinct>
      distinctByShiftConfigId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shiftConfigId');
    });
  }

  QueryBuilder<CalendarShift, CalendarShift, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension CalendarShiftQueryProperty
    on QueryBuilder<CalendarShift, CalendarShift, QQueryProperty> {
  QueryBuilder<CalendarShift, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CalendarShift, DateTime?, QQueryOperations> alarmTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'alarmTime');
    });
  }

  QueryBuilder<CalendarShift, int, QQueryOperations> dateIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateId');
    });
  }

  QueryBuilder<CalendarShift, int, QQueryOperations> hashCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hashCode');
    });
  }

  QueryBuilder<CalendarShift, bool, QQueryOperations> isAlarmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isAlarm');
    });
  }

  QueryBuilder<CalendarShift, int?, QQueryOperations> shiftConfigIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shiftConfigId');
    });
  }

  QueryBuilder<CalendarShift, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
