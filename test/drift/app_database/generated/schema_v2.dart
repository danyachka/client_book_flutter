// dart format width=80
// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
import 'package:drift/drift.dart';

class Appointments extends Table
    with TableInfo<Appointments, AppointmentsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Appointments(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<int> clientId = GeneratedColumn<int>(
      'client_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<int> startTime = GeneratedColumn<int>(
      'start_time', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<int> endTime = GeneratedColumn<int>(
      'end_time', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<String> notificationStatus =
      GeneratedColumn<String>('notification_status', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const CustomExpression('\'enabled\''));
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
      'value', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('0.0'));
  late final GeneratedColumn<String> appointmentText = GeneratedColumn<String>(
      'appointment_text', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('\'\''));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        clientId,
        startTime,
        endTime,
        notificationStatus,
        value,
        appointmentText
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'appointments';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppointmentsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppointmentsData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      clientId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}client_id'])!,
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}start_time'])!,
      endTime: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}end_time'])!,
      notificationStatus: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}notification_status'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}value'])!,
      appointmentText: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}appointment_text'])!,
    );
  }

  @override
  Appointments createAlias(String alias) {
    return Appointments(attachedDatabase, alias);
  }
}

class AppointmentsData extends DataClass
    implements Insertable<AppointmentsData> {
  final int id;
  final int clientId;
  final int startTime;
  final int endTime;
  final String notificationStatus;
  final double value;
  final String appointmentText;
  const AppointmentsData(
      {required this.id,
      required this.clientId,
      required this.startTime,
      required this.endTime,
      required this.notificationStatus,
      required this.value,
      required this.appointmentText});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['client_id'] = Variable<int>(clientId);
    map['start_time'] = Variable<int>(startTime);
    map['end_time'] = Variable<int>(endTime);
    map['notification_status'] = Variable<String>(notificationStatus);
    map['value'] = Variable<double>(value);
    map['appointment_text'] = Variable<String>(appointmentText);
    return map;
  }

  AppointmentsCompanion toCompanion(bool nullToAbsent) {
    return AppointmentsCompanion(
      id: Value(id),
      clientId: Value(clientId),
      startTime: Value(startTime),
      endTime: Value(endTime),
      notificationStatus: Value(notificationStatus),
      value: Value(value),
      appointmentText: Value(appointmentText),
    );
  }

  factory AppointmentsData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppointmentsData(
      id: serializer.fromJson<int>(json['id']),
      clientId: serializer.fromJson<int>(json['clientId']),
      startTime: serializer.fromJson<int>(json['startTime']),
      endTime: serializer.fromJson<int>(json['endTime']),
      notificationStatus:
          serializer.fromJson<String>(json['notificationStatus']),
      value: serializer.fromJson<double>(json['value']),
      appointmentText: serializer.fromJson<String>(json['appointmentText']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'clientId': serializer.toJson<int>(clientId),
      'startTime': serializer.toJson<int>(startTime),
      'endTime': serializer.toJson<int>(endTime),
      'notificationStatus': serializer.toJson<String>(notificationStatus),
      'value': serializer.toJson<double>(value),
      'appointmentText': serializer.toJson<String>(appointmentText),
    };
  }

  AppointmentsData copyWith(
          {int? id,
          int? clientId,
          int? startTime,
          int? endTime,
          String? notificationStatus,
          double? value,
          String? appointmentText}) =>
      AppointmentsData(
        id: id ?? this.id,
        clientId: clientId ?? this.clientId,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        notificationStatus: notificationStatus ?? this.notificationStatus,
        value: value ?? this.value,
        appointmentText: appointmentText ?? this.appointmentText,
      );
  AppointmentsData copyWithCompanion(AppointmentsCompanion data) {
    return AppointmentsData(
      id: data.id.present ? data.id.value : this.id,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      notificationStatus: data.notificationStatus.present
          ? data.notificationStatus.value
          : this.notificationStatus,
      value: data.value.present ? data.value.value : this.value,
      appointmentText: data.appointmentText.present
          ? data.appointmentText.value
          : this.appointmentText,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppointmentsData(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('notificationStatus: $notificationStatus, ')
          ..write('value: $value, ')
          ..write('appointmentText: $appointmentText')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, clientId, startTime, endTime,
      notificationStatus, value, appointmentText);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppointmentsData &&
          other.id == this.id &&
          other.clientId == this.clientId &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.notificationStatus == this.notificationStatus &&
          other.value == this.value &&
          other.appointmentText == this.appointmentText);
}

class AppointmentsCompanion extends UpdateCompanion<AppointmentsData> {
  final Value<int> id;
  final Value<int> clientId;
  final Value<int> startTime;
  final Value<int> endTime;
  final Value<String> notificationStatus;
  final Value<double> value;
  final Value<String> appointmentText;
  const AppointmentsCompanion({
    this.id = const Value.absent(),
    this.clientId = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.notificationStatus = const Value.absent(),
    this.value = const Value.absent(),
    this.appointmentText = const Value.absent(),
  });
  AppointmentsCompanion.insert({
    this.id = const Value.absent(),
    required int clientId,
    required int startTime,
    required int endTime,
    this.notificationStatus = const Value.absent(),
    this.value = const Value.absent(),
    this.appointmentText = const Value.absent(),
  })  : clientId = Value(clientId),
        startTime = Value(startTime),
        endTime = Value(endTime);
  static Insertable<AppointmentsData> custom({
    Expression<int>? id,
    Expression<int>? clientId,
    Expression<int>? startTime,
    Expression<int>? endTime,
    Expression<String>? notificationStatus,
    Expression<double>? value,
    Expression<String>? appointmentText,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientId != null) 'client_id': clientId,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (notificationStatus != null) 'notification_status': notificationStatus,
      if (value != null) 'value': value,
      if (appointmentText != null) 'appointment_text': appointmentText,
    });
  }

  AppointmentsCompanion copyWith(
      {Value<int>? id,
      Value<int>? clientId,
      Value<int>? startTime,
      Value<int>? endTime,
      Value<String>? notificationStatus,
      Value<double>? value,
      Value<String>? appointmentText}) {
    return AppointmentsCompanion(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      notificationStatus: notificationStatus ?? this.notificationStatus,
      value: value ?? this.value,
      appointmentText: appointmentText ?? this.appointmentText,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<int>(clientId.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<int>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<int>(endTime.value);
    }
    if (notificationStatus.present) {
      map['notification_status'] = Variable<String>(notificationStatus.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (appointmentText.present) {
      map['appointment_text'] = Variable<String>(appointmentText.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppointmentsCompanion(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('notificationStatus: $notificationStatus, ')
          ..write('value: $value, ')
          ..write('appointmentText: $appointmentText')
          ..write(')'))
        .toString();
  }
}

class Clients extends Table with TableInfo<Clients, ClientsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Clients(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
      'phone_number', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('\'\''));
  late final GeneratedColumn<String> picturePath = GeneratedColumn<String>(
      'picture_path', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('\'\''));
  @override
  List<GeneratedColumn> get $columns => [id, name, phoneNumber, picturePath];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clients';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ClientsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClientsData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      phoneNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone_number'])!,
      picturePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}picture_path'])!,
    );
  }

  @override
  Clients createAlias(String alias) {
    return Clients(attachedDatabase, alias);
  }
}

class ClientsData extends DataClass implements Insertable<ClientsData> {
  final int id;
  final String name;
  final String phoneNumber;
  final String picturePath;
  const ClientsData(
      {required this.id,
      required this.name,
      required this.phoneNumber,
      required this.picturePath});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['phone_number'] = Variable<String>(phoneNumber);
    map['picture_path'] = Variable<String>(picturePath);
    return map;
  }

  ClientsCompanion toCompanion(bool nullToAbsent) {
    return ClientsCompanion(
      id: Value(id),
      name: Value(name),
      phoneNumber: Value(phoneNumber),
      picturePath: Value(picturePath),
    );
  }

  factory ClientsData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClientsData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phoneNumber: serializer.fromJson<String>(json['phoneNumber']),
      picturePath: serializer.fromJson<String>(json['picturePath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'phoneNumber': serializer.toJson<String>(phoneNumber),
      'picturePath': serializer.toJson<String>(picturePath),
    };
  }

  ClientsData copyWith(
          {int? id, String? name, String? phoneNumber, String? picturePath}) =>
      ClientsData(
        id: id ?? this.id,
        name: name ?? this.name,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        picturePath: picturePath ?? this.picturePath,
      );
  ClientsData copyWithCompanion(ClientsCompanion data) {
    return ClientsData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phoneNumber:
          data.phoneNumber.present ? data.phoneNumber.value : this.phoneNumber,
      picturePath:
          data.picturePath.present ? data.picturePath.value : this.picturePath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClientsData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('picturePath: $picturePath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, phoneNumber, picturePath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClientsData &&
          other.id == this.id &&
          other.name == this.name &&
          other.phoneNumber == this.phoneNumber &&
          other.picturePath == this.picturePath);
}

class ClientsCompanion extends UpdateCompanion<ClientsData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> phoneNumber;
  final Value<String> picturePath;
  const ClientsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.picturePath = const Value.absent(),
  });
  ClientsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.phoneNumber = const Value.absent(),
    this.picturePath = const Value.absent(),
  }) : name = Value(name);
  static Insertable<ClientsData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phoneNumber,
    Expression<String>? picturePath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (picturePath != null) 'picture_path': picturePath,
    });
  }

  ClientsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? phoneNumber,
      Value<String>? picturePath}) {
    return ClientsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      picturePath: picturePath ?? this.picturePath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (picturePath.present) {
      map['picture_path'] = Variable<String>(picturePath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('picturePath: $picturePath')
          ..write(')'))
        .toString();
  }
}

class Expenses extends Table with TableInfo<Expenses, ExpensesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Expenses(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('\'\''));
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
      'value', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('0.0'));
  late final GeneratedColumn<int> time = GeneratedColumn<int>(
      'time', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, value, time];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpensesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpensesData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}value'])!,
      time: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}time'])!,
    );
  }

  @override
  Expenses createAlias(String alias) {
    return Expenses(attachedDatabase, alias);
  }
}

class ExpensesData extends DataClass implements Insertable<ExpensesData> {
  final int id;
  final String name;
  final double value;
  final int time;
  const ExpensesData(
      {required this.id,
      required this.name,
      required this.value,
      required this.time});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['value'] = Variable<double>(value);
    map['time'] = Variable<int>(time);
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      name: Value(name),
      value: Value(value),
      time: Value(time),
    );
  }

  factory ExpensesData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpensesData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      value: serializer.fromJson<double>(json['value']),
      time: serializer.fromJson<int>(json['time']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'value': serializer.toJson<double>(value),
      'time': serializer.toJson<int>(time),
    };
  }

  ExpensesData copyWith({int? id, String? name, double? value, int? time}) =>
      ExpensesData(
        id: id ?? this.id,
        name: name ?? this.name,
        value: value ?? this.value,
        time: time ?? this.time,
      );
  ExpensesData copyWithCompanion(ExpensesCompanion data) {
    return ExpensesData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      value: data.value.present ? data.value.value : this.value,
      time: data.time.present ? data.time.value : this.time,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('value: $value, ')
          ..write('time: $time')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, value, time);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpensesData &&
          other.id == this.id &&
          other.name == this.name &&
          other.value == this.value &&
          other.time == this.time);
}

class ExpensesCompanion extends UpdateCompanion<ExpensesData> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> value;
  final Value<int> time;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.value = const Value.absent(),
    this.time = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.value = const Value.absent(),
    required int time,
  }) : time = Value(time);
  static Insertable<ExpensesData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? value,
    Expression<int>? time,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (value != null) 'value': value,
      if (time != null) 'time': time,
    });
  }

  ExpensesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<double>? value,
      Value<int>? time}) {
    return ExpensesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      value: value ?? this.value,
      time: time ?? this.time,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (time.present) {
      map['time'] = Variable<int>(time.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('value: $value, ')
          ..write('time: $time')
          ..write(')'))
        .toString();
  }
}

class DatabaseAtV2 extends GeneratedDatabase {
  DatabaseAtV2(QueryExecutor e) : super(e);
  late final Appointments appointments = Appointments(this);
  late final Clients clients = Clients(this);
  late final Expenses expenses = Expenses(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [appointments, clients, expenses];
  @override
  int get schemaVersion => 2;
}
