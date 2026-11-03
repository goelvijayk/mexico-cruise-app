// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TripTableTable extends TripTable
    with TableInfo<$TripTableTable, TripTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TripTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shipTimeZoneMeta = const VerificationMeta(
    'shipTimeZone',
  );
  @override
  late final GeneratedColumn<String> shipTimeZone = GeneratedColumn<String>(
    'ship_time_zone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _homeTimeZoneMeta = const VerificationMeta(
    'homeTimeZone',
  );
  @override
  late final GeneratedColumn<String> homeTimeZone = GeneratedColumn<String>(
    'home_time_zone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultCurrencyMeta = const VerificationMeta(
    'defaultCurrency',
  );
  @override
  late final GeneratedColumn<String> defaultCurrency = GeneratedColumn<String>(
    'default_currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('USD'),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    startDate,
    endDate,
    shipTimeZone,
    homeTimeZone,
    defaultCurrency,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trip_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TripTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('ship_time_zone')) {
      context.handle(
        _shipTimeZoneMeta,
        shipTimeZone.isAcceptableOrUnknown(
          data['ship_time_zone']!,
          _shipTimeZoneMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_shipTimeZoneMeta);
    }
    if (data.containsKey('home_time_zone')) {
      context.handle(
        _homeTimeZoneMeta,
        homeTimeZone.isAcceptableOrUnknown(
          data['home_time_zone']!,
          _homeTimeZoneMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_homeTimeZoneMeta);
    }
    if (data.containsKey('default_currency')) {
      context.handle(
        _defaultCurrencyMeta,
        defaultCurrency.isAcceptableOrUnknown(
          data['default_currency']!,
          _defaultCurrencyMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TripTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TripTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
      shipTimeZone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ship_time_zone'],
      )!,
      homeTimeZone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}home_time_zone'],
      )!,
      defaultCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_currency'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TripTableTable createAlias(String alias) {
    return $TripTableTable(attachedDatabase, alias);
  }
}

class TripTableData extends DataClass implements Insertable<TripTableData> {
  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final String shipTimeZone;
  final String homeTimeZone;
  final String defaultCurrency;
  final DateTime updatedAt;
  const TripTableData({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.shipTimeZone,
    required this.homeTimeZone,
    required this.defaultCurrency,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['ship_time_zone'] = Variable<String>(shipTimeZone);
    map['home_time_zone'] = Variable<String>(homeTimeZone);
    map['default_currency'] = Variable<String>(defaultCurrency);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TripTableCompanion toCompanion(bool nullToAbsent) {
    return TripTableCompanion(
      id: Value(id),
      name: Value(name),
      startDate: Value(startDate),
      endDate: Value(endDate),
      shipTimeZone: Value(shipTimeZone),
      homeTimeZone: Value(homeTimeZone),
      defaultCurrency: Value(defaultCurrency),
      updatedAt: Value(updatedAt),
    );
  }

  factory TripTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TripTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      shipTimeZone: serializer.fromJson<String>(json['shipTimeZone']),
      homeTimeZone: serializer.fromJson<String>(json['homeTimeZone']),
      defaultCurrency: serializer.fromJson<String>(json['defaultCurrency']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'shipTimeZone': serializer.toJson<String>(shipTimeZone),
      'homeTimeZone': serializer.toJson<String>(homeTimeZone),
      'defaultCurrency': serializer.toJson<String>(defaultCurrency),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TripTableData copyWith({
    String? id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    String? shipTimeZone,
    String? homeTimeZone,
    String? defaultCurrency,
    DateTime? updatedAt,
  }) => TripTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    shipTimeZone: shipTimeZone ?? this.shipTimeZone,
    homeTimeZone: homeTimeZone ?? this.homeTimeZone,
    defaultCurrency: defaultCurrency ?? this.defaultCurrency,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TripTableData copyWithCompanion(TripTableCompanion data) {
    return TripTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      shipTimeZone: data.shipTimeZone.present
          ? data.shipTimeZone.value
          : this.shipTimeZone,
      homeTimeZone: data.homeTimeZone.present
          ? data.homeTimeZone.value
          : this.homeTimeZone,
      defaultCurrency: data.defaultCurrency.present
          ? data.defaultCurrency.value
          : this.defaultCurrency,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TripTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('shipTimeZone: $shipTimeZone, ')
          ..write('homeTimeZone: $homeTimeZone, ')
          ..write('defaultCurrency: $defaultCurrency, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    startDate,
    endDate,
    shipTimeZone,
    homeTimeZone,
    defaultCurrency,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TripTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.shipTimeZone == this.shipTimeZone &&
          other.homeTimeZone == this.homeTimeZone &&
          other.defaultCurrency == this.defaultCurrency &&
          other.updatedAt == this.updatedAt);
}

class TripTableCompanion extends UpdateCompanion<TripTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<String> shipTimeZone;
  final Value<String> homeTimeZone;
  final Value<String> defaultCurrency;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TripTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.shipTimeZone = const Value.absent(),
    this.homeTimeZone = const Value.absent(),
    this.defaultCurrency = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TripTableCompanion.insert({
    required String id,
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    required String shipTimeZone,
    required String homeTimeZone,
    this.defaultCurrency = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       startDate = Value(startDate),
       endDate = Value(endDate),
       shipTimeZone = Value(shipTimeZone),
       homeTimeZone = Value(homeTimeZone),
       updatedAt = Value(updatedAt);
  static Insertable<TripTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? shipTimeZone,
    Expression<String>? homeTimeZone,
    Expression<String>? defaultCurrency,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (shipTimeZone != null) 'ship_time_zone': shipTimeZone,
      if (homeTimeZone != null) 'home_time_zone': homeTimeZone,
      if (defaultCurrency != null) 'default_currency': defaultCurrency,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TripTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<String>? shipTimeZone,
    Value<String>? homeTimeZone,
    Value<String>? defaultCurrency,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TripTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      shipTimeZone: shipTimeZone ?? this.shipTimeZone,
      homeTimeZone: homeTimeZone ?? this.homeTimeZone,
      defaultCurrency: defaultCurrency ?? this.defaultCurrency,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (shipTimeZone.present) {
      map['ship_time_zone'] = Variable<String>(shipTimeZone.value);
    }
    if (homeTimeZone.present) {
      map['home_time_zone'] = Variable<String>(homeTimeZone.value);
    }
    if (defaultCurrency.present) {
      map['default_currency'] = Variable<String>(defaultCurrency.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TripTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('shipTimeZone: $shipTimeZone, ')
          ..write('homeTimeZone: $homeTimeZone, ')
          ..write('defaultCurrency: $defaultCurrency, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EventsTable extends Events with TableInfo<$EventsTable, Event> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<String> tripId = GeneratedColumn<String>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('confirmed'),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startLocalMeta = const VerificationMeta(
    'startLocal',
  );
  @override
  late final GeneratedColumn<DateTime> startLocal = GeneratedColumn<DateTime>(
    'start_local',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTzMeta = const VerificationMeta(
    'startTz',
  );
  @override
  late final GeneratedColumn<String> startTz = GeneratedColumn<String>(
    'start_tz',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endLocalMeta = const VerificationMeta(
    'endLocal',
  );
  @override
  late final GeneratedColumn<DateTime> endLocal = GeneratedColumn<DateTime>(
    'end_local',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endTzMeta = const VerificationMeta('endTz');
  @override
  late final GeneratedColumn<String> endTz = GeneratedColumn<String>(
    'end_tz',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _allDayMeta = const VerificationMeta('allDay');
  @override
  late final GeneratedColumn<bool> allDay = GeneratedColumn<bool>(
    'all_day',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("all_day" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _locationJsonMeta = const VerificationMeta(
    'locationJson',
  );
  @override
  late final GeneratedColumn<String> locationJson = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _providerMeta = const VerificationMeta(
    'provider',
  );
  @override
  late final GeneratedColumn<String> provider = GeneratedColumn<String>(
    'provider',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bookingRefMeta = const VerificationMeta(
    'bookingRef',
  );
  @override
  late final GeneratedColumn<String> bookingRef = GeneratedColumn<String>(
    'booking_ref',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _detailsJsonMeta = const VerificationMeta(
    'detailsJson',
  );
  @override
  late final GeneratedColumn<String> detailsJson = GeneratedColumn<String>(
    'details',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _travelersJsonMeta = const VerificationMeta(
    'travelersJson',
  );
  @override
  late final GeneratedColumn<String> travelersJson = GeneratedColumn<String>(
    'travelers',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _costJsonMeta = const VerificationMeta(
    'costJson',
  );
  @override
  late final GeneratedColumn<String> costJson = GeneratedColumn<String>(
    'cost',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceJsonMeta = const VerificationMeta(
    'sourceJson',
  );
  @override
  late final GeneratedColumn<String> sourceJson = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reviewStateMeta = const VerificationMeta(
    'reviewState',
  );
  @override
  late final GeneratedColumn<String> reviewState = GeneratedColumn<String>(
    'review_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('none'),
  );
  static const VerificationMeta _editedFieldsJsonMeta = const VerificationMeta(
    'editedFieldsJson',
  );
  @override
  late final GeneratedColumn<String> editedFieldsJson = GeneratedColumn<String>(
    'edited_fields',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _fieldMetaJsonMeta = const VerificationMeta(
    'fieldMetaJson',
  );
  @override
  late final GeneratedColumn<String> fieldMetaJson = GeneratedColumn<String>(
    'field_meta',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tripId,
    type,
    status,
    title,
    startLocal,
    startTz,
    endLocal,
    endTz,
    allDay,
    locationJson,
    provider,
    bookingRef,
    detailsJson,
    travelersJson,
    costJson,
    notes,
    sourceJson,
    reviewState,
    editedFieldsJson,
    fieldMetaJson,
    createdAt,
    createdBy,
    updatedAt,
    updatedBy,
    deletedAt,
    dirty,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'events';
  @override
  VerificationContext validateIntegrity(
    Insertable<Event> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('start_local')) {
      context.handle(
        _startLocalMeta,
        startLocal.isAcceptableOrUnknown(data['start_local']!, _startLocalMeta),
      );
    } else if (isInserting) {
      context.missing(_startLocalMeta);
    }
    if (data.containsKey('start_tz')) {
      context.handle(
        _startTzMeta,
        startTz.isAcceptableOrUnknown(data['start_tz']!, _startTzMeta),
      );
    } else if (isInserting) {
      context.missing(_startTzMeta);
    }
    if (data.containsKey('end_local')) {
      context.handle(
        _endLocalMeta,
        endLocal.isAcceptableOrUnknown(data['end_local']!, _endLocalMeta),
      );
    }
    if (data.containsKey('end_tz')) {
      context.handle(
        _endTzMeta,
        endTz.isAcceptableOrUnknown(data['end_tz']!, _endTzMeta),
      );
    }
    if (data.containsKey('all_day')) {
      context.handle(
        _allDayMeta,
        allDay.isAcceptableOrUnknown(data['all_day']!, _allDayMeta),
      );
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationJsonMeta,
        locationJson.isAcceptableOrUnknown(
          data['location']!,
          _locationJsonMeta,
        ),
      );
    }
    if (data.containsKey('provider')) {
      context.handle(
        _providerMeta,
        provider.isAcceptableOrUnknown(data['provider']!, _providerMeta),
      );
    }
    if (data.containsKey('booking_ref')) {
      context.handle(
        _bookingRefMeta,
        bookingRef.isAcceptableOrUnknown(data['booking_ref']!, _bookingRefMeta),
      );
    }
    if (data.containsKey('details')) {
      context.handle(
        _detailsJsonMeta,
        detailsJson.isAcceptableOrUnknown(data['details']!, _detailsJsonMeta),
      );
    }
    if (data.containsKey('travelers')) {
      context.handle(
        _travelersJsonMeta,
        travelersJson.isAcceptableOrUnknown(
          data['travelers']!,
          _travelersJsonMeta,
        ),
      );
    }
    if (data.containsKey('cost')) {
      context.handle(
        _costJsonMeta,
        costJson.isAcceptableOrUnknown(data['cost']!, _costJsonMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceJsonMeta,
        sourceJson.isAcceptableOrUnknown(data['source']!, _sourceJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceJsonMeta);
    }
    if (data.containsKey('review_state')) {
      context.handle(
        _reviewStateMeta,
        reviewState.isAcceptableOrUnknown(
          data['review_state']!,
          _reviewStateMeta,
        ),
      );
    }
    if (data.containsKey('edited_fields')) {
      context.handle(
        _editedFieldsJsonMeta,
        editedFieldsJson.isAcceptableOrUnknown(
          data['edited_fields']!,
          _editedFieldsJsonMeta,
        ),
      );
    }
    if (data.containsKey('field_meta')) {
      context.handle(
        _fieldMetaJsonMeta,
        fieldMetaJson.isAcceptableOrUnknown(
          data['field_meta']!,
          _fieldMetaJsonMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Event map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Event(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      startLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_local'],
      )!,
      startTz: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_tz'],
      )!,
      endLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_local'],
      ),
      endTz: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_tz'],
      ),
      allDay: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}all_day'],
      )!,
      locationJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      provider: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider'],
      ),
      bookingRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}booking_ref'],
      ),
      detailsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}details'],
      ),
      travelersJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}travelers'],
      ),
      costJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cost'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      sourceJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      reviewState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}review_state'],
      )!,
      editedFieldsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}edited_fields'],
      )!,
      fieldMetaJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}field_meta'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
    );
  }

  @override
  $EventsTable createAlias(String alias) {
    return $EventsTable(attachedDatabase, alias);
  }
}

class Event extends DataClass implements Insertable<Event> {
  final String id;
  final String tripId;
  final String type;
  final String status;
  final String title;
  final DateTime startLocal;
  final String startTz;
  final DateTime? endLocal;
  final String? endTz;
  final bool allDay;
  final String? locationJson;
  final String? provider;
  final String? bookingRef;
  final String? detailsJson;
  final String? travelersJson;
  final String? costJson;
  final String? notes;
  final String sourceJson;
  final String reviewState;
  final String editedFieldsJson;
  final String fieldMetaJson;
  final DateTime createdAt;
  final String createdBy;
  final DateTime updatedAt;
  final String updatedBy;
  final DateTime? deletedAt;
  final bool dirty;
  const Event({
    required this.id,
    required this.tripId,
    required this.type,
    required this.status,
    required this.title,
    required this.startLocal,
    required this.startTz,
    this.endLocal,
    this.endTz,
    required this.allDay,
    this.locationJson,
    this.provider,
    this.bookingRef,
    this.detailsJson,
    this.travelersJson,
    this.costJson,
    this.notes,
    required this.sourceJson,
    required this.reviewState,
    required this.editedFieldsJson,
    required this.fieldMetaJson,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    this.deletedAt,
    required this.dirty,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['trip_id'] = Variable<String>(tripId);
    map['type'] = Variable<String>(type);
    map['status'] = Variable<String>(status);
    map['title'] = Variable<String>(title);
    map['start_local'] = Variable<DateTime>(startLocal);
    map['start_tz'] = Variable<String>(startTz);
    if (!nullToAbsent || endLocal != null) {
      map['end_local'] = Variable<DateTime>(endLocal);
    }
    if (!nullToAbsent || endTz != null) {
      map['end_tz'] = Variable<String>(endTz);
    }
    map['all_day'] = Variable<bool>(allDay);
    if (!nullToAbsent || locationJson != null) {
      map['location'] = Variable<String>(locationJson);
    }
    if (!nullToAbsent || provider != null) {
      map['provider'] = Variable<String>(provider);
    }
    if (!nullToAbsent || bookingRef != null) {
      map['booking_ref'] = Variable<String>(bookingRef);
    }
    if (!nullToAbsent || detailsJson != null) {
      map['details'] = Variable<String>(detailsJson);
    }
    if (!nullToAbsent || travelersJson != null) {
      map['travelers'] = Variable<String>(travelersJson);
    }
    if (!nullToAbsent || costJson != null) {
      map['cost'] = Variable<String>(costJson);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['source'] = Variable<String>(sourceJson);
    map['review_state'] = Variable<String>(reviewState);
    map['edited_fields'] = Variable<String>(editedFieldsJson);
    map['field_meta'] = Variable<String>(fieldMetaJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<String>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<String>(updatedBy);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['dirty'] = Variable<bool>(dirty);
    return map;
  }

  EventsCompanion toCompanion(bool nullToAbsent) {
    return EventsCompanion(
      id: Value(id),
      tripId: Value(tripId),
      type: Value(type),
      status: Value(status),
      title: Value(title),
      startLocal: Value(startLocal),
      startTz: Value(startTz),
      endLocal: endLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(endLocal),
      endTz: endTz == null && nullToAbsent
          ? const Value.absent()
          : Value(endTz),
      allDay: Value(allDay),
      locationJson: locationJson == null && nullToAbsent
          ? const Value.absent()
          : Value(locationJson),
      provider: provider == null && nullToAbsent
          ? const Value.absent()
          : Value(provider),
      bookingRef: bookingRef == null && nullToAbsent
          ? const Value.absent()
          : Value(bookingRef),
      detailsJson: detailsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(detailsJson),
      travelersJson: travelersJson == null && nullToAbsent
          ? const Value.absent()
          : Value(travelersJson),
      costJson: costJson == null && nullToAbsent
          ? const Value.absent()
          : Value(costJson),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      sourceJson: Value(sourceJson),
      reviewState: Value(reviewState),
      editedFieldsJson: Value(editedFieldsJson),
      fieldMetaJson: Value(fieldMetaJson),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      dirty: Value(dirty),
    );
  }

  factory Event.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Event(
      id: serializer.fromJson<String>(json['id']),
      tripId: serializer.fromJson<String>(json['tripId']),
      type: serializer.fromJson<String>(json['type']),
      status: serializer.fromJson<String>(json['status']),
      title: serializer.fromJson<String>(json['title']),
      startLocal: serializer.fromJson<DateTime>(json['startLocal']),
      startTz: serializer.fromJson<String>(json['startTz']),
      endLocal: serializer.fromJson<DateTime?>(json['endLocal']),
      endTz: serializer.fromJson<String?>(json['endTz']),
      allDay: serializer.fromJson<bool>(json['allDay']),
      locationJson: serializer.fromJson<String?>(json['locationJson']),
      provider: serializer.fromJson<String?>(json['provider']),
      bookingRef: serializer.fromJson<String?>(json['bookingRef']),
      detailsJson: serializer.fromJson<String?>(json['detailsJson']),
      travelersJson: serializer.fromJson<String?>(json['travelersJson']),
      costJson: serializer.fromJson<String?>(json['costJson']),
      notes: serializer.fromJson<String?>(json['notes']),
      sourceJson: serializer.fromJson<String>(json['sourceJson']),
      reviewState: serializer.fromJson<String>(json['reviewState']),
      editedFieldsJson: serializer.fromJson<String>(json['editedFieldsJson']),
      fieldMetaJson: serializer.fromJson<String>(json['fieldMetaJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      updatedBy: serializer.fromJson<String>(json['updatedBy']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      dirty: serializer.fromJson<bool>(json['dirty']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tripId': serializer.toJson<String>(tripId),
      'type': serializer.toJson<String>(type),
      'status': serializer.toJson<String>(status),
      'title': serializer.toJson<String>(title),
      'startLocal': serializer.toJson<DateTime>(startLocal),
      'startTz': serializer.toJson<String>(startTz),
      'endLocal': serializer.toJson<DateTime?>(endLocal),
      'endTz': serializer.toJson<String?>(endTz),
      'allDay': serializer.toJson<bool>(allDay),
      'locationJson': serializer.toJson<String?>(locationJson),
      'provider': serializer.toJson<String?>(provider),
      'bookingRef': serializer.toJson<String?>(bookingRef),
      'detailsJson': serializer.toJson<String?>(detailsJson),
      'travelersJson': serializer.toJson<String?>(travelersJson),
      'costJson': serializer.toJson<String?>(costJson),
      'notes': serializer.toJson<String?>(notes),
      'sourceJson': serializer.toJson<String>(sourceJson),
      'reviewState': serializer.toJson<String>(reviewState),
      'editedFieldsJson': serializer.toJson<String>(editedFieldsJson),
      'fieldMetaJson': serializer.toJson<String>(fieldMetaJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'createdBy': serializer.toJson<String>(createdBy),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'updatedBy': serializer.toJson<String>(updatedBy),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'dirty': serializer.toJson<bool>(dirty),
    };
  }

  Event copyWith({
    String? id,
    String? tripId,
    String? type,
    String? status,
    String? title,
    DateTime? startLocal,
    String? startTz,
    Value<DateTime?> endLocal = const Value.absent(),
    Value<String?> endTz = const Value.absent(),
    bool? allDay,
    Value<String?> locationJson = const Value.absent(),
    Value<String?> provider = const Value.absent(),
    Value<String?> bookingRef = const Value.absent(),
    Value<String?> detailsJson = const Value.absent(),
    Value<String?> travelersJson = const Value.absent(),
    Value<String?> costJson = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    String? sourceJson,
    String? reviewState,
    String? editedFieldsJson,
    String? fieldMetaJson,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
    Value<DateTime?> deletedAt = const Value.absent(),
    bool? dirty,
  }) => Event(
    id: id ?? this.id,
    tripId: tripId ?? this.tripId,
    type: type ?? this.type,
    status: status ?? this.status,
    title: title ?? this.title,
    startLocal: startLocal ?? this.startLocal,
    startTz: startTz ?? this.startTz,
    endLocal: endLocal.present ? endLocal.value : this.endLocal,
    endTz: endTz.present ? endTz.value : this.endTz,
    allDay: allDay ?? this.allDay,
    locationJson: locationJson.present ? locationJson.value : this.locationJson,
    provider: provider.present ? provider.value : this.provider,
    bookingRef: bookingRef.present ? bookingRef.value : this.bookingRef,
    detailsJson: detailsJson.present ? detailsJson.value : this.detailsJson,
    travelersJson: travelersJson.present
        ? travelersJson.value
        : this.travelersJson,
    costJson: costJson.present ? costJson.value : this.costJson,
    notes: notes.present ? notes.value : this.notes,
    sourceJson: sourceJson ?? this.sourceJson,
    reviewState: reviewState ?? this.reviewState,
    editedFieldsJson: editedFieldsJson ?? this.editedFieldsJson,
    fieldMetaJson: fieldMetaJson ?? this.fieldMetaJson,
    createdAt: createdAt ?? this.createdAt,
    createdBy: createdBy ?? this.createdBy,
    updatedAt: updatedAt ?? this.updatedAt,
    updatedBy: updatedBy ?? this.updatedBy,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    dirty: dirty ?? this.dirty,
  );
  Event copyWithCompanion(EventsCompanion data) {
    return Event(
      id: data.id.present ? data.id.value : this.id,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      type: data.type.present ? data.type.value : this.type,
      status: data.status.present ? data.status.value : this.status,
      title: data.title.present ? data.title.value : this.title,
      startLocal: data.startLocal.present
          ? data.startLocal.value
          : this.startLocal,
      startTz: data.startTz.present ? data.startTz.value : this.startTz,
      endLocal: data.endLocal.present ? data.endLocal.value : this.endLocal,
      endTz: data.endTz.present ? data.endTz.value : this.endTz,
      allDay: data.allDay.present ? data.allDay.value : this.allDay,
      locationJson: data.locationJson.present
          ? data.locationJson.value
          : this.locationJson,
      provider: data.provider.present ? data.provider.value : this.provider,
      bookingRef: data.bookingRef.present
          ? data.bookingRef.value
          : this.bookingRef,
      detailsJson: data.detailsJson.present
          ? data.detailsJson.value
          : this.detailsJson,
      travelersJson: data.travelersJson.present
          ? data.travelersJson.value
          : this.travelersJson,
      costJson: data.costJson.present ? data.costJson.value : this.costJson,
      notes: data.notes.present ? data.notes.value : this.notes,
      sourceJson: data.sourceJson.present
          ? data.sourceJson.value
          : this.sourceJson,
      reviewState: data.reviewState.present
          ? data.reviewState.value
          : this.reviewState,
      editedFieldsJson: data.editedFieldsJson.present
          ? data.editedFieldsJson.value
          : this.editedFieldsJson,
      fieldMetaJson: data.fieldMetaJson.present
          ? data.fieldMetaJson.value
          : this.fieldMetaJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Event(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('title: $title, ')
          ..write('startLocal: $startLocal, ')
          ..write('startTz: $startTz, ')
          ..write('endLocal: $endLocal, ')
          ..write('endTz: $endTz, ')
          ..write('allDay: $allDay, ')
          ..write('locationJson: $locationJson, ')
          ..write('provider: $provider, ')
          ..write('bookingRef: $bookingRef, ')
          ..write('detailsJson: $detailsJson, ')
          ..write('travelersJson: $travelersJson, ')
          ..write('costJson: $costJson, ')
          ..write('notes: $notes, ')
          ..write('sourceJson: $sourceJson, ')
          ..write('reviewState: $reviewState, ')
          ..write('editedFieldsJson: $editedFieldsJson, ')
          ..write('fieldMetaJson: $fieldMetaJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('dirty: $dirty')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    tripId,
    type,
    status,
    title,
    startLocal,
    startTz,
    endLocal,
    endTz,
    allDay,
    locationJson,
    provider,
    bookingRef,
    detailsJson,
    travelersJson,
    costJson,
    notes,
    sourceJson,
    reviewState,
    editedFieldsJson,
    fieldMetaJson,
    createdAt,
    createdBy,
    updatedAt,
    updatedBy,
    deletedAt,
    dirty,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Event &&
          other.id == this.id &&
          other.tripId == this.tripId &&
          other.type == this.type &&
          other.status == this.status &&
          other.title == this.title &&
          other.startLocal == this.startLocal &&
          other.startTz == this.startTz &&
          other.endLocal == this.endLocal &&
          other.endTz == this.endTz &&
          other.allDay == this.allDay &&
          other.locationJson == this.locationJson &&
          other.provider == this.provider &&
          other.bookingRef == this.bookingRef &&
          other.detailsJson == this.detailsJson &&
          other.travelersJson == this.travelersJson &&
          other.costJson == this.costJson &&
          other.notes == this.notes &&
          other.sourceJson == this.sourceJson &&
          other.reviewState == this.reviewState &&
          other.editedFieldsJson == this.editedFieldsJson &&
          other.fieldMetaJson == this.fieldMetaJson &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.deletedAt == this.deletedAt &&
          other.dirty == this.dirty);
}

class EventsCompanion extends UpdateCompanion<Event> {
  final Value<String> id;
  final Value<String> tripId;
  final Value<String> type;
  final Value<String> status;
  final Value<String> title;
  final Value<DateTime> startLocal;
  final Value<String> startTz;
  final Value<DateTime?> endLocal;
  final Value<String?> endTz;
  final Value<bool> allDay;
  final Value<String?> locationJson;
  final Value<String?> provider;
  final Value<String?> bookingRef;
  final Value<String?> detailsJson;
  final Value<String?> travelersJson;
  final Value<String?> costJson;
  final Value<String?> notes;
  final Value<String> sourceJson;
  final Value<String> reviewState;
  final Value<String> editedFieldsJson;
  final Value<String> fieldMetaJson;
  final Value<DateTime> createdAt;
  final Value<String> createdBy;
  final Value<DateTime> updatedAt;
  final Value<String> updatedBy;
  final Value<DateTime?> deletedAt;
  final Value<bool> dirty;
  final Value<int> rowid;
  const EventsCompanion({
    this.id = const Value.absent(),
    this.tripId = const Value.absent(),
    this.type = const Value.absent(),
    this.status = const Value.absent(),
    this.title = const Value.absent(),
    this.startLocal = const Value.absent(),
    this.startTz = const Value.absent(),
    this.endLocal = const Value.absent(),
    this.endTz = const Value.absent(),
    this.allDay = const Value.absent(),
    this.locationJson = const Value.absent(),
    this.provider = const Value.absent(),
    this.bookingRef = const Value.absent(),
    this.detailsJson = const Value.absent(),
    this.travelersJson = const Value.absent(),
    this.costJson = const Value.absent(),
    this.notes = const Value.absent(),
    this.sourceJson = const Value.absent(),
    this.reviewState = const Value.absent(),
    this.editedFieldsJson = const Value.absent(),
    this.fieldMetaJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EventsCompanion.insert({
    required String id,
    required String tripId,
    required String type,
    this.status = const Value.absent(),
    required String title,
    required DateTime startLocal,
    required String startTz,
    this.endLocal = const Value.absent(),
    this.endTz = const Value.absent(),
    this.allDay = const Value.absent(),
    this.locationJson = const Value.absent(),
    this.provider = const Value.absent(),
    this.bookingRef = const Value.absent(),
    this.detailsJson = const Value.absent(),
    this.travelersJson = const Value.absent(),
    this.costJson = const Value.absent(),
    this.notes = const Value.absent(),
    required String sourceJson,
    this.reviewState = const Value.absent(),
    this.editedFieldsJson = const Value.absent(),
    this.fieldMetaJson = const Value.absent(),
    required DateTime createdAt,
    required String createdBy,
    required DateTime updatedAt,
    required String updatedBy,
    this.deletedAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tripId = Value(tripId),
       type = Value(type),
       title = Value(title),
       startLocal = Value(startLocal),
       startTz = Value(startTz),
       sourceJson = Value(sourceJson),
       createdAt = Value(createdAt),
       createdBy = Value(createdBy),
       updatedAt = Value(updatedAt),
       updatedBy = Value(updatedBy);
  static Insertable<Event> custom({
    Expression<String>? id,
    Expression<String>? tripId,
    Expression<String>? type,
    Expression<String>? status,
    Expression<String>? title,
    Expression<DateTime>? startLocal,
    Expression<String>? startTz,
    Expression<DateTime>? endLocal,
    Expression<String>? endTz,
    Expression<bool>? allDay,
    Expression<String>? locationJson,
    Expression<String>? provider,
    Expression<String>? bookingRef,
    Expression<String>? detailsJson,
    Expression<String>? travelersJson,
    Expression<String>? costJson,
    Expression<String>? notes,
    Expression<String>? sourceJson,
    Expression<String>? reviewState,
    Expression<String>? editedFieldsJson,
    Expression<String>? fieldMetaJson,
    Expression<DateTime>? createdAt,
    Expression<String>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<String>? updatedBy,
    Expression<DateTime>? deletedAt,
    Expression<bool>? dirty,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tripId != null) 'trip_id': tripId,
      if (type != null) 'type': type,
      if (status != null) 'status': status,
      if (title != null) 'title': title,
      if (startLocal != null) 'start_local': startLocal,
      if (startTz != null) 'start_tz': startTz,
      if (endLocal != null) 'end_local': endLocal,
      if (endTz != null) 'end_tz': endTz,
      if (allDay != null) 'all_day': allDay,
      if (locationJson != null) 'location': locationJson,
      if (provider != null) 'provider': provider,
      if (bookingRef != null) 'booking_ref': bookingRef,
      if (detailsJson != null) 'details': detailsJson,
      if (travelersJson != null) 'travelers': travelersJson,
      if (costJson != null) 'cost': costJson,
      if (notes != null) 'notes': notes,
      if (sourceJson != null) 'source': sourceJson,
      if (reviewState != null) 'review_state': reviewState,
      if (editedFieldsJson != null) 'edited_fields': editedFieldsJson,
      if (fieldMetaJson != null) 'field_meta': fieldMetaJson,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (dirty != null) 'dirty': dirty,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EventsCompanion copyWith({
    Value<String>? id,
    Value<String>? tripId,
    Value<String>? type,
    Value<String>? status,
    Value<String>? title,
    Value<DateTime>? startLocal,
    Value<String>? startTz,
    Value<DateTime?>? endLocal,
    Value<String?>? endTz,
    Value<bool>? allDay,
    Value<String?>? locationJson,
    Value<String?>? provider,
    Value<String?>? bookingRef,
    Value<String?>? detailsJson,
    Value<String?>? travelersJson,
    Value<String?>? costJson,
    Value<String?>? notes,
    Value<String>? sourceJson,
    Value<String>? reviewState,
    Value<String>? editedFieldsJson,
    Value<String>? fieldMetaJson,
    Value<DateTime>? createdAt,
    Value<String>? createdBy,
    Value<DateTime>? updatedAt,
    Value<String>? updatedBy,
    Value<DateTime?>? deletedAt,
    Value<bool>? dirty,
    Value<int>? rowid,
  }) {
    return EventsCompanion(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      type: type ?? this.type,
      status: status ?? this.status,
      title: title ?? this.title,
      startLocal: startLocal ?? this.startLocal,
      startTz: startTz ?? this.startTz,
      endLocal: endLocal ?? this.endLocal,
      endTz: endTz ?? this.endTz,
      allDay: allDay ?? this.allDay,
      locationJson: locationJson ?? this.locationJson,
      provider: provider ?? this.provider,
      bookingRef: bookingRef ?? this.bookingRef,
      detailsJson: detailsJson ?? this.detailsJson,
      travelersJson: travelersJson ?? this.travelersJson,
      costJson: costJson ?? this.costJson,
      notes: notes ?? this.notes,
      sourceJson: sourceJson ?? this.sourceJson,
      reviewState: reviewState ?? this.reviewState,
      editedFieldsJson: editedFieldsJson ?? this.editedFieldsJson,
      fieldMetaJson: fieldMetaJson ?? this.fieldMetaJson,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedAt: deletedAt ?? this.deletedAt,
      dirty: dirty ?? this.dirty,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<String>(tripId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (startLocal.present) {
      map['start_local'] = Variable<DateTime>(startLocal.value);
    }
    if (startTz.present) {
      map['start_tz'] = Variable<String>(startTz.value);
    }
    if (endLocal.present) {
      map['end_local'] = Variable<DateTime>(endLocal.value);
    }
    if (endTz.present) {
      map['end_tz'] = Variable<String>(endTz.value);
    }
    if (allDay.present) {
      map['all_day'] = Variable<bool>(allDay.value);
    }
    if (locationJson.present) {
      map['location'] = Variable<String>(locationJson.value);
    }
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (bookingRef.present) {
      map['booking_ref'] = Variable<String>(bookingRef.value);
    }
    if (detailsJson.present) {
      map['details'] = Variable<String>(detailsJson.value);
    }
    if (travelersJson.present) {
      map['travelers'] = Variable<String>(travelersJson.value);
    }
    if (costJson.present) {
      map['cost'] = Variable<String>(costJson.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (sourceJson.present) {
      map['source'] = Variable<String>(sourceJson.value);
    }
    if (reviewState.present) {
      map['review_state'] = Variable<String>(reviewState.value);
    }
    if (editedFieldsJson.present) {
      map['edited_fields'] = Variable<String>(editedFieldsJson.value);
    }
    if (fieldMetaJson.present) {
      map['field_meta'] = Variable<String>(fieldMetaJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventsCompanion(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('title: $title, ')
          ..write('startLocal: $startLocal, ')
          ..write('startTz: $startTz, ')
          ..write('endLocal: $endLocal, ')
          ..write('endTz: $endTz, ')
          ..write('allDay: $allDay, ')
          ..write('locationJson: $locationJson, ')
          ..write('provider: $provider, ')
          ..write('bookingRef: $bookingRef, ')
          ..write('detailsJson: $detailsJson, ')
          ..write('travelersJson: $travelersJson, ')
          ..write('costJson: $costJson, ')
          ..write('notes: $notes, ')
          ..write('sourceJson: $sourceJson, ')
          ..write('reviewState: $reviewState, ')
          ..write('editedFieldsJson: $editedFieldsJson, ')
          ..write('fieldMetaJson: $fieldMetaJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('dirty: $dirty, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AttachmentsTable extends Attachments
    with TableInfo<$AttachmentsTable, Attachment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttachmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<String> tripId = GeneratedColumn<String>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
    'event_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('document'),
  );
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sizeBytesMeta = const VerificationMeta(
    'sizeBytes',
  );
  @override
  late final GeneratedColumn<int> sizeBytes = GeneratedColumn<int>(
    'size_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sha256Meta = const VerificationMeta('sha256');
  @override
  late final GeneratedColumn<String> sha256 = GeneratedColumn<String>(
    'sha256',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storagePathMeta = const VerificationMeta(
    'storagePath',
  );
  @override
  late final GeneratedColumn<String> storagePath = GeneratedColumn<String>(
    'storage_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pageCountMeta = const VerificationMeta(
    'pageCount',
  );
  @override
  late final GeneratedColumn<int> pageCount = GeneratedColumn<int>(
    'page_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceJsonMeta = const VerificationMeta(
    'sourceJson',
  );
  @override
  late final GeneratedColumn<String> sourceJson = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _downloadStateMeta = const VerificationMeta(
    'downloadState',
  );
  @override
  late final GeneratedColumn<String> downloadState = GeneratedColumn<String>(
    'download_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('none'),
  );
  static const VerificationMeta _downloadErrorMeta = const VerificationMeta(
    'downloadError',
  );
  @override
  late final GeneratedColumn<String> downloadError = GeneratedColumn<String>(
    'download_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tripId,
    eventId,
    kind,
    fileName,
    mimeType,
    sizeBytes,
    sha256,
    storagePath,
    pageCount,
    sourceJson,
    createdAt,
    createdBy,
    updatedAt,
    updatedBy,
    deletedAt,
    localPath,
    downloadState,
    downloadError,
    dirty,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attachments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Attachment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mimeTypeMeta);
    }
    if (data.containsKey('size_bytes')) {
      context.handle(
        _sizeBytesMeta,
        sizeBytes.isAcceptableOrUnknown(data['size_bytes']!, _sizeBytesMeta),
      );
    } else if (isInserting) {
      context.missing(_sizeBytesMeta);
    }
    if (data.containsKey('sha256')) {
      context.handle(
        _sha256Meta,
        sha256.isAcceptableOrUnknown(data['sha256']!, _sha256Meta),
      );
    } else if (isInserting) {
      context.missing(_sha256Meta);
    }
    if (data.containsKey('storage_path')) {
      context.handle(
        _storagePathMeta,
        storagePath.isAcceptableOrUnknown(
          data['storage_path']!,
          _storagePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_storagePathMeta);
    }
    if (data.containsKey('page_count')) {
      context.handle(
        _pageCountMeta,
        pageCount.isAcceptableOrUnknown(data['page_count']!, _pageCountMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceJsonMeta,
        sourceJson.isAcceptableOrUnknown(data['source']!, _sourceJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    }
    if (data.containsKey('download_state')) {
      context.handle(
        _downloadStateMeta,
        downloadState.isAcceptableOrUnknown(
          data['download_state']!,
          _downloadStateMeta,
        ),
      );
    }
    if (data.containsKey('download_error')) {
      context.handle(
        _downloadErrorMeta,
        downloadError.isAcceptableOrUnknown(
          data['download_error']!,
          _downloadErrorMeta,
        ),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Attachment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Attachment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_id'],
      )!,
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_id'],
      ),
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      )!,
      sizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size_bytes'],
      )!,
      sha256: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sha256'],
      )!,
      storagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}storage_path'],
      )!,
      pageCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_count'],
      ),
      sourceJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      ),
      downloadState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}download_state'],
      )!,
      downloadError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}download_error'],
      ),
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
    );
  }

  @override
  $AttachmentsTable createAlias(String alias) {
    return $AttachmentsTable(attachedDatabase, alias);
  }
}

class Attachment extends DataClass implements Insertable<Attachment> {
  final String id;
  final String tripId;
  final String? eventId;
  final String kind;
  final String fileName;
  final String mimeType;
  final int sizeBytes;
  final String sha256;
  final String storagePath;
  final int? pageCount;
  final String sourceJson;
  final DateTime createdAt;
  final String createdBy;
  final DateTime updatedAt;
  final String updatedBy;
  final DateTime? deletedAt;
  final String? localPath;
  final String downloadState;
  final String? downloadError;
  final bool dirty;
  const Attachment({
    required this.id,
    required this.tripId,
    this.eventId,
    required this.kind,
    required this.fileName,
    required this.mimeType,
    required this.sizeBytes,
    required this.sha256,
    required this.storagePath,
    this.pageCount,
    required this.sourceJson,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    this.deletedAt,
    this.localPath,
    required this.downloadState,
    this.downloadError,
    required this.dirty,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['trip_id'] = Variable<String>(tripId);
    if (!nullToAbsent || eventId != null) {
      map['event_id'] = Variable<String>(eventId);
    }
    map['kind'] = Variable<String>(kind);
    map['file_name'] = Variable<String>(fileName);
    map['mime_type'] = Variable<String>(mimeType);
    map['size_bytes'] = Variable<int>(sizeBytes);
    map['sha256'] = Variable<String>(sha256);
    map['storage_path'] = Variable<String>(storagePath);
    if (!nullToAbsent || pageCount != null) {
      map['page_count'] = Variable<int>(pageCount);
    }
    map['source'] = Variable<String>(sourceJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['created_by'] = Variable<String>(createdBy);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<String>(updatedBy);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || localPath != null) {
      map['local_path'] = Variable<String>(localPath);
    }
    map['download_state'] = Variable<String>(downloadState);
    if (!nullToAbsent || downloadError != null) {
      map['download_error'] = Variable<String>(downloadError);
    }
    map['dirty'] = Variable<bool>(dirty);
    return map;
  }

  AttachmentsCompanion toCompanion(bool nullToAbsent) {
    return AttachmentsCompanion(
      id: Value(id),
      tripId: Value(tripId),
      eventId: eventId == null && nullToAbsent
          ? const Value.absent()
          : Value(eventId),
      kind: Value(kind),
      fileName: Value(fileName),
      mimeType: Value(mimeType),
      sizeBytes: Value(sizeBytes),
      sha256: Value(sha256),
      storagePath: Value(storagePath),
      pageCount: pageCount == null && nullToAbsent
          ? const Value.absent()
          : Value(pageCount),
      sourceJson: Value(sourceJson),
      createdAt: Value(createdAt),
      createdBy: Value(createdBy),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      localPath: localPath == null && nullToAbsent
          ? const Value.absent()
          : Value(localPath),
      downloadState: Value(downloadState),
      downloadError: downloadError == null && nullToAbsent
          ? const Value.absent()
          : Value(downloadError),
      dirty: Value(dirty),
    );
  }

  factory Attachment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Attachment(
      id: serializer.fromJson<String>(json['id']),
      tripId: serializer.fromJson<String>(json['tripId']),
      eventId: serializer.fromJson<String?>(json['eventId']),
      kind: serializer.fromJson<String>(json['kind']),
      fileName: serializer.fromJson<String>(json['fileName']),
      mimeType: serializer.fromJson<String>(json['mimeType']),
      sizeBytes: serializer.fromJson<int>(json['sizeBytes']),
      sha256: serializer.fromJson<String>(json['sha256']),
      storagePath: serializer.fromJson<String>(json['storagePath']),
      pageCount: serializer.fromJson<int?>(json['pageCount']),
      sourceJson: serializer.fromJson<String>(json['sourceJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      updatedBy: serializer.fromJson<String>(json['updatedBy']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      localPath: serializer.fromJson<String?>(json['localPath']),
      downloadState: serializer.fromJson<String>(json['downloadState']),
      downloadError: serializer.fromJson<String?>(json['downloadError']),
      dirty: serializer.fromJson<bool>(json['dirty']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tripId': serializer.toJson<String>(tripId),
      'eventId': serializer.toJson<String?>(eventId),
      'kind': serializer.toJson<String>(kind),
      'fileName': serializer.toJson<String>(fileName),
      'mimeType': serializer.toJson<String>(mimeType),
      'sizeBytes': serializer.toJson<int>(sizeBytes),
      'sha256': serializer.toJson<String>(sha256),
      'storagePath': serializer.toJson<String>(storagePath),
      'pageCount': serializer.toJson<int?>(pageCount),
      'sourceJson': serializer.toJson<String>(sourceJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'createdBy': serializer.toJson<String>(createdBy),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'updatedBy': serializer.toJson<String>(updatedBy),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'localPath': serializer.toJson<String?>(localPath),
      'downloadState': serializer.toJson<String>(downloadState),
      'downloadError': serializer.toJson<String?>(downloadError),
      'dirty': serializer.toJson<bool>(dirty),
    };
  }

  Attachment copyWith({
    String? id,
    String? tripId,
    Value<String?> eventId = const Value.absent(),
    String? kind,
    String? fileName,
    String? mimeType,
    int? sizeBytes,
    String? sha256,
    String? storagePath,
    Value<int?> pageCount = const Value.absent(),
    String? sourceJson,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<String?> localPath = const Value.absent(),
    String? downloadState,
    Value<String?> downloadError = const Value.absent(),
    bool? dirty,
  }) => Attachment(
    id: id ?? this.id,
    tripId: tripId ?? this.tripId,
    eventId: eventId.present ? eventId.value : this.eventId,
    kind: kind ?? this.kind,
    fileName: fileName ?? this.fileName,
    mimeType: mimeType ?? this.mimeType,
    sizeBytes: sizeBytes ?? this.sizeBytes,
    sha256: sha256 ?? this.sha256,
    storagePath: storagePath ?? this.storagePath,
    pageCount: pageCount.present ? pageCount.value : this.pageCount,
    sourceJson: sourceJson ?? this.sourceJson,
    createdAt: createdAt ?? this.createdAt,
    createdBy: createdBy ?? this.createdBy,
    updatedAt: updatedAt ?? this.updatedAt,
    updatedBy: updatedBy ?? this.updatedBy,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    localPath: localPath.present ? localPath.value : this.localPath,
    downloadState: downloadState ?? this.downloadState,
    downloadError: downloadError.present
        ? downloadError.value
        : this.downloadError,
    dirty: dirty ?? this.dirty,
  );
  Attachment copyWithCompanion(AttachmentsCompanion data) {
    return Attachment(
      id: data.id.present ? data.id.value : this.id,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      kind: data.kind.present ? data.kind.value : this.kind,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      sizeBytes: data.sizeBytes.present ? data.sizeBytes.value : this.sizeBytes,
      sha256: data.sha256.present ? data.sha256.value : this.sha256,
      storagePath: data.storagePath.present
          ? data.storagePath.value
          : this.storagePath,
      pageCount: data.pageCount.present ? data.pageCount.value : this.pageCount,
      sourceJson: data.sourceJson.present
          ? data.sourceJson.value
          : this.sourceJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      downloadState: data.downloadState.present
          ? data.downloadState.value
          : this.downloadState,
      downloadError: data.downloadError.present
          ? data.downloadError.value
          : this.downloadError,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Attachment(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('eventId: $eventId, ')
          ..write('kind: $kind, ')
          ..write('fileName: $fileName, ')
          ..write('mimeType: $mimeType, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('sha256: $sha256, ')
          ..write('storagePath: $storagePath, ')
          ..write('pageCount: $pageCount, ')
          ..write('sourceJson: $sourceJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('localPath: $localPath, ')
          ..write('downloadState: $downloadState, ')
          ..write('downloadError: $downloadError, ')
          ..write('dirty: $dirty')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tripId,
    eventId,
    kind,
    fileName,
    mimeType,
    sizeBytes,
    sha256,
    storagePath,
    pageCount,
    sourceJson,
    createdAt,
    createdBy,
    updatedAt,
    updatedBy,
    deletedAt,
    localPath,
    downloadState,
    downloadError,
    dirty,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Attachment &&
          other.id == this.id &&
          other.tripId == this.tripId &&
          other.eventId == this.eventId &&
          other.kind == this.kind &&
          other.fileName == this.fileName &&
          other.mimeType == this.mimeType &&
          other.sizeBytes == this.sizeBytes &&
          other.sha256 == this.sha256 &&
          other.storagePath == this.storagePath &&
          other.pageCount == this.pageCount &&
          other.sourceJson == this.sourceJson &&
          other.createdAt == this.createdAt &&
          other.createdBy == this.createdBy &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.deletedAt == this.deletedAt &&
          other.localPath == this.localPath &&
          other.downloadState == this.downloadState &&
          other.downloadError == this.downloadError &&
          other.dirty == this.dirty);
}

class AttachmentsCompanion extends UpdateCompanion<Attachment> {
  final Value<String> id;
  final Value<String> tripId;
  final Value<String?> eventId;
  final Value<String> kind;
  final Value<String> fileName;
  final Value<String> mimeType;
  final Value<int> sizeBytes;
  final Value<String> sha256;
  final Value<String> storagePath;
  final Value<int?> pageCount;
  final Value<String> sourceJson;
  final Value<DateTime> createdAt;
  final Value<String> createdBy;
  final Value<DateTime> updatedAt;
  final Value<String> updatedBy;
  final Value<DateTime?> deletedAt;
  final Value<String?> localPath;
  final Value<String> downloadState;
  final Value<String?> downloadError;
  final Value<bool> dirty;
  final Value<int> rowid;
  const AttachmentsCompanion({
    this.id = const Value.absent(),
    this.tripId = const Value.absent(),
    this.eventId = const Value.absent(),
    this.kind = const Value.absent(),
    this.fileName = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.sha256 = const Value.absent(),
    this.storagePath = const Value.absent(),
    this.pageCount = const Value.absent(),
    this.sourceJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.localPath = const Value.absent(),
    this.downloadState = const Value.absent(),
    this.downloadError = const Value.absent(),
    this.dirty = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AttachmentsCompanion.insert({
    required String id,
    required String tripId,
    this.eventId = const Value.absent(),
    this.kind = const Value.absent(),
    required String fileName,
    required String mimeType,
    required int sizeBytes,
    required String sha256,
    required String storagePath,
    this.pageCount = const Value.absent(),
    required String sourceJson,
    required DateTime createdAt,
    required String createdBy,
    required DateTime updatedAt,
    required String updatedBy,
    this.deletedAt = const Value.absent(),
    this.localPath = const Value.absent(),
    this.downloadState = const Value.absent(),
    this.downloadError = const Value.absent(),
    this.dirty = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tripId = Value(tripId),
       fileName = Value(fileName),
       mimeType = Value(mimeType),
       sizeBytes = Value(sizeBytes),
       sha256 = Value(sha256),
       storagePath = Value(storagePath),
       sourceJson = Value(sourceJson),
       createdAt = Value(createdAt),
       createdBy = Value(createdBy),
       updatedAt = Value(updatedAt),
       updatedBy = Value(updatedBy);
  static Insertable<Attachment> custom({
    Expression<String>? id,
    Expression<String>? tripId,
    Expression<String>? eventId,
    Expression<String>? kind,
    Expression<String>? fileName,
    Expression<String>? mimeType,
    Expression<int>? sizeBytes,
    Expression<String>? sha256,
    Expression<String>? storagePath,
    Expression<int>? pageCount,
    Expression<String>? sourceJson,
    Expression<DateTime>? createdAt,
    Expression<String>? createdBy,
    Expression<DateTime>? updatedAt,
    Expression<String>? updatedBy,
    Expression<DateTime>? deletedAt,
    Expression<String>? localPath,
    Expression<String>? downloadState,
    Expression<String>? downloadError,
    Expression<bool>? dirty,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tripId != null) 'trip_id': tripId,
      if (eventId != null) 'event_id': eventId,
      if (kind != null) 'kind': kind,
      if (fileName != null) 'file_name': fileName,
      if (mimeType != null) 'mime_type': mimeType,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
      if (sha256 != null) 'sha256': sha256,
      if (storagePath != null) 'storage_path': storagePath,
      if (pageCount != null) 'page_count': pageCount,
      if (sourceJson != null) 'source': sourceJson,
      if (createdAt != null) 'created_at': createdAt,
      if (createdBy != null) 'created_by': createdBy,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (localPath != null) 'local_path': localPath,
      if (downloadState != null) 'download_state': downloadState,
      if (downloadError != null) 'download_error': downloadError,
      if (dirty != null) 'dirty': dirty,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AttachmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? tripId,
    Value<String?>? eventId,
    Value<String>? kind,
    Value<String>? fileName,
    Value<String>? mimeType,
    Value<int>? sizeBytes,
    Value<String>? sha256,
    Value<String>? storagePath,
    Value<int?>? pageCount,
    Value<String>? sourceJson,
    Value<DateTime>? createdAt,
    Value<String>? createdBy,
    Value<DateTime>? updatedAt,
    Value<String>? updatedBy,
    Value<DateTime?>? deletedAt,
    Value<String?>? localPath,
    Value<String>? downloadState,
    Value<String?>? downloadError,
    Value<bool>? dirty,
    Value<int>? rowid,
  }) {
    return AttachmentsCompanion(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      eventId: eventId ?? this.eventId,
      kind: kind ?? this.kind,
      fileName: fileName ?? this.fileName,
      mimeType: mimeType ?? this.mimeType,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      sha256: sha256 ?? this.sha256,
      storagePath: storagePath ?? this.storagePath,
      pageCount: pageCount ?? this.pageCount,
      sourceJson: sourceJson ?? this.sourceJson,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      deletedAt: deletedAt ?? this.deletedAt,
      localPath: localPath ?? this.localPath,
      downloadState: downloadState ?? this.downloadState,
      downloadError: downloadError ?? this.downloadError,
      dirty: dirty ?? this.dirty,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<String>(tripId.value);
    }
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (sizeBytes.present) {
      map['size_bytes'] = Variable<int>(sizeBytes.value);
    }
    if (sha256.present) {
      map['sha256'] = Variable<String>(sha256.value);
    }
    if (storagePath.present) {
      map['storage_path'] = Variable<String>(storagePath.value);
    }
    if (pageCount.present) {
      map['page_count'] = Variable<int>(pageCount.value);
    }
    if (sourceJson.present) {
      map['source'] = Variable<String>(sourceJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (downloadState.present) {
      map['download_state'] = Variable<String>(downloadState.value);
    }
    if (downloadError.present) {
      map['download_error'] = Variable<String>(downloadError.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttachmentsCompanion(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('eventId: $eventId, ')
          ..write('kind: $kind, ')
          ..write('fileName: $fileName, ')
          ..write('mimeType: $mimeType, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('sha256: $sha256, ')
          ..write('storagePath: $storagePath, ')
          ..write('pageCount: $pageCount, ')
          ..write('sourceJson: $sourceJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdBy: $createdBy, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('localPath: $localPath, ')
          ..write('downloadState: $downloadState, ')
          ..write('downloadError: $downloadError, ')
          ..write('dirty: $dirty, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IngestedEmailsTable extends IngestedEmails
    with TableInfo<$IngestedEmailsTable, IngestedEmail> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IngestedEmailsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _gmailMessageIdMeta = const VerificationMeta(
    'gmailMessageId',
  );
  @override
  late final GeneratedColumn<String> gmailMessageId = GeneratedColumn<String>(
    'gmail_message_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<String> tripId = GeneratedColumn<String>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _threadIdMeta = const VerificationMeta(
    'threadId',
  );
  @override
  late final GeneratedColumn<String> threadId = GeneratedColumn<String>(
    'thread_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromAddrMeta = const VerificationMeta(
    'fromAddr',
  );
  @override
  late final GeneratedColumn<String> fromAddr = GeneratedColumn<String>(
    'from_addr',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectMeta = const VerificationMeta(
    'subject',
  );
  @override
  late final GeneratedColumn<String> subject = GeneratedColumn<String>(
    'subject',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receivedAtMeta = const VerificationMeta(
    'receivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> receivedAt = GeneratedColumn<DateTime>(
    'received_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _snippetMeta = const VerificationMeta(
    'snippet',
  );
  @override
  late final GeneratedColumn<String> snippet = GeneratedColumn<String>(
    'snippet',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyTextMeta = const VerificationMeta(
    'bodyText',
  );
  @override
  late final GeneratedColumn<String> bodyText = GeneratedColumn<String>(
    'body_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gmailLinkMeta = const VerificationMeta(
    'gmailLink',
  );
  @override
  late final GeneratedColumn<String> gmailLink = GeneratedColumn<String>(
    'gmail_link',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _failureReasonMeta = const VerificationMeta(
    'failureReason',
  );
  @override
  late final GeneratedColumn<String> failureReason = GeneratedColumn<String>(
    'failure_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _eventIdsJsonMeta = const VerificationMeta(
    'eventIdsJson',
  );
  @override
  late final GeneratedColumn<String> eventIdsJson = GeneratedColumn<String>(
    'event_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _attachmentCountMeta = const VerificationMeta(
    'attachmentCount',
  );
  @override
  late final GeneratedColumn<int> attachmentCount = GeneratedColumn<int>(
    'attachment_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _reparseRequestedMeta = const VerificationMeta(
    'reparseRequested',
  );
  @override
  late final GeneratedColumn<bool> reparseRequested = GeneratedColumn<bool>(
    'reparse_requested',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reparse_requested" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _reparseNoteMeta = const VerificationMeta(
    'reparseNote',
  );
  @override
  late final GeneratedColumn<String> reparseNote = GeneratedColumn<String>(
    'reparse_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _handledByMeta = const VerificationMeta(
    'handledBy',
  );
  @override
  late final GeneratedColumn<String> handledBy = GeneratedColumn<String>(
    'handled_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _handledAtMeta = const VerificationMeta(
    'handledAt',
  );
  @override
  late final GeneratedColumn<DateTime> handledAt = GeneratedColumn<DateTime>(
    'handled_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    gmailMessageId,
    tripId,
    threadId,
    fromAddr,
    subject,
    receivedAt,
    snippet,
    bodyText,
    gmailLink,
    status,
    failureReason,
    eventIdsJson,
    attachmentCount,
    reparseRequested,
    reparseNote,
    handledBy,
    handledAt,
    updatedAt,
    deletedAt,
    dirty,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ingested_emails';
  @override
  VerificationContext validateIntegrity(
    Insertable<IngestedEmail> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('gmail_message_id')) {
      context.handle(
        _gmailMessageIdMeta,
        gmailMessageId.isAcceptableOrUnknown(
          data['gmail_message_id']!,
          _gmailMessageIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_gmailMessageIdMeta);
    }
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('thread_id')) {
      context.handle(
        _threadIdMeta,
        threadId.isAcceptableOrUnknown(data['thread_id']!, _threadIdMeta),
      );
    } else if (isInserting) {
      context.missing(_threadIdMeta);
    }
    if (data.containsKey('from_addr')) {
      context.handle(
        _fromAddrMeta,
        fromAddr.isAcceptableOrUnknown(data['from_addr']!, _fromAddrMeta),
      );
    } else if (isInserting) {
      context.missing(_fromAddrMeta);
    }
    if (data.containsKey('subject')) {
      context.handle(
        _subjectMeta,
        subject.isAcceptableOrUnknown(data['subject']!, _subjectMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectMeta);
    }
    if (data.containsKey('received_at')) {
      context.handle(
        _receivedAtMeta,
        receivedAt.isAcceptableOrUnknown(data['received_at']!, _receivedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_receivedAtMeta);
    }
    if (data.containsKey('snippet')) {
      context.handle(
        _snippetMeta,
        snippet.isAcceptableOrUnknown(data['snippet']!, _snippetMeta),
      );
    } else if (isInserting) {
      context.missing(_snippetMeta);
    }
    if (data.containsKey('body_text')) {
      context.handle(
        _bodyTextMeta,
        bodyText.isAcceptableOrUnknown(data['body_text']!, _bodyTextMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyTextMeta);
    }
    if (data.containsKey('gmail_link')) {
      context.handle(
        _gmailLinkMeta,
        gmailLink.isAcceptableOrUnknown(data['gmail_link']!, _gmailLinkMeta),
      );
    } else if (isInserting) {
      context.missing(_gmailLinkMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('failure_reason')) {
      context.handle(
        _failureReasonMeta,
        failureReason.isAcceptableOrUnknown(
          data['failure_reason']!,
          _failureReasonMeta,
        ),
      );
    }
    if (data.containsKey('event_ids')) {
      context.handle(
        _eventIdsJsonMeta,
        eventIdsJson.isAcceptableOrUnknown(
          data['event_ids']!,
          _eventIdsJsonMeta,
        ),
      );
    }
    if (data.containsKey('attachment_count')) {
      context.handle(
        _attachmentCountMeta,
        attachmentCount.isAcceptableOrUnknown(
          data['attachment_count']!,
          _attachmentCountMeta,
        ),
      );
    }
    if (data.containsKey('reparse_requested')) {
      context.handle(
        _reparseRequestedMeta,
        reparseRequested.isAcceptableOrUnknown(
          data['reparse_requested']!,
          _reparseRequestedMeta,
        ),
      );
    }
    if (data.containsKey('reparse_note')) {
      context.handle(
        _reparseNoteMeta,
        reparseNote.isAcceptableOrUnknown(
          data['reparse_note']!,
          _reparseNoteMeta,
        ),
      );
    }
    if (data.containsKey('handled_by')) {
      context.handle(
        _handledByMeta,
        handledBy.isAcceptableOrUnknown(data['handled_by']!, _handledByMeta),
      );
    }
    if (data.containsKey('handled_at')) {
      context.handle(
        _handledAtMeta,
        handledAt.isAcceptableOrUnknown(data['handled_at']!, _handledAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {gmailMessageId};
  @override
  IngestedEmail map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IngestedEmail(
      gmailMessageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gmail_message_id'],
      )!,
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_id'],
      )!,
      threadId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thread_id'],
      )!,
      fromAddr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_addr'],
      )!,
      subject: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject'],
      )!,
      receivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}received_at'],
      )!,
      snippet: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}snippet'],
      )!,
      bodyText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body_text'],
      )!,
      gmailLink: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gmail_link'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      failureReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}failure_reason'],
      ),
      eventIdsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_ids'],
      )!,
      attachmentCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attachment_count'],
      )!,
      reparseRequested: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reparse_requested'],
      )!,
      reparseNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reparse_note'],
      ),
      handledBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}handled_by'],
      ),
      handledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}handled_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
    );
  }

  @override
  $IngestedEmailsTable createAlias(String alias) {
    return $IngestedEmailsTable(attachedDatabase, alias);
  }
}

class IngestedEmail extends DataClass implements Insertable<IngestedEmail> {
  final String gmailMessageId;
  final String tripId;
  final String threadId;
  final String fromAddr;
  final String subject;
  final DateTime receivedAt;
  final String snippet;
  final String bodyText;
  final String gmailLink;
  final String status;
  final String? failureReason;
  final String eventIdsJson;
  final int attachmentCount;
  final bool reparseRequested;
  final String? reparseNote;
  final String? handledBy;
  final DateTime? handledAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final bool dirty;
  const IngestedEmail({
    required this.gmailMessageId,
    required this.tripId,
    required this.threadId,
    required this.fromAddr,
    required this.subject,
    required this.receivedAt,
    required this.snippet,
    required this.bodyText,
    required this.gmailLink,
    required this.status,
    this.failureReason,
    required this.eventIdsJson,
    required this.attachmentCount,
    required this.reparseRequested,
    this.reparseNote,
    this.handledBy,
    this.handledAt,
    required this.updatedAt,
    this.deletedAt,
    required this.dirty,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['gmail_message_id'] = Variable<String>(gmailMessageId);
    map['trip_id'] = Variable<String>(tripId);
    map['thread_id'] = Variable<String>(threadId);
    map['from_addr'] = Variable<String>(fromAddr);
    map['subject'] = Variable<String>(subject);
    map['received_at'] = Variable<DateTime>(receivedAt);
    map['snippet'] = Variable<String>(snippet);
    map['body_text'] = Variable<String>(bodyText);
    map['gmail_link'] = Variable<String>(gmailLink);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || failureReason != null) {
      map['failure_reason'] = Variable<String>(failureReason);
    }
    map['event_ids'] = Variable<String>(eventIdsJson);
    map['attachment_count'] = Variable<int>(attachmentCount);
    map['reparse_requested'] = Variable<bool>(reparseRequested);
    if (!nullToAbsent || reparseNote != null) {
      map['reparse_note'] = Variable<String>(reparseNote);
    }
    if (!nullToAbsent || handledBy != null) {
      map['handled_by'] = Variable<String>(handledBy);
    }
    if (!nullToAbsent || handledAt != null) {
      map['handled_at'] = Variable<DateTime>(handledAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['dirty'] = Variable<bool>(dirty);
    return map;
  }

  IngestedEmailsCompanion toCompanion(bool nullToAbsent) {
    return IngestedEmailsCompanion(
      gmailMessageId: Value(gmailMessageId),
      tripId: Value(tripId),
      threadId: Value(threadId),
      fromAddr: Value(fromAddr),
      subject: Value(subject),
      receivedAt: Value(receivedAt),
      snippet: Value(snippet),
      bodyText: Value(bodyText),
      gmailLink: Value(gmailLink),
      status: Value(status),
      failureReason: failureReason == null && nullToAbsent
          ? const Value.absent()
          : Value(failureReason),
      eventIdsJson: Value(eventIdsJson),
      attachmentCount: Value(attachmentCount),
      reparseRequested: Value(reparseRequested),
      reparseNote: reparseNote == null && nullToAbsent
          ? const Value.absent()
          : Value(reparseNote),
      handledBy: handledBy == null && nullToAbsent
          ? const Value.absent()
          : Value(handledBy),
      handledAt: handledAt == null && nullToAbsent
          ? const Value.absent()
          : Value(handledAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      dirty: Value(dirty),
    );
  }

  factory IngestedEmail.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IngestedEmail(
      gmailMessageId: serializer.fromJson<String>(json['gmailMessageId']),
      tripId: serializer.fromJson<String>(json['tripId']),
      threadId: serializer.fromJson<String>(json['threadId']),
      fromAddr: serializer.fromJson<String>(json['fromAddr']),
      subject: serializer.fromJson<String>(json['subject']),
      receivedAt: serializer.fromJson<DateTime>(json['receivedAt']),
      snippet: serializer.fromJson<String>(json['snippet']),
      bodyText: serializer.fromJson<String>(json['bodyText']),
      gmailLink: serializer.fromJson<String>(json['gmailLink']),
      status: serializer.fromJson<String>(json['status']),
      failureReason: serializer.fromJson<String?>(json['failureReason']),
      eventIdsJson: serializer.fromJson<String>(json['eventIdsJson']),
      attachmentCount: serializer.fromJson<int>(json['attachmentCount']),
      reparseRequested: serializer.fromJson<bool>(json['reparseRequested']),
      reparseNote: serializer.fromJson<String?>(json['reparseNote']),
      handledBy: serializer.fromJson<String?>(json['handledBy']),
      handledAt: serializer.fromJson<DateTime?>(json['handledAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      dirty: serializer.fromJson<bool>(json['dirty']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'gmailMessageId': serializer.toJson<String>(gmailMessageId),
      'tripId': serializer.toJson<String>(tripId),
      'threadId': serializer.toJson<String>(threadId),
      'fromAddr': serializer.toJson<String>(fromAddr),
      'subject': serializer.toJson<String>(subject),
      'receivedAt': serializer.toJson<DateTime>(receivedAt),
      'snippet': serializer.toJson<String>(snippet),
      'bodyText': serializer.toJson<String>(bodyText),
      'gmailLink': serializer.toJson<String>(gmailLink),
      'status': serializer.toJson<String>(status),
      'failureReason': serializer.toJson<String?>(failureReason),
      'eventIdsJson': serializer.toJson<String>(eventIdsJson),
      'attachmentCount': serializer.toJson<int>(attachmentCount),
      'reparseRequested': serializer.toJson<bool>(reparseRequested),
      'reparseNote': serializer.toJson<String?>(reparseNote),
      'handledBy': serializer.toJson<String?>(handledBy),
      'handledAt': serializer.toJson<DateTime?>(handledAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'dirty': serializer.toJson<bool>(dirty),
    };
  }

  IngestedEmail copyWith({
    String? gmailMessageId,
    String? tripId,
    String? threadId,
    String? fromAddr,
    String? subject,
    DateTime? receivedAt,
    String? snippet,
    String? bodyText,
    String? gmailLink,
    String? status,
    Value<String?> failureReason = const Value.absent(),
    String? eventIdsJson,
    int? attachmentCount,
    bool? reparseRequested,
    Value<String?> reparseNote = const Value.absent(),
    Value<String?> handledBy = const Value.absent(),
    Value<DateTime?> handledAt = const Value.absent(),
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    bool? dirty,
  }) => IngestedEmail(
    gmailMessageId: gmailMessageId ?? this.gmailMessageId,
    tripId: tripId ?? this.tripId,
    threadId: threadId ?? this.threadId,
    fromAddr: fromAddr ?? this.fromAddr,
    subject: subject ?? this.subject,
    receivedAt: receivedAt ?? this.receivedAt,
    snippet: snippet ?? this.snippet,
    bodyText: bodyText ?? this.bodyText,
    gmailLink: gmailLink ?? this.gmailLink,
    status: status ?? this.status,
    failureReason: failureReason.present
        ? failureReason.value
        : this.failureReason,
    eventIdsJson: eventIdsJson ?? this.eventIdsJson,
    attachmentCount: attachmentCount ?? this.attachmentCount,
    reparseRequested: reparseRequested ?? this.reparseRequested,
    reparseNote: reparseNote.present ? reparseNote.value : this.reparseNote,
    handledBy: handledBy.present ? handledBy.value : this.handledBy,
    handledAt: handledAt.present ? handledAt.value : this.handledAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    dirty: dirty ?? this.dirty,
  );
  IngestedEmail copyWithCompanion(IngestedEmailsCompanion data) {
    return IngestedEmail(
      gmailMessageId: data.gmailMessageId.present
          ? data.gmailMessageId.value
          : this.gmailMessageId,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      threadId: data.threadId.present ? data.threadId.value : this.threadId,
      fromAddr: data.fromAddr.present ? data.fromAddr.value : this.fromAddr,
      subject: data.subject.present ? data.subject.value : this.subject,
      receivedAt: data.receivedAt.present
          ? data.receivedAt.value
          : this.receivedAt,
      snippet: data.snippet.present ? data.snippet.value : this.snippet,
      bodyText: data.bodyText.present ? data.bodyText.value : this.bodyText,
      gmailLink: data.gmailLink.present ? data.gmailLink.value : this.gmailLink,
      status: data.status.present ? data.status.value : this.status,
      failureReason: data.failureReason.present
          ? data.failureReason.value
          : this.failureReason,
      eventIdsJson: data.eventIdsJson.present
          ? data.eventIdsJson.value
          : this.eventIdsJson,
      attachmentCount: data.attachmentCount.present
          ? data.attachmentCount.value
          : this.attachmentCount,
      reparseRequested: data.reparseRequested.present
          ? data.reparseRequested.value
          : this.reparseRequested,
      reparseNote: data.reparseNote.present
          ? data.reparseNote.value
          : this.reparseNote,
      handledBy: data.handledBy.present ? data.handledBy.value : this.handledBy,
      handledAt: data.handledAt.present ? data.handledAt.value : this.handledAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IngestedEmail(')
          ..write('gmailMessageId: $gmailMessageId, ')
          ..write('tripId: $tripId, ')
          ..write('threadId: $threadId, ')
          ..write('fromAddr: $fromAddr, ')
          ..write('subject: $subject, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('snippet: $snippet, ')
          ..write('bodyText: $bodyText, ')
          ..write('gmailLink: $gmailLink, ')
          ..write('status: $status, ')
          ..write('failureReason: $failureReason, ')
          ..write('eventIdsJson: $eventIdsJson, ')
          ..write('attachmentCount: $attachmentCount, ')
          ..write('reparseRequested: $reparseRequested, ')
          ..write('reparseNote: $reparseNote, ')
          ..write('handledBy: $handledBy, ')
          ..write('handledAt: $handledAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('dirty: $dirty')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    gmailMessageId,
    tripId,
    threadId,
    fromAddr,
    subject,
    receivedAt,
    snippet,
    bodyText,
    gmailLink,
    status,
    failureReason,
    eventIdsJson,
    attachmentCount,
    reparseRequested,
    reparseNote,
    handledBy,
    handledAt,
    updatedAt,
    deletedAt,
    dirty,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IngestedEmail &&
          other.gmailMessageId == this.gmailMessageId &&
          other.tripId == this.tripId &&
          other.threadId == this.threadId &&
          other.fromAddr == this.fromAddr &&
          other.subject == this.subject &&
          other.receivedAt == this.receivedAt &&
          other.snippet == this.snippet &&
          other.bodyText == this.bodyText &&
          other.gmailLink == this.gmailLink &&
          other.status == this.status &&
          other.failureReason == this.failureReason &&
          other.eventIdsJson == this.eventIdsJson &&
          other.attachmentCount == this.attachmentCount &&
          other.reparseRequested == this.reparseRequested &&
          other.reparseNote == this.reparseNote &&
          other.handledBy == this.handledBy &&
          other.handledAt == this.handledAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.dirty == this.dirty);
}

class IngestedEmailsCompanion extends UpdateCompanion<IngestedEmail> {
  final Value<String> gmailMessageId;
  final Value<String> tripId;
  final Value<String> threadId;
  final Value<String> fromAddr;
  final Value<String> subject;
  final Value<DateTime> receivedAt;
  final Value<String> snippet;
  final Value<String> bodyText;
  final Value<String> gmailLink;
  final Value<String> status;
  final Value<String?> failureReason;
  final Value<String> eventIdsJson;
  final Value<int> attachmentCount;
  final Value<bool> reparseRequested;
  final Value<String?> reparseNote;
  final Value<String?> handledBy;
  final Value<DateTime?> handledAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<bool> dirty;
  final Value<int> rowid;
  const IngestedEmailsCompanion({
    this.gmailMessageId = const Value.absent(),
    this.tripId = const Value.absent(),
    this.threadId = const Value.absent(),
    this.fromAddr = const Value.absent(),
    this.subject = const Value.absent(),
    this.receivedAt = const Value.absent(),
    this.snippet = const Value.absent(),
    this.bodyText = const Value.absent(),
    this.gmailLink = const Value.absent(),
    this.status = const Value.absent(),
    this.failureReason = const Value.absent(),
    this.eventIdsJson = const Value.absent(),
    this.attachmentCount = const Value.absent(),
    this.reparseRequested = const Value.absent(),
    this.reparseNote = const Value.absent(),
    this.handledBy = const Value.absent(),
    this.handledAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IngestedEmailsCompanion.insert({
    required String gmailMessageId,
    required String tripId,
    required String threadId,
    required String fromAddr,
    required String subject,
    required DateTime receivedAt,
    required String snippet,
    required String bodyText,
    required String gmailLink,
    required String status,
    this.failureReason = const Value.absent(),
    this.eventIdsJson = const Value.absent(),
    this.attachmentCount = const Value.absent(),
    this.reparseRequested = const Value.absent(),
    this.reparseNote = const Value.absent(),
    this.handledBy = const Value.absent(),
    this.handledAt = const Value.absent(),
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : gmailMessageId = Value(gmailMessageId),
       tripId = Value(tripId),
       threadId = Value(threadId),
       fromAddr = Value(fromAddr),
       subject = Value(subject),
       receivedAt = Value(receivedAt),
       snippet = Value(snippet),
       bodyText = Value(bodyText),
       gmailLink = Value(gmailLink),
       status = Value(status),
       updatedAt = Value(updatedAt);
  static Insertable<IngestedEmail> custom({
    Expression<String>? gmailMessageId,
    Expression<String>? tripId,
    Expression<String>? threadId,
    Expression<String>? fromAddr,
    Expression<String>? subject,
    Expression<DateTime>? receivedAt,
    Expression<String>? snippet,
    Expression<String>? bodyText,
    Expression<String>? gmailLink,
    Expression<String>? status,
    Expression<String>? failureReason,
    Expression<String>? eventIdsJson,
    Expression<int>? attachmentCount,
    Expression<bool>? reparseRequested,
    Expression<String>? reparseNote,
    Expression<String>? handledBy,
    Expression<DateTime>? handledAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<bool>? dirty,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (gmailMessageId != null) 'gmail_message_id': gmailMessageId,
      if (tripId != null) 'trip_id': tripId,
      if (threadId != null) 'thread_id': threadId,
      if (fromAddr != null) 'from_addr': fromAddr,
      if (subject != null) 'subject': subject,
      if (receivedAt != null) 'received_at': receivedAt,
      if (snippet != null) 'snippet': snippet,
      if (bodyText != null) 'body_text': bodyText,
      if (gmailLink != null) 'gmail_link': gmailLink,
      if (status != null) 'status': status,
      if (failureReason != null) 'failure_reason': failureReason,
      if (eventIdsJson != null) 'event_ids': eventIdsJson,
      if (attachmentCount != null) 'attachment_count': attachmentCount,
      if (reparseRequested != null) 'reparse_requested': reparseRequested,
      if (reparseNote != null) 'reparse_note': reparseNote,
      if (handledBy != null) 'handled_by': handledBy,
      if (handledAt != null) 'handled_at': handledAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (dirty != null) 'dirty': dirty,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IngestedEmailsCompanion copyWith({
    Value<String>? gmailMessageId,
    Value<String>? tripId,
    Value<String>? threadId,
    Value<String>? fromAddr,
    Value<String>? subject,
    Value<DateTime>? receivedAt,
    Value<String>? snippet,
    Value<String>? bodyText,
    Value<String>? gmailLink,
    Value<String>? status,
    Value<String?>? failureReason,
    Value<String>? eventIdsJson,
    Value<int>? attachmentCount,
    Value<bool>? reparseRequested,
    Value<String?>? reparseNote,
    Value<String?>? handledBy,
    Value<DateTime?>? handledAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<bool>? dirty,
    Value<int>? rowid,
  }) {
    return IngestedEmailsCompanion(
      gmailMessageId: gmailMessageId ?? this.gmailMessageId,
      tripId: tripId ?? this.tripId,
      threadId: threadId ?? this.threadId,
      fromAddr: fromAddr ?? this.fromAddr,
      subject: subject ?? this.subject,
      receivedAt: receivedAt ?? this.receivedAt,
      snippet: snippet ?? this.snippet,
      bodyText: bodyText ?? this.bodyText,
      gmailLink: gmailLink ?? this.gmailLink,
      status: status ?? this.status,
      failureReason: failureReason ?? this.failureReason,
      eventIdsJson: eventIdsJson ?? this.eventIdsJson,
      attachmentCount: attachmentCount ?? this.attachmentCount,
      reparseRequested: reparseRequested ?? this.reparseRequested,
      reparseNote: reparseNote ?? this.reparseNote,
      handledBy: handledBy ?? this.handledBy,
      handledAt: handledAt ?? this.handledAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      dirty: dirty ?? this.dirty,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (gmailMessageId.present) {
      map['gmail_message_id'] = Variable<String>(gmailMessageId.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<String>(tripId.value);
    }
    if (threadId.present) {
      map['thread_id'] = Variable<String>(threadId.value);
    }
    if (fromAddr.present) {
      map['from_addr'] = Variable<String>(fromAddr.value);
    }
    if (subject.present) {
      map['subject'] = Variable<String>(subject.value);
    }
    if (receivedAt.present) {
      map['received_at'] = Variable<DateTime>(receivedAt.value);
    }
    if (snippet.present) {
      map['snippet'] = Variable<String>(snippet.value);
    }
    if (bodyText.present) {
      map['body_text'] = Variable<String>(bodyText.value);
    }
    if (gmailLink.present) {
      map['gmail_link'] = Variable<String>(gmailLink.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (failureReason.present) {
      map['failure_reason'] = Variable<String>(failureReason.value);
    }
    if (eventIdsJson.present) {
      map['event_ids'] = Variable<String>(eventIdsJson.value);
    }
    if (attachmentCount.present) {
      map['attachment_count'] = Variable<int>(attachmentCount.value);
    }
    if (reparseRequested.present) {
      map['reparse_requested'] = Variable<bool>(reparseRequested.value);
    }
    if (reparseNote.present) {
      map['reparse_note'] = Variable<String>(reparseNote.value);
    }
    if (handledBy.present) {
      map['handled_by'] = Variable<String>(handledBy.value);
    }
    if (handledAt.present) {
      map['handled_at'] = Variable<DateTime>(handledAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IngestedEmailsCompanion(')
          ..write('gmailMessageId: $gmailMessageId, ')
          ..write('tripId: $tripId, ')
          ..write('threadId: $threadId, ')
          ..write('fromAddr: $fromAddr, ')
          ..write('subject: $subject, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('snippet: $snippet, ')
          ..write('bodyText: $bodyText, ')
          ..write('gmailLink: $gmailLink, ')
          ..write('status: $status, ')
          ..write('failureReason: $failureReason, ')
          ..write('eventIdsJson: $eventIdsJson, ')
          ..write('attachmentCount: $attachmentCount, ')
          ..write('reparseRequested: $reparseRequested, ')
          ..write('reparseNote: $reparseNote, ')
          ..write('handledBy: $handledBy, ')
          ..write('handledAt: $handledAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('dirty: $dirty, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RevisionRequestsTable extends RevisionRequests
    with TableInfo<$RevisionRequestsTable, RevisionRequest> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RevisionRequestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _requestedByMeta = const VerificationMeta(
    'requestedBy',
  );
  @override
  late final GeneratedColumn<String> requestedBy = GeneratedColumn<String>(
    'requested_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _requestedAtMeta = const VerificationMeta(
    'requestedAt',
  );
  @override
  late final GeneratedColumn<DateTime> requestedAt = GeneratedColumn<DateTime>(
    'requested_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('open'),
  );
  static const VerificationMeta _resultNoteMeta = const VerificationMeta(
    'resultNote',
  );
  @override
  late final GeneratedColumn<String> resultNote = GeneratedColumn<String>(
    'result_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _diffJsonMeta = const VerificationMeta(
    'diffJson',
  );
  @override
  late final GeneratedColumn<String> diffJson = GeneratedColumn<String>(
    'diff',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _appliedAtMeta = const VerificationMeta(
    'appliedAt',
  );
  @override
  late final GeneratedColumn<DateTime> appliedAt = GeneratedColumn<DateTime>(
    'applied_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    eventId,
    note,
    requestedBy,
    requestedAt,
    status,
    resultNote,
    diffJson,
    appliedAt,
    updatedAt,
    dirty,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'revision_requests';
  @override
  VerificationContext validateIntegrity(
    Insertable<RevisionRequest> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    } else if (isInserting) {
      context.missing(_noteMeta);
    }
    if (data.containsKey('requested_by')) {
      context.handle(
        _requestedByMeta,
        requestedBy.isAcceptableOrUnknown(
          data['requested_by']!,
          _requestedByMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_requestedByMeta);
    }
    if (data.containsKey('requested_at')) {
      context.handle(
        _requestedAtMeta,
        requestedAt.isAcceptableOrUnknown(
          data['requested_at']!,
          _requestedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_requestedAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('result_note')) {
      context.handle(
        _resultNoteMeta,
        resultNote.isAcceptableOrUnknown(data['result_note']!, _resultNoteMeta),
      );
    }
    if (data.containsKey('diff')) {
      context.handle(
        _diffJsonMeta,
        diffJson.isAcceptableOrUnknown(data['diff']!, _diffJsonMeta),
      );
    }
    if (data.containsKey('applied_at')) {
      context.handle(
        _appliedAtMeta,
        appliedAt.isAcceptableOrUnknown(data['applied_at']!, _appliedAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RevisionRequest map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RevisionRequest(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_id'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      requestedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}requested_by'],
      )!,
      requestedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}requested_at'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      resultNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}result_note'],
      ),
      diffJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}diff'],
      ),
      appliedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}applied_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
    );
  }

  @override
  $RevisionRequestsTable createAlias(String alias) {
    return $RevisionRequestsTable(attachedDatabase, alias);
  }
}

class RevisionRequest extends DataClass implements Insertable<RevisionRequest> {
  final String id;
  final String eventId;
  final String note;
  final String requestedBy;
  final DateTime requestedAt;
  final String status;
  final String? resultNote;
  final String? diffJson;
  final DateTime? appliedAt;
  final DateTime updatedAt;
  final bool dirty;
  const RevisionRequest({
    required this.id,
    required this.eventId,
    required this.note,
    required this.requestedBy,
    required this.requestedAt,
    required this.status,
    this.resultNote,
    this.diffJson,
    this.appliedAt,
    required this.updatedAt,
    required this.dirty,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['event_id'] = Variable<String>(eventId);
    map['note'] = Variable<String>(note);
    map['requested_by'] = Variable<String>(requestedBy);
    map['requested_at'] = Variable<DateTime>(requestedAt);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || resultNote != null) {
      map['result_note'] = Variable<String>(resultNote);
    }
    if (!nullToAbsent || diffJson != null) {
      map['diff'] = Variable<String>(diffJson);
    }
    if (!nullToAbsent || appliedAt != null) {
      map['applied_at'] = Variable<DateTime>(appliedAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['dirty'] = Variable<bool>(dirty);
    return map;
  }

  RevisionRequestsCompanion toCompanion(bool nullToAbsent) {
    return RevisionRequestsCompanion(
      id: Value(id),
      eventId: Value(eventId),
      note: Value(note),
      requestedBy: Value(requestedBy),
      requestedAt: Value(requestedAt),
      status: Value(status),
      resultNote: resultNote == null && nullToAbsent
          ? const Value.absent()
          : Value(resultNote),
      diffJson: diffJson == null && nullToAbsent
          ? const Value.absent()
          : Value(diffJson),
      appliedAt: appliedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(appliedAt),
      updatedAt: Value(updatedAt),
      dirty: Value(dirty),
    );
  }

  factory RevisionRequest.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RevisionRequest(
      id: serializer.fromJson<String>(json['id']),
      eventId: serializer.fromJson<String>(json['eventId']),
      note: serializer.fromJson<String>(json['note']),
      requestedBy: serializer.fromJson<String>(json['requestedBy']),
      requestedAt: serializer.fromJson<DateTime>(json['requestedAt']),
      status: serializer.fromJson<String>(json['status']),
      resultNote: serializer.fromJson<String?>(json['resultNote']),
      diffJson: serializer.fromJson<String?>(json['diffJson']),
      appliedAt: serializer.fromJson<DateTime?>(json['appliedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      dirty: serializer.fromJson<bool>(json['dirty']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'eventId': serializer.toJson<String>(eventId),
      'note': serializer.toJson<String>(note),
      'requestedBy': serializer.toJson<String>(requestedBy),
      'requestedAt': serializer.toJson<DateTime>(requestedAt),
      'status': serializer.toJson<String>(status),
      'resultNote': serializer.toJson<String?>(resultNote),
      'diffJson': serializer.toJson<String?>(diffJson),
      'appliedAt': serializer.toJson<DateTime?>(appliedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'dirty': serializer.toJson<bool>(dirty),
    };
  }

  RevisionRequest copyWith({
    String? id,
    String? eventId,
    String? note,
    String? requestedBy,
    DateTime? requestedAt,
    String? status,
    Value<String?> resultNote = const Value.absent(),
    Value<String?> diffJson = const Value.absent(),
    Value<DateTime?> appliedAt = const Value.absent(),
    DateTime? updatedAt,
    bool? dirty,
  }) => RevisionRequest(
    id: id ?? this.id,
    eventId: eventId ?? this.eventId,
    note: note ?? this.note,
    requestedBy: requestedBy ?? this.requestedBy,
    requestedAt: requestedAt ?? this.requestedAt,
    status: status ?? this.status,
    resultNote: resultNote.present ? resultNote.value : this.resultNote,
    diffJson: diffJson.present ? diffJson.value : this.diffJson,
    appliedAt: appliedAt.present ? appliedAt.value : this.appliedAt,
    updatedAt: updatedAt ?? this.updatedAt,
    dirty: dirty ?? this.dirty,
  );
  RevisionRequest copyWithCompanion(RevisionRequestsCompanion data) {
    return RevisionRequest(
      id: data.id.present ? data.id.value : this.id,
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      note: data.note.present ? data.note.value : this.note,
      requestedBy: data.requestedBy.present
          ? data.requestedBy.value
          : this.requestedBy,
      requestedAt: data.requestedAt.present
          ? data.requestedAt.value
          : this.requestedAt,
      status: data.status.present ? data.status.value : this.status,
      resultNote: data.resultNote.present
          ? data.resultNote.value
          : this.resultNote,
      diffJson: data.diffJson.present ? data.diffJson.value : this.diffJson,
      appliedAt: data.appliedAt.present ? data.appliedAt.value : this.appliedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RevisionRequest(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('note: $note, ')
          ..write('requestedBy: $requestedBy, ')
          ..write('requestedAt: $requestedAt, ')
          ..write('status: $status, ')
          ..write('resultNote: $resultNote, ')
          ..write('diffJson: $diffJson, ')
          ..write('appliedAt: $appliedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('dirty: $dirty')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    eventId,
    note,
    requestedBy,
    requestedAt,
    status,
    resultNote,
    diffJson,
    appliedAt,
    updatedAt,
    dirty,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RevisionRequest &&
          other.id == this.id &&
          other.eventId == this.eventId &&
          other.note == this.note &&
          other.requestedBy == this.requestedBy &&
          other.requestedAt == this.requestedAt &&
          other.status == this.status &&
          other.resultNote == this.resultNote &&
          other.diffJson == this.diffJson &&
          other.appliedAt == this.appliedAt &&
          other.updatedAt == this.updatedAt &&
          other.dirty == this.dirty);
}

class RevisionRequestsCompanion extends UpdateCompanion<RevisionRequest> {
  final Value<String> id;
  final Value<String> eventId;
  final Value<String> note;
  final Value<String> requestedBy;
  final Value<DateTime> requestedAt;
  final Value<String> status;
  final Value<String?> resultNote;
  final Value<String?> diffJson;
  final Value<DateTime?> appliedAt;
  final Value<DateTime> updatedAt;
  final Value<bool> dirty;
  final Value<int> rowid;
  const RevisionRequestsCompanion({
    this.id = const Value.absent(),
    this.eventId = const Value.absent(),
    this.note = const Value.absent(),
    this.requestedBy = const Value.absent(),
    this.requestedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.resultNote = const Value.absent(),
    this.diffJson = const Value.absent(),
    this.appliedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.dirty = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RevisionRequestsCompanion.insert({
    required String id,
    required String eventId,
    required String note,
    required String requestedBy,
    required DateTime requestedAt,
    this.status = const Value.absent(),
    this.resultNote = const Value.absent(),
    this.diffJson = const Value.absent(),
    this.appliedAt = const Value.absent(),
    required DateTime updatedAt,
    this.dirty = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       eventId = Value(eventId),
       note = Value(note),
       requestedBy = Value(requestedBy),
       requestedAt = Value(requestedAt),
       updatedAt = Value(updatedAt);
  static Insertable<RevisionRequest> custom({
    Expression<String>? id,
    Expression<String>? eventId,
    Expression<String>? note,
    Expression<String>? requestedBy,
    Expression<DateTime>? requestedAt,
    Expression<String>? status,
    Expression<String>? resultNote,
    Expression<String>? diffJson,
    Expression<DateTime>? appliedAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? dirty,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventId != null) 'event_id': eventId,
      if (note != null) 'note': note,
      if (requestedBy != null) 'requested_by': requestedBy,
      if (requestedAt != null) 'requested_at': requestedAt,
      if (status != null) 'status': status,
      if (resultNote != null) 'result_note': resultNote,
      if (diffJson != null) 'diff': diffJson,
      if (appliedAt != null) 'applied_at': appliedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (dirty != null) 'dirty': dirty,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RevisionRequestsCompanion copyWith({
    Value<String>? id,
    Value<String>? eventId,
    Value<String>? note,
    Value<String>? requestedBy,
    Value<DateTime>? requestedAt,
    Value<String>? status,
    Value<String?>? resultNote,
    Value<String?>? diffJson,
    Value<DateTime?>? appliedAt,
    Value<DateTime>? updatedAt,
    Value<bool>? dirty,
    Value<int>? rowid,
  }) {
    return RevisionRequestsCompanion(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      note: note ?? this.note,
      requestedBy: requestedBy ?? this.requestedBy,
      requestedAt: requestedAt ?? this.requestedAt,
      status: status ?? this.status,
      resultNote: resultNote ?? this.resultNote,
      diffJson: diffJson ?? this.diffJson,
      appliedAt: appliedAt ?? this.appliedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dirty: dirty ?? this.dirty,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (requestedBy.present) {
      map['requested_by'] = Variable<String>(requestedBy.value);
    }
    if (requestedAt.present) {
      map['requested_at'] = Variable<DateTime>(requestedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (resultNote.present) {
      map['result_note'] = Variable<String>(resultNote.value);
    }
    if (diffJson.present) {
      map['diff'] = Variable<String>(diffJson.value);
    }
    if (appliedAt.present) {
      map['applied_at'] = Variable<DateTime>(appliedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RevisionRequestsCompanion(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('note: $note, ')
          ..write('requestedBy: $requestedBy, ')
          ..write('requestedAt: $requestedAt, ')
          ..write('status: $status, ')
          ..write('resultNote: $resultNote, ')
          ..write('diffJson: $diffJson, ')
          ..write('appliedAt: $appliedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('dirty: $dirty, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncStateTable extends SyncState
    with TableInfo<$SyncStateTable, SyncStateData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncStateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_state';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncStateData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SyncStateData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncStateData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SyncStateTable createAlias(String alias) {
    return $SyncStateTable(attachedDatabase, alias);
  }
}

class SyncStateData extends DataClass implements Insertable<SyncStateData> {
  final String key;
  final String value;
  const SyncStateData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SyncStateCompanion toCompanion(bool nullToAbsent) {
    return SyncStateCompanion(key: Value(key), value: Value(value));
  }

  factory SyncStateData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncStateData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  SyncStateData copyWith({String? key, String? value}) =>
      SyncStateData(key: key ?? this.key, value: value ?? this.value);
  SyncStateData copyWithCompanion(SyncStateCompanion data) {
    return SyncStateData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncStateData &&
          other.key == this.key &&
          other.value == this.value);
}

class SyncStateCompanion extends UpdateCompanion<SyncStateData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SyncStateCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncStateCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<SyncStateData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncStateCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SyncStateCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncOutboxTable extends SyncOutbox
    with TableInfo<$SyncOutboxTable, SyncOutboxData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncOutboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _patchIdMeta = const VerificationMeta(
    'patchId',
  );
  @override
  late final GeneratedColumn<String> patchId = GeneratedColumn<String>(
    'patch_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<String> rowId = GeneratedColumn<String>(
    'row_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fieldMeta = const VerificationMeta('field');
  @override
  late final GeneratedColumn<String> field = GeneratedColumn<String>(
    'field',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueJsonMeta = const VerificationMeta(
    'valueJson',
  );
  @override
  late final GeneratedColumn<String> valueJson = GeneratedColumn<String>(
    'value_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<String> tripId = GeneratedColumn<String>(
    'trip_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bootstrapJsonMeta = const VerificationMeta(
    'bootstrapJson',
  );
  @override
  late final GeneratedColumn<String> bootstrapJson = GeneratedColumn<String>(
    'bootstrap_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    patchId,
    rowId,
    field,
    valueJson,
    updatedAt,
    updatedBy,
    tripId,
    bootstrapJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_outbox';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncOutboxData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('patch_id')) {
      context.handle(
        _patchIdMeta,
        patchId.isAcceptableOrUnknown(data['patch_id']!, _patchIdMeta),
      );
    } else if (isInserting) {
      context.missing(_patchIdMeta);
    }
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    } else if (isInserting) {
      context.missing(_rowIdMeta);
    }
    if (data.containsKey('field')) {
      context.handle(
        _fieldMeta,
        field.isAcceptableOrUnknown(data['field']!, _fieldMeta),
      );
    } else if (isInserting) {
      context.missing(_fieldMeta);
    }
    if (data.containsKey('value_json')) {
      context.handle(
        _valueJsonMeta,
        valueJson.isAcceptableOrUnknown(data['value_json']!, _valueJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_valueJsonMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedByMeta);
    }
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    }
    if (data.containsKey('bootstrap_json')) {
      context.handle(
        _bootstrapJsonMeta,
        bootstrapJson.isAcceptableOrUnknown(
          data['bootstrap_json']!,
          _bootstrapJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {patchId};
  @override
  SyncOutboxData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncOutboxData(
      patchId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}patch_id'],
      )!,
      rowId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}row_id'],
      )!,
      field: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}field'],
      )!,
      valueJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value_json'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      )!,
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_id'],
      ),
      bootstrapJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bootstrap_json'],
      ),
    );
  }

  @override
  $SyncOutboxTable createAlias(String alias) {
    return $SyncOutboxTable(attachedDatabase, alias);
  }
}

class SyncOutboxData extends DataClass implements Insertable<SyncOutboxData> {
  final String patchId;
  final String rowId;
  final String field;
  final String valueJson;
  final DateTime updatedAt;
  final String updatedBy;
  final String? tripId;
  final String? bootstrapJson;
  const SyncOutboxData({
    required this.patchId,
    required this.rowId,
    required this.field,
    required this.valueJson,
    required this.updatedAt,
    required this.updatedBy,
    this.tripId,
    this.bootstrapJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['patch_id'] = Variable<String>(patchId);
    map['row_id'] = Variable<String>(rowId);
    map['field'] = Variable<String>(field);
    map['value_json'] = Variable<String>(valueJson);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['updated_by'] = Variable<String>(updatedBy);
    if (!nullToAbsent || tripId != null) {
      map['trip_id'] = Variable<String>(tripId);
    }
    if (!nullToAbsent || bootstrapJson != null) {
      map['bootstrap_json'] = Variable<String>(bootstrapJson);
    }
    return map;
  }

  SyncOutboxCompanion toCompanion(bool nullToAbsent) {
    return SyncOutboxCompanion(
      patchId: Value(patchId),
      rowId: Value(rowId),
      field: Value(field),
      valueJson: Value(valueJson),
      updatedAt: Value(updatedAt),
      updatedBy: Value(updatedBy),
      tripId: tripId == null && nullToAbsent
          ? const Value.absent()
          : Value(tripId),
      bootstrapJson: bootstrapJson == null && nullToAbsent
          ? const Value.absent()
          : Value(bootstrapJson),
    );
  }

  factory SyncOutboxData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncOutboxData(
      patchId: serializer.fromJson<String>(json['patchId']),
      rowId: serializer.fromJson<String>(json['rowId']),
      field: serializer.fromJson<String>(json['field']),
      valueJson: serializer.fromJson<String>(json['valueJson']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      updatedBy: serializer.fromJson<String>(json['updatedBy']),
      tripId: serializer.fromJson<String?>(json['tripId']),
      bootstrapJson: serializer.fromJson<String?>(json['bootstrapJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'patchId': serializer.toJson<String>(patchId),
      'rowId': serializer.toJson<String>(rowId),
      'field': serializer.toJson<String>(field),
      'valueJson': serializer.toJson<String>(valueJson),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'updatedBy': serializer.toJson<String>(updatedBy),
      'tripId': serializer.toJson<String?>(tripId),
      'bootstrapJson': serializer.toJson<String?>(bootstrapJson),
    };
  }

  SyncOutboxData copyWith({
    String? patchId,
    String? rowId,
    String? field,
    String? valueJson,
    DateTime? updatedAt,
    String? updatedBy,
    Value<String?> tripId = const Value.absent(),
    Value<String?> bootstrapJson = const Value.absent(),
  }) => SyncOutboxData(
    patchId: patchId ?? this.patchId,
    rowId: rowId ?? this.rowId,
    field: field ?? this.field,
    valueJson: valueJson ?? this.valueJson,
    updatedAt: updatedAt ?? this.updatedAt,
    updatedBy: updatedBy ?? this.updatedBy,
    tripId: tripId.present ? tripId.value : this.tripId,
    bootstrapJson: bootstrapJson.present
        ? bootstrapJson.value
        : this.bootstrapJson,
  );
  SyncOutboxData copyWithCompanion(SyncOutboxCompanion data) {
    return SyncOutboxData(
      patchId: data.patchId.present ? data.patchId.value : this.patchId,
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      field: data.field.present ? data.field.value : this.field,
      valueJson: data.valueJson.present ? data.valueJson.value : this.valueJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      bootstrapJson: data.bootstrapJson.present
          ? data.bootstrapJson.value
          : this.bootstrapJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxData(')
          ..write('patchId: $patchId, ')
          ..write('rowId: $rowId, ')
          ..write('field: $field, ')
          ..write('valueJson: $valueJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('tripId: $tripId, ')
          ..write('bootstrapJson: $bootstrapJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    patchId,
    rowId,
    field,
    valueJson,
    updatedAt,
    updatedBy,
    tripId,
    bootstrapJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncOutboxData &&
          other.patchId == this.patchId &&
          other.rowId == this.rowId &&
          other.field == this.field &&
          other.valueJson == this.valueJson &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.tripId == this.tripId &&
          other.bootstrapJson == this.bootstrapJson);
}

class SyncOutboxCompanion extends UpdateCompanion<SyncOutboxData> {
  final Value<String> patchId;
  final Value<String> rowId;
  final Value<String> field;
  final Value<String> valueJson;
  final Value<DateTime> updatedAt;
  final Value<String> updatedBy;
  final Value<String?> tripId;
  final Value<String?> bootstrapJson;
  final Value<int> rowid;
  const SyncOutboxCompanion({
    this.patchId = const Value.absent(),
    this.rowId = const Value.absent(),
    this.field = const Value.absent(),
    this.valueJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.tripId = const Value.absent(),
    this.bootstrapJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncOutboxCompanion.insert({
    required String patchId,
    required String rowId,
    required String field,
    required String valueJson,
    required DateTime updatedAt,
    required String updatedBy,
    this.tripId = const Value.absent(),
    this.bootstrapJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : patchId = Value(patchId),
       rowId = Value(rowId),
       field = Value(field),
       valueJson = Value(valueJson),
       updatedAt = Value(updatedAt),
       updatedBy = Value(updatedBy);
  static Insertable<SyncOutboxData> custom({
    Expression<String>? patchId,
    Expression<String>? rowId,
    Expression<String>? field,
    Expression<String>? valueJson,
    Expression<DateTime>? updatedAt,
    Expression<String>? updatedBy,
    Expression<String>? tripId,
    Expression<String>? bootstrapJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (patchId != null) 'patch_id': patchId,
      if (rowId != null) 'row_id': rowId,
      if (field != null) 'field': field,
      if (valueJson != null) 'value_json': valueJson,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (tripId != null) 'trip_id': tripId,
      if (bootstrapJson != null) 'bootstrap_json': bootstrapJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncOutboxCompanion copyWith({
    Value<String>? patchId,
    Value<String>? rowId,
    Value<String>? field,
    Value<String>? valueJson,
    Value<DateTime>? updatedAt,
    Value<String>? updatedBy,
    Value<String?>? tripId,
    Value<String?>? bootstrapJson,
    Value<int>? rowid,
  }) {
    return SyncOutboxCompanion(
      patchId: patchId ?? this.patchId,
      rowId: rowId ?? this.rowId,
      field: field ?? this.field,
      valueJson: valueJson ?? this.valueJson,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      tripId: tripId ?? this.tripId,
      bootstrapJson: bootstrapJson ?? this.bootstrapJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (patchId.present) {
      map['patch_id'] = Variable<String>(patchId.value);
    }
    if (rowId.present) {
      map['row_id'] = Variable<String>(rowId.value);
    }
    if (field.present) {
      map['field'] = Variable<String>(field.value);
    }
    if (valueJson.present) {
      map['value_json'] = Variable<String>(valueJson.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<String>(tripId.value);
    }
    if (bootstrapJson.present) {
      map['bootstrap_json'] = Variable<String>(bootstrapJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxCompanion(')
          ..write('patchId: $patchId, ')
          ..write('rowId: $rowId, ')
          ..write('field: $field, ')
          ..write('valueJson: $valueJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('tripId: $tripId, ')
          ..write('bootstrapJson: $bootstrapJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TripTableTable tripTable = $TripTableTable(this);
  late final $EventsTable events = $EventsTable(this);
  late final $AttachmentsTable attachments = $AttachmentsTable(this);
  late final $IngestedEmailsTable ingestedEmails = $IngestedEmailsTable(this);
  late final $RevisionRequestsTable revisionRequests = $RevisionRequestsTable(
    this,
  );
  late final $SyncStateTable syncState = $SyncStateTable(this);
  late final $SyncOutboxTable syncOutbox = $SyncOutboxTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    tripTable,
    events,
    attachments,
    ingestedEmails,
    revisionRequests,
    syncState,
    syncOutbox,
  ];
}

typedef $$TripTableTableCreateCompanionBuilder =
    TripTableCompanion Function({
      required String id,
      required String name,
      required DateTime startDate,
      required DateTime endDate,
      required String shipTimeZone,
      required String homeTimeZone,
      Value<String> defaultCurrency,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$TripTableTableUpdateCompanionBuilder =
    TripTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<String> shipTimeZone,
      Value<String> homeTimeZone,
      Value<String> defaultCurrency,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$TripTableTableFilterComposer
    extends Composer<_$AppDatabase, $TripTableTable> {
  $$TripTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shipTimeZone => $composableBuilder(
    column: $table.shipTimeZone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get homeTimeZone => $composableBuilder(
    column: $table.homeTimeZone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultCurrency => $composableBuilder(
    column: $table.defaultCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TripTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TripTableTable> {
  $$TripTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shipTimeZone => $composableBuilder(
    column: $table.shipTimeZone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get homeTimeZone => $composableBuilder(
    column: $table.homeTimeZone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultCurrency => $composableBuilder(
    column: $table.defaultCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TripTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TripTableTable> {
  $$TripTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get shipTimeZone => $composableBuilder(
    column: $table.shipTimeZone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get homeTimeZone => $composableBuilder(
    column: $table.homeTimeZone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get defaultCurrency => $composableBuilder(
    column: $table.defaultCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TripTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TripTableTable,
          TripTableData,
          $$TripTableTableFilterComposer,
          $$TripTableTableOrderingComposer,
          $$TripTableTableAnnotationComposer,
          $$TripTableTableCreateCompanionBuilder,
          $$TripTableTableUpdateCompanionBuilder,
          (
            TripTableData,
            BaseReferences<_$AppDatabase, $TripTableTable, TripTableData>,
          ),
          TripTableData,
          PrefetchHooks Function()
        > {
  $$TripTableTableTableManager(_$AppDatabase db, $TripTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TripTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TripTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TripTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<String> shipTimeZone = const Value.absent(),
                Value<String> homeTimeZone = const Value.absent(),
                Value<String> defaultCurrency = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TripTableCompanion(
                id: id,
                name: name,
                startDate: startDate,
                endDate: endDate,
                shipTimeZone: shipTimeZone,
                homeTimeZone: homeTimeZone,
                defaultCurrency: defaultCurrency,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required DateTime startDate,
                required DateTime endDate,
                required String shipTimeZone,
                required String homeTimeZone,
                Value<String> defaultCurrency = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => TripTableCompanion.insert(
                id: id,
                name: name,
                startDate: startDate,
                endDate: endDate,
                shipTimeZone: shipTimeZone,
                homeTimeZone: homeTimeZone,
                defaultCurrency: defaultCurrency,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TripTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TripTableTable,
      TripTableData,
      $$TripTableTableFilterComposer,
      $$TripTableTableOrderingComposer,
      $$TripTableTableAnnotationComposer,
      $$TripTableTableCreateCompanionBuilder,
      $$TripTableTableUpdateCompanionBuilder,
      (
        TripTableData,
        BaseReferences<_$AppDatabase, $TripTableTable, TripTableData>,
      ),
      TripTableData,
      PrefetchHooks Function()
    >;
typedef $$EventsTableCreateCompanionBuilder =
    EventsCompanion Function({
      required String id,
      required String tripId,
      required String type,
      Value<String> status,
      required String title,
      required DateTime startLocal,
      required String startTz,
      Value<DateTime?> endLocal,
      Value<String?> endTz,
      Value<bool> allDay,
      Value<String?> locationJson,
      Value<String?> provider,
      Value<String?> bookingRef,
      Value<String?> detailsJson,
      Value<String?> travelersJson,
      Value<String?> costJson,
      Value<String?> notes,
      required String sourceJson,
      Value<String> reviewState,
      Value<String> editedFieldsJson,
      Value<String> fieldMetaJson,
      required DateTime createdAt,
      required String createdBy,
      required DateTime updatedAt,
      required String updatedBy,
      Value<DateTime?> deletedAt,
      Value<bool> dirty,
      Value<int> rowid,
    });
typedef $$EventsTableUpdateCompanionBuilder =
    EventsCompanion Function({
      Value<String> id,
      Value<String> tripId,
      Value<String> type,
      Value<String> status,
      Value<String> title,
      Value<DateTime> startLocal,
      Value<String> startTz,
      Value<DateTime?> endLocal,
      Value<String?> endTz,
      Value<bool> allDay,
      Value<String?> locationJson,
      Value<String?> provider,
      Value<String?> bookingRef,
      Value<String?> detailsJson,
      Value<String?> travelersJson,
      Value<String?> costJson,
      Value<String?> notes,
      Value<String> sourceJson,
      Value<String> reviewState,
      Value<String> editedFieldsJson,
      Value<String> fieldMetaJson,
      Value<DateTime> createdAt,
      Value<String> createdBy,
      Value<DateTime> updatedAt,
      Value<String> updatedBy,
      Value<DateTime?> deletedAt,
      Value<bool> dirty,
      Value<int> rowid,
    });

class $$EventsTableFilterComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startLocal => $composableBuilder(
    column: $table.startLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startTz => $composableBuilder(
    column: $table.startTz,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endLocal => $composableBuilder(
    column: $table.endLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endTz => $composableBuilder(
    column: $table.endTz,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get allDay => $composableBuilder(
    column: $table.allDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locationJson => $composableBuilder(
    column: $table.locationJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bookingRef => $composableBuilder(
    column: $table.bookingRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detailsJson => $composableBuilder(
    column: $table.detailsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get travelersJson => $composableBuilder(
    column: $table.travelersJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get costJson => $composableBuilder(
    column: $table.costJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceJson => $composableBuilder(
    column: $table.sourceJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reviewState => $composableBuilder(
    column: $table.reviewState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get editedFieldsJson => $composableBuilder(
    column: $table.editedFieldsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fieldMetaJson => $composableBuilder(
    column: $table.fieldMetaJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EventsTableOrderingComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startLocal => $composableBuilder(
    column: $table.startLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startTz => $composableBuilder(
    column: $table.startTz,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endLocal => $composableBuilder(
    column: $table.endLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endTz => $composableBuilder(
    column: $table.endTz,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get allDay => $composableBuilder(
    column: $table.allDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locationJson => $composableBuilder(
    column: $table.locationJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bookingRef => $composableBuilder(
    column: $table.bookingRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detailsJson => $composableBuilder(
    column: $table.detailsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get travelersJson => $composableBuilder(
    column: $table.travelersJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get costJson => $composableBuilder(
    column: $table.costJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceJson => $composableBuilder(
    column: $table.sourceJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reviewState => $composableBuilder(
    column: $table.reviewState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get editedFieldsJson => $composableBuilder(
    column: $table.editedFieldsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldMetaJson => $composableBuilder(
    column: $table.fieldMetaJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tripId =>
      $composableBuilder(column: $table.tripId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get startLocal => $composableBuilder(
    column: $table.startLocal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get startTz =>
      $composableBuilder(column: $table.startTz, builder: (column) => column);

  GeneratedColumn<DateTime> get endLocal =>
      $composableBuilder(column: $table.endLocal, builder: (column) => column);

  GeneratedColumn<String> get endTz =>
      $composableBuilder(column: $table.endTz, builder: (column) => column);

  GeneratedColumn<bool> get allDay =>
      $composableBuilder(column: $table.allDay, builder: (column) => column);

  GeneratedColumn<String> get locationJson => $composableBuilder(
    column: $table.locationJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<String> get bookingRef => $composableBuilder(
    column: $table.bookingRef,
    builder: (column) => column,
  );

  GeneratedColumn<String> get detailsJson => $composableBuilder(
    column: $table.detailsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get travelersJson => $composableBuilder(
    column: $table.travelersJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get costJson =>
      $composableBuilder(column: $table.costJson, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get sourceJson => $composableBuilder(
    column: $table.sourceJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reviewState => $composableBuilder(
    column: $table.reviewState,
    builder: (column) => column,
  );

  GeneratedColumn<String> get editedFieldsJson => $composableBuilder(
    column: $table.editedFieldsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fieldMetaJson => $composableBuilder(
    column: $table.fieldMetaJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);
}

class $$EventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EventsTable,
          Event,
          $$EventsTableFilterComposer,
          $$EventsTableOrderingComposer,
          $$EventsTableAnnotationComposer,
          $$EventsTableCreateCompanionBuilder,
          $$EventsTableUpdateCompanionBuilder,
          (Event, BaseReferences<_$AppDatabase, $EventsTable, Event>),
          Event,
          PrefetchHooks Function()
        > {
  $$EventsTableTableManager(_$AppDatabase db, $EventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tripId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> startLocal = const Value.absent(),
                Value<String> startTz = const Value.absent(),
                Value<DateTime?> endLocal = const Value.absent(),
                Value<String?> endTz = const Value.absent(),
                Value<bool> allDay = const Value.absent(),
                Value<String?> locationJson = const Value.absent(),
                Value<String?> provider = const Value.absent(),
                Value<String?> bookingRef = const Value.absent(),
                Value<String?> detailsJson = const Value.absent(),
                Value<String?> travelersJson = const Value.absent(),
                Value<String?> costJson = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> sourceJson = const Value.absent(),
                Value<String> reviewState = const Value.absent(),
                Value<String> editedFieldsJson = const Value.absent(),
                Value<String> fieldMetaJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> updatedBy = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EventsCompanion(
                id: id,
                tripId: tripId,
                type: type,
                status: status,
                title: title,
                startLocal: startLocal,
                startTz: startTz,
                endLocal: endLocal,
                endTz: endTz,
                allDay: allDay,
                locationJson: locationJson,
                provider: provider,
                bookingRef: bookingRef,
                detailsJson: detailsJson,
                travelersJson: travelersJson,
                costJson: costJson,
                notes: notes,
                sourceJson: sourceJson,
                reviewState: reviewState,
                editedFieldsJson: editedFieldsJson,
                fieldMetaJson: fieldMetaJson,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                deletedAt: deletedAt,
                dirty: dirty,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tripId,
                required String type,
                Value<String> status = const Value.absent(),
                required String title,
                required DateTime startLocal,
                required String startTz,
                Value<DateTime?> endLocal = const Value.absent(),
                Value<String?> endTz = const Value.absent(),
                Value<bool> allDay = const Value.absent(),
                Value<String?> locationJson = const Value.absent(),
                Value<String?> provider = const Value.absent(),
                Value<String?> bookingRef = const Value.absent(),
                Value<String?> detailsJson = const Value.absent(),
                Value<String?> travelersJson = const Value.absent(),
                Value<String?> costJson = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required String sourceJson,
                Value<String> reviewState = const Value.absent(),
                Value<String> editedFieldsJson = const Value.absent(),
                Value<String> fieldMetaJson = const Value.absent(),
                required DateTime createdAt,
                required String createdBy,
                required DateTime updatedAt,
                required String updatedBy,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EventsCompanion.insert(
                id: id,
                tripId: tripId,
                type: type,
                status: status,
                title: title,
                startLocal: startLocal,
                startTz: startTz,
                endLocal: endLocal,
                endTz: endTz,
                allDay: allDay,
                locationJson: locationJson,
                provider: provider,
                bookingRef: bookingRef,
                detailsJson: detailsJson,
                travelersJson: travelersJson,
                costJson: costJson,
                notes: notes,
                sourceJson: sourceJson,
                reviewState: reviewState,
                editedFieldsJson: editedFieldsJson,
                fieldMetaJson: fieldMetaJson,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                deletedAt: deletedAt,
                dirty: dirty,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EventsTable,
      Event,
      $$EventsTableFilterComposer,
      $$EventsTableOrderingComposer,
      $$EventsTableAnnotationComposer,
      $$EventsTableCreateCompanionBuilder,
      $$EventsTableUpdateCompanionBuilder,
      (Event, BaseReferences<_$AppDatabase, $EventsTable, Event>),
      Event,
      PrefetchHooks Function()
    >;
typedef $$AttachmentsTableCreateCompanionBuilder =
    AttachmentsCompanion Function({
      required String id,
      required String tripId,
      Value<String?> eventId,
      Value<String> kind,
      required String fileName,
      required String mimeType,
      required int sizeBytes,
      required String sha256,
      required String storagePath,
      Value<int?> pageCount,
      required String sourceJson,
      required DateTime createdAt,
      required String createdBy,
      required DateTime updatedAt,
      required String updatedBy,
      Value<DateTime?> deletedAt,
      Value<String?> localPath,
      Value<String> downloadState,
      Value<String?> downloadError,
      Value<bool> dirty,
      Value<int> rowid,
    });
typedef $$AttachmentsTableUpdateCompanionBuilder =
    AttachmentsCompanion Function({
      Value<String> id,
      Value<String> tripId,
      Value<String?> eventId,
      Value<String> kind,
      Value<String> fileName,
      Value<String> mimeType,
      Value<int> sizeBytes,
      Value<String> sha256,
      Value<String> storagePath,
      Value<int?> pageCount,
      Value<String> sourceJson,
      Value<DateTime> createdAt,
      Value<String> createdBy,
      Value<DateTime> updatedAt,
      Value<String> updatedBy,
      Value<DateTime?> deletedAt,
      Value<String?> localPath,
      Value<String> downloadState,
      Value<String?> downloadError,
      Value<bool> dirty,
      Value<int> rowid,
    });

class $$AttachmentsTableFilterComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sha256 => $composableBuilder(
    column: $table.sha256,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storagePath => $composableBuilder(
    column: $table.storagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pageCount => $composableBuilder(
    column: $table.pageCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceJson => $composableBuilder(
    column: $table.sourceJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get downloadState => $composableBuilder(
    column: $table.downloadState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get downloadError => $composableBuilder(
    column: $table.downloadError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AttachmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sha256 => $composableBuilder(
    column: $table.sha256,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storagePath => $composableBuilder(
    column: $table.storagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pageCount => $composableBuilder(
    column: $table.pageCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceJson => $composableBuilder(
    column: $table.sourceJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get downloadState => $composableBuilder(
    column: $table.downloadState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get downloadError => $composableBuilder(
    column: $table.downloadError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AttachmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tripId =>
      $composableBuilder(column: $table.tripId, builder: (column) => column);

  GeneratedColumn<String> get eventId =>
      $composableBuilder(column: $table.eventId, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => column);

  GeneratedColumn<String> get sha256 =>
      $composableBuilder(column: $table.sha256, builder: (column) => column);

  GeneratedColumn<String> get storagePath => $composableBuilder(
    column: $table.storagePath,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pageCount =>
      $composableBuilder(column: $table.pageCount, builder: (column) => column);

  GeneratedColumn<String> get sourceJson => $composableBuilder(
    column: $table.sourceJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<String> get downloadState => $composableBuilder(
    column: $table.downloadState,
    builder: (column) => column,
  );

  GeneratedColumn<String> get downloadError => $composableBuilder(
    column: $table.downloadError,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);
}

class $$AttachmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AttachmentsTable,
          Attachment,
          $$AttachmentsTableFilterComposer,
          $$AttachmentsTableOrderingComposer,
          $$AttachmentsTableAnnotationComposer,
          $$AttachmentsTableCreateCompanionBuilder,
          $$AttachmentsTableUpdateCompanionBuilder,
          (
            Attachment,
            BaseReferences<_$AppDatabase, $AttachmentsTable, Attachment>,
          ),
          Attachment,
          PrefetchHooks Function()
        > {
  $$AttachmentsTableTableManager(_$AppDatabase db, $AttachmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttachmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttachmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttachmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tripId = const Value.absent(),
                Value<String?> eventId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> fileName = const Value.absent(),
                Value<String> mimeType = const Value.absent(),
                Value<int> sizeBytes = const Value.absent(),
                Value<String> sha256 = const Value.absent(),
                Value<String> storagePath = const Value.absent(),
                Value<int?> pageCount = const Value.absent(),
                Value<String> sourceJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> updatedBy = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> localPath = const Value.absent(),
                Value<String> downloadState = const Value.absent(),
                Value<String?> downloadError = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttachmentsCompanion(
                id: id,
                tripId: tripId,
                eventId: eventId,
                kind: kind,
                fileName: fileName,
                mimeType: mimeType,
                sizeBytes: sizeBytes,
                sha256: sha256,
                storagePath: storagePath,
                pageCount: pageCount,
                sourceJson: sourceJson,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                deletedAt: deletedAt,
                localPath: localPath,
                downloadState: downloadState,
                downloadError: downloadError,
                dirty: dirty,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tripId,
                Value<String?> eventId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                required String fileName,
                required String mimeType,
                required int sizeBytes,
                required String sha256,
                required String storagePath,
                Value<int?> pageCount = const Value.absent(),
                required String sourceJson,
                required DateTime createdAt,
                required String createdBy,
                required DateTime updatedAt,
                required String updatedBy,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> localPath = const Value.absent(),
                Value<String> downloadState = const Value.absent(),
                Value<String?> downloadError = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttachmentsCompanion.insert(
                id: id,
                tripId: tripId,
                eventId: eventId,
                kind: kind,
                fileName: fileName,
                mimeType: mimeType,
                sizeBytes: sizeBytes,
                sha256: sha256,
                storagePath: storagePath,
                pageCount: pageCount,
                sourceJson: sourceJson,
                createdAt: createdAt,
                createdBy: createdBy,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                deletedAt: deletedAt,
                localPath: localPath,
                downloadState: downloadState,
                downloadError: downloadError,
                dirty: dirty,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AttachmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AttachmentsTable,
      Attachment,
      $$AttachmentsTableFilterComposer,
      $$AttachmentsTableOrderingComposer,
      $$AttachmentsTableAnnotationComposer,
      $$AttachmentsTableCreateCompanionBuilder,
      $$AttachmentsTableUpdateCompanionBuilder,
      (
        Attachment,
        BaseReferences<_$AppDatabase, $AttachmentsTable, Attachment>,
      ),
      Attachment,
      PrefetchHooks Function()
    >;
typedef $$IngestedEmailsTableCreateCompanionBuilder =
    IngestedEmailsCompanion Function({
      required String gmailMessageId,
      required String tripId,
      required String threadId,
      required String fromAddr,
      required String subject,
      required DateTime receivedAt,
      required String snippet,
      required String bodyText,
      required String gmailLink,
      required String status,
      Value<String?> failureReason,
      Value<String> eventIdsJson,
      Value<int> attachmentCount,
      Value<bool> reparseRequested,
      Value<String?> reparseNote,
      Value<String?> handledBy,
      Value<DateTime?> handledAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<bool> dirty,
      Value<int> rowid,
    });
typedef $$IngestedEmailsTableUpdateCompanionBuilder =
    IngestedEmailsCompanion Function({
      Value<String> gmailMessageId,
      Value<String> tripId,
      Value<String> threadId,
      Value<String> fromAddr,
      Value<String> subject,
      Value<DateTime> receivedAt,
      Value<String> snippet,
      Value<String> bodyText,
      Value<String> gmailLink,
      Value<String> status,
      Value<String?> failureReason,
      Value<String> eventIdsJson,
      Value<int> attachmentCount,
      Value<bool> reparseRequested,
      Value<String?> reparseNote,
      Value<String?> handledBy,
      Value<DateTime?> handledAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<bool> dirty,
      Value<int> rowid,
    });

class $$IngestedEmailsTableFilterComposer
    extends Composer<_$AppDatabase, $IngestedEmailsTable> {
  $$IngestedEmailsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get gmailMessageId => $composableBuilder(
    column: $table.gmailMessageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get threadId => $composableBuilder(
    column: $table.threadId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromAddr => $composableBuilder(
    column: $table.fromAddr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get snippet => $composableBuilder(
    column: $table.snippet,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bodyText => $composableBuilder(
    column: $table.bodyText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gmailLink => $composableBuilder(
    column: $table.gmailLink,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get failureReason => $composableBuilder(
    column: $table.failureReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventIdsJson => $composableBuilder(
    column: $table.eventIdsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attachmentCount => $composableBuilder(
    column: $table.attachmentCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reparseRequested => $composableBuilder(
    column: $table.reparseRequested,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reparseNote => $composableBuilder(
    column: $table.reparseNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get handledBy => $composableBuilder(
    column: $table.handledBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get handledAt => $composableBuilder(
    column: $table.handledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );
}

class $$IngestedEmailsTableOrderingComposer
    extends Composer<_$AppDatabase, $IngestedEmailsTable> {
  $$IngestedEmailsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get gmailMessageId => $composableBuilder(
    column: $table.gmailMessageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get threadId => $composableBuilder(
    column: $table.threadId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromAddr => $composableBuilder(
    column: $table.fromAddr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get snippet => $composableBuilder(
    column: $table.snippet,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bodyText => $composableBuilder(
    column: $table.bodyText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gmailLink => $composableBuilder(
    column: $table.gmailLink,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get failureReason => $composableBuilder(
    column: $table.failureReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventIdsJson => $composableBuilder(
    column: $table.eventIdsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attachmentCount => $composableBuilder(
    column: $table.attachmentCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reparseRequested => $composableBuilder(
    column: $table.reparseRequested,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reparseNote => $composableBuilder(
    column: $table.reparseNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get handledBy => $composableBuilder(
    column: $table.handledBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get handledAt => $composableBuilder(
    column: $table.handledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$IngestedEmailsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IngestedEmailsTable> {
  $$IngestedEmailsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get gmailMessageId => $composableBuilder(
    column: $table.gmailMessageId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tripId =>
      $composableBuilder(column: $table.tripId, builder: (column) => column);

  GeneratedColumn<String> get threadId =>
      $composableBuilder(column: $table.threadId, builder: (column) => column);

  GeneratedColumn<String> get fromAddr =>
      $composableBuilder(column: $table.fromAddr, builder: (column) => column);

  GeneratedColumn<String> get subject =>
      $composableBuilder(column: $table.subject, builder: (column) => column);

  GeneratedColumn<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get snippet =>
      $composableBuilder(column: $table.snippet, builder: (column) => column);

  GeneratedColumn<String> get bodyText =>
      $composableBuilder(column: $table.bodyText, builder: (column) => column);

  GeneratedColumn<String> get gmailLink =>
      $composableBuilder(column: $table.gmailLink, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get failureReason => $composableBuilder(
    column: $table.failureReason,
    builder: (column) => column,
  );

  GeneratedColumn<String> get eventIdsJson => $composableBuilder(
    column: $table.eventIdsJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get attachmentCount => $composableBuilder(
    column: $table.attachmentCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get reparseRequested => $composableBuilder(
    column: $table.reparseRequested,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reparseNote => $composableBuilder(
    column: $table.reparseNote,
    builder: (column) => column,
  );

  GeneratedColumn<String> get handledBy =>
      $composableBuilder(column: $table.handledBy, builder: (column) => column);

  GeneratedColumn<DateTime> get handledAt =>
      $composableBuilder(column: $table.handledAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);
}

class $$IngestedEmailsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IngestedEmailsTable,
          IngestedEmail,
          $$IngestedEmailsTableFilterComposer,
          $$IngestedEmailsTableOrderingComposer,
          $$IngestedEmailsTableAnnotationComposer,
          $$IngestedEmailsTableCreateCompanionBuilder,
          $$IngestedEmailsTableUpdateCompanionBuilder,
          (
            IngestedEmail,
            BaseReferences<_$AppDatabase, $IngestedEmailsTable, IngestedEmail>,
          ),
          IngestedEmail,
          PrefetchHooks Function()
        > {
  $$IngestedEmailsTableTableManager(
    _$AppDatabase db,
    $IngestedEmailsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IngestedEmailsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IngestedEmailsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IngestedEmailsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> gmailMessageId = const Value.absent(),
                Value<String> tripId = const Value.absent(),
                Value<String> threadId = const Value.absent(),
                Value<String> fromAddr = const Value.absent(),
                Value<String> subject = const Value.absent(),
                Value<DateTime> receivedAt = const Value.absent(),
                Value<String> snippet = const Value.absent(),
                Value<String> bodyText = const Value.absent(),
                Value<String> gmailLink = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> failureReason = const Value.absent(),
                Value<String> eventIdsJson = const Value.absent(),
                Value<int> attachmentCount = const Value.absent(),
                Value<bool> reparseRequested = const Value.absent(),
                Value<String?> reparseNote = const Value.absent(),
                Value<String?> handledBy = const Value.absent(),
                Value<DateTime?> handledAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IngestedEmailsCompanion(
                gmailMessageId: gmailMessageId,
                tripId: tripId,
                threadId: threadId,
                fromAddr: fromAddr,
                subject: subject,
                receivedAt: receivedAt,
                snippet: snippet,
                bodyText: bodyText,
                gmailLink: gmailLink,
                status: status,
                failureReason: failureReason,
                eventIdsJson: eventIdsJson,
                attachmentCount: attachmentCount,
                reparseRequested: reparseRequested,
                reparseNote: reparseNote,
                handledBy: handledBy,
                handledAt: handledAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                dirty: dirty,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String gmailMessageId,
                required String tripId,
                required String threadId,
                required String fromAddr,
                required String subject,
                required DateTime receivedAt,
                required String snippet,
                required String bodyText,
                required String gmailLink,
                required String status,
                Value<String?> failureReason = const Value.absent(),
                Value<String> eventIdsJson = const Value.absent(),
                Value<int> attachmentCount = const Value.absent(),
                Value<bool> reparseRequested = const Value.absent(),
                Value<String?> reparseNote = const Value.absent(),
                Value<String?> handledBy = const Value.absent(),
                Value<DateTime?> handledAt = const Value.absent(),
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IngestedEmailsCompanion.insert(
                gmailMessageId: gmailMessageId,
                tripId: tripId,
                threadId: threadId,
                fromAddr: fromAddr,
                subject: subject,
                receivedAt: receivedAt,
                snippet: snippet,
                bodyText: bodyText,
                gmailLink: gmailLink,
                status: status,
                failureReason: failureReason,
                eventIdsJson: eventIdsJson,
                attachmentCount: attachmentCount,
                reparseRequested: reparseRequested,
                reparseNote: reparseNote,
                handledBy: handledBy,
                handledAt: handledAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                dirty: dirty,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$IngestedEmailsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IngestedEmailsTable,
      IngestedEmail,
      $$IngestedEmailsTableFilterComposer,
      $$IngestedEmailsTableOrderingComposer,
      $$IngestedEmailsTableAnnotationComposer,
      $$IngestedEmailsTableCreateCompanionBuilder,
      $$IngestedEmailsTableUpdateCompanionBuilder,
      (
        IngestedEmail,
        BaseReferences<_$AppDatabase, $IngestedEmailsTable, IngestedEmail>,
      ),
      IngestedEmail,
      PrefetchHooks Function()
    >;
typedef $$RevisionRequestsTableCreateCompanionBuilder =
    RevisionRequestsCompanion Function({
      required String id,
      required String eventId,
      required String note,
      required String requestedBy,
      required DateTime requestedAt,
      Value<String> status,
      Value<String?> resultNote,
      Value<String?> diffJson,
      Value<DateTime?> appliedAt,
      required DateTime updatedAt,
      Value<bool> dirty,
      Value<int> rowid,
    });
typedef $$RevisionRequestsTableUpdateCompanionBuilder =
    RevisionRequestsCompanion Function({
      Value<String> id,
      Value<String> eventId,
      Value<String> note,
      Value<String> requestedBy,
      Value<DateTime> requestedAt,
      Value<String> status,
      Value<String?> resultNote,
      Value<String?> diffJson,
      Value<DateTime?> appliedAt,
      Value<DateTime> updatedAt,
      Value<bool> dirty,
      Value<int> rowid,
    });

class $$RevisionRequestsTableFilterComposer
    extends Composer<_$AppDatabase, $RevisionRequestsTable> {
  $$RevisionRequestsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get requestedBy => $composableBuilder(
    column: $table.requestedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get requestedAt => $composableBuilder(
    column: $table.requestedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resultNote => $composableBuilder(
    column: $table.resultNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get diffJson => $composableBuilder(
    column: $table.diffJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get appliedAt => $composableBuilder(
    column: $table.appliedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RevisionRequestsTableOrderingComposer
    extends Composer<_$AppDatabase, $RevisionRequestsTable> {
  $$RevisionRequestsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get requestedBy => $composableBuilder(
    column: $table.requestedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get requestedAt => $composableBuilder(
    column: $table.requestedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resultNote => $composableBuilder(
    column: $table.resultNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get diffJson => $composableBuilder(
    column: $table.diffJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get appliedAt => $composableBuilder(
    column: $table.appliedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RevisionRequestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RevisionRequestsTable> {
  $$RevisionRequestsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get eventId =>
      $composableBuilder(column: $table.eventId, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get requestedBy => $composableBuilder(
    column: $table.requestedBy,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get requestedAt => $composableBuilder(
    column: $table.requestedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get resultNote => $composableBuilder(
    column: $table.resultNote,
    builder: (column) => column,
  );

  GeneratedColumn<String> get diffJson =>
      $composableBuilder(column: $table.diffJson, builder: (column) => column);

  GeneratedColumn<DateTime> get appliedAt =>
      $composableBuilder(column: $table.appliedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);
}

class $$RevisionRequestsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RevisionRequestsTable,
          RevisionRequest,
          $$RevisionRequestsTableFilterComposer,
          $$RevisionRequestsTableOrderingComposer,
          $$RevisionRequestsTableAnnotationComposer,
          $$RevisionRequestsTableCreateCompanionBuilder,
          $$RevisionRequestsTableUpdateCompanionBuilder,
          (
            RevisionRequest,
            BaseReferences<
              _$AppDatabase,
              $RevisionRequestsTable,
              RevisionRequest
            >,
          ),
          RevisionRequest,
          PrefetchHooks Function()
        > {
  $$RevisionRequestsTableTableManager(
    _$AppDatabase db,
    $RevisionRequestsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RevisionRequestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RevisionRequestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RevisionRequestsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> eventId = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<String> requestedBy = const Value.absent(),
                Value<DateTime> requestedAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> resultNote = const Value.absent(),
                Value<String?> diffJson = const Value.absent(),
                Value<DateTime?> appliedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RevisionRequestsCompanion(
                id: id,
                eventId: eventId,
                note: note,
                requestedBy: requestedBy,
                requestedAt: requestedAt,
                status: status,
                resultNote: resultNote,
                diffJson: diffJson,
                appliedAt: appliedAt,
                updatedAt: updatedAt,
                dirty: dirty,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String eventId,
                required String note,
                required String requestedBy,
                required DateTime requestedAt,
                Value<String> status = const Value.absent(),
                Value<String?> resultNote = const Value.absent(),
                Value<String?> diffJson = const Value.absent(),
                Value<DateTime?> appliedAt = const Value.absent(),
                required DateTime updatedAt,
                Value<bool> dirty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RevisionRequestsCompanion.insert(
                id: id,
                eventId: eventId,
                note: note,
                requestedBy: requestedBy,
                requestedAt: requestedAt,
                status: status,
                resultNote: resultNote,
                diffJson: diffJson,
                appliedAt: appliedAt,
                updatedAt: updatedAt,
                dirty: dirty,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RevisionRequestsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RevisionRequestsTable,
      RevisionRequest,
      $$RevisionRequestsTableFilterComposer,
      $$RevisionRequestsTableOrderingComposer,
      $$RevisionRequestsTableAnnotationComposer,
      $$RevisionRequestsTableCreateCompanionBuilder,
      $$RevisionRequestsTableUpdateCompanionBuilder,
      (
        RevisionRequest,
        BaseReferences<_$AppDatabase, $RevisionRequestsTable, RevisionRequest>,
      ),
      RevisionRequest,
      PrefetchHooks Function()
    >;
typedef $$SyncStateTableCreateCompanionBuilder =
    SyncStateCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SyncStateTableUpdateCompanionBuilder =
    SyncStateCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SyncStateTableFilterComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncStateTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncStateTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SyncStateTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncStateTable,
          SyncStateData,
          $$SyncStateTableFilterComposer,
          $$SyncStateTableOrderingComposer,
          $$SyncStateTableAnnotationComposer,
          $$SyncStateTableCreateCompanionBuilder,
          $$SyncStateTableUpdateCompanionBuilder,
          (
            SyncStateData,
            BaseReferences<_$AppDatabase, $SyncStateTable, SyncStateData>,
          ),
          SyncStateData,
          PrefetchHooks Function()
        > {
  $$SyncStateTableTableManager(_$AppDatabase db, $SyncStateTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncStateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncStateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncStateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncStateCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SyncStateCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncStateTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncStateTable,
      SyncStateData,
      $$SyncStateTableFilterComposer,
      $$SyncStateTableOrderingComposer,
      $$SyncStateTableAnnotationComposer,
      $$SyncStateTableCreateCompanionBuilder,
      $$SyncStateTableUpdateCompanionBuilder,
      (
        SyncStateData,
        BaseReferences<_$AppDatabase, $SyncStateTable, SyncStateData>,
      ),
      SyncStateData,
      PrefetchHooks Function()
    >;
typedef $$SyncOutboxTableCreateCompanionBuilder =
    SyncOutboxCompanion Function({
      required String patchId,
      required String rowId,
      required String field,
      required String valueJson,
      required DateTime updatedAt,
      required String updatedBy,
      Value<String?> tripId,
      Value<String?> bootstrapJson,
      Value<int> rowid,
    });
typedef $$SyncOutboxTableUpdateCompanionBuilder =
    SyncOutboxCompanion Function({
      Value<String> patchId,
      Value<String> rowId,
      Value<String> field,
      Value<String> valueJson,
      Value<DateTime> updatedAt,
      Value<String> updatedBy,
      Value<String?> tripId,
      Value<String?> bootstrapJson,
      Value<int> rowid,
    });

class $$SyncOutboxTableFilterComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get patchId => $composableBuilder(
    column: $table.patchId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get field => $composableBuilder(
    column: $table.field,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valueJson => $composableBuilder(
    column: $table.valueJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bootstrapJson => $composableBuilder(
    column: $table.bootstrapJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncOutboxTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get patchId => $composableBuilder(
    column: $table.patchId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get field => $composableBuilder(
    column: $table.field,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valueJson => $composableBuilder(
    column: $table.valueJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bootstrapJson => $composableBuilder(
    column: $table.bootstrapJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncOutboxTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get patchId =>
      $composableBuilder(column: $table.patchId, builder: (column) => column);

  GeneratedColumn<String> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<String> get field =>
      $composableBuilder(column: $table.field, builder: (column) => column);

  GeneratedColumn<String> get valueJson =>
      $composableBuilder(column: $table.valueJson, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumn<String> get tripId =>
      $composableBuilder(column: $table.tripId, builder: (column) => column);

  GeneratedColumn<String> get bootstrapJson => $composableBuilder(
    column: $table.bootstrapJson,
    builder: (column) => column,
  );
}

class $$SyncOutboxTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncOutboxTable,
          SyncOutboxData,
          $$SyncOutboxTableFilterComposer,
          $$SyncOutboxTableOrderingComposer,
          $$SyncOutboxTableAnnotationComposer,
          $$SyncOutboxTableCreateCompanionBuilder,
          $$SyncOutboxTableUpdateCompanionBuilder,
          (
            SyncOutboxData,
            BaseReferences<_$AppDatabase, $SyncOutboxTable, SyncOutboxData>,
          ),
          SyncOutboxData,
          PrefetchHooks Function()
        > {
  $$SyncOutboxTableTableManager(_$AppDatabase db, $SyncOutboxTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncOutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncOutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncOutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> patchId = const Value.absent(),
                Value<String> rowId = const Value.absent(),
                Value<String> field = const Value.absent(),
                Value<String> valueJson = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> updatedBy = const Value.absent(),
                Value<String?> tripId = const Value.absent(),
                Value<String?> bootstrapJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncOutboxCompanion(
                patchId: patchId,
                rowId: rowId,
                field: field,
                valueJson: valueJson,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                tripId: tripId,
                bootstrapJson: bootstrapJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String patchId,
                required String rowId,
                required String field,
                required String valueJson,
                required DateTime updatedAt,
                required String updatedBy,
                Value<String?> tripId = const Value.absent(),
                Value<String?> bootstrapJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncOutboxCompanion.insert(
                patchId: patchId,
                rowId: rowId,
                field: field,
                valueJson: valueJson,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                tripId: tripId,
                bootstrapJson: bootstrapJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncOutboxTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncOutboxTable,
      SyncOutboxData,
      $$SyncOutboxTableFilterComposer,
      $$SyncOutboxTableOrderingComposer,
      $$SyncOutboxTableAnnotationComposer,
      $$SyncOutboxTableCreateCompanionBuilder,
      $$SyncOutboxTableUpdateCompanionBuilder,
      (
        SyncOutboxData,
        BaseReferences<_$AppDatabase, $SyncOutboxTable, SyncOutboxData>,
      ),
      SyncOutboxData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TripTableTableTableManager get tripTable =>
      $$TripTableTableTableManager(_db, _db.tripTable);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db, _db.events);
  $$AttachmentsTableTableManager get attachments =>
      $$AttachmentsTableTableManager(_db, _db.attachments);
  $$IngestedEmailsTableTableManager get ingestedEmails =>
      $$IngestedEmailsTableTableManager(_db, _db.ingestedEmails);
  $$RevisionRequestsTableTableManager get revisionRequests =>
      $$RevisionRequestsTableTableManager(_db, _db.revisionRequests);
  $$SyncStateTableTableManager get syncState =>
      $$SyncStateTableTableManager(_db, _db.syncState);
  $$SyncOutboxTableTableManager get syncOutbox =>
      $$SyncOutboxTableTableManager(_db, _db.syncOutbox);
}
