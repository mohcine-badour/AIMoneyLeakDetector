// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SubscriptionEntriesTable extends SubscriptionEntries
    with TableInfo<$SubscriptionEntriesTable, SubscriptionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubscriptionEntriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _merchantMeta = const VerificationMeta(
    'merchant',
  );
  @override
  late final GeneratedColumn<String> merchant = GeneratedColumn<String>(
    'merchant',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _billingCycleMeta = const VerificationMeta(
    'billingCycle',
  );
  @override
  late final GeneratedColumn<String> billingCycle = GeneratedColumn<String>(
    'billing_cycle',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextBillingDateMeta = const VerificationMeta(
    'nextBillingDate',
  );
  @override
  late final GeneratedColumn<DateTime> nextBillingDate =
      GeneratedColumn<DateTime>(
        'next_billing_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
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
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
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
    merchant,
    amount,
    currency,
    billingCycle,
    nextBillingDate,
    category,
    status,
    source,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subscriptions';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubscriptionRow> instance, {
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
    if (data.containsKey('merchant')) {
      context.handle(
        _merchantMeta,
        merchant.isAcceptableOrUnknown(data['merchant']!, _merchantMeta),
      );
    } else if (isInserting) {
      context.missing(_merchantMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('billing_cycle')) {
      context.handle(
        _billingCycleMeta,
        billingCycle.isAcceptableOrUnknown(
          data['billing_cycle']!,
          _billingCycleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_billingCycleMeta);
    }
    if (data.containsKey('next_billing_date')) {
      context.handle(
        _nextBillingDateMeta,
        nextBillingDate.isAcceptableOrUnknown(
          data['next_billing_date']!,
          _nextBillingDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextBillingDateMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
  SubscriptionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubscriptionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      merchant: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merchant'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      billingCycle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}billing_cycle'],
      )!,
      nextBillingDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_billing_date'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SubscriptionEntriesTable createAlias(String alias) {
    return $SubscriptionEntriesTable(attachedDatabase, alias);
  }
}

class SubscriptionRow extends DataClass implements Insertable<SubscriptionRow> {
  final String id;
  final String name;
  final String merchant;
  final double amount;
  final String currency;
  final String billingCycle;
  final DateTime nextBillingDate;
  final String category;
  final String status;
  final String source;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SubscriptionRow({
    required this.id,
    required this.name,
    required this.merchant,
    required this.amount,
    required this.currency,
    required this.billingCycle,
    required this.nextBillingDate,
    required this.category,
    required this.status,
    required this.source,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['merchant'] = Variable<String>(merchant);
    map['amount'] = Variable<double>(amount);
    map['currency'] = Variable<String>(currency);
    map['billing_cycle'] = Variable<String>(billingCycle);
    map['next_billing_date'] = Variable<DateTime>(nextBillingDate);
    map['category'] = Variable<String>(category);
    map['status'] = Variable<String>(status);
    map['source'] = Variable<String>(source);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SubscriptionEntriesCompanion toCompanion(bool nullToAbsent) {
    return SubscriptionEntriesCompanion(
      id: Value(id),
      name: Value(name),
      merchant: Value(merchant),
      amount: Value(amount),
      currency: Value(currency),
      billingCycle: Value(billingCycle),
      nextBillingDate: Value(nextBillingDate),
      category: Value(category),
      status: Value(status),
      source: Value(source),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SubscriptionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubscriptionRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      merchant: serializer.fromJson<String>(json['merchant']),
      amount: serializer.fromJson<double>(json['amount']),
      currency: serializer.fromJson<String>(json['currency']),
      billingCycle: serializer.fromJson<String>(json['billingCycle']),
      nextBillingDate: serializer.fromJson<DateTime>(json['nextBillingDate']),
      category: serializer.fromJson<String>(json['category']),
      status: serializer.fromJson<String>(json['status']),
      source: serializer.fromJson<String>(json['source']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'merchant': serializer.toJson<String>(merchant),
      'amount': serializer.toJson<double>(amount),
      'currency': serializer.toJson<String>(currency),
      'billingCycle': serializer.toJson<String>(billingCycle),
      'nextBillingDate': serializer.toJson<DateTime>(nextBillingDate),
      'category': serializer.toJson<String>(category),
      'status': serializer.toJson<String>(status),
      'source': serializer.toJson<String>(source),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SubscriptionRow copyWith({
    String? id,
    String? name,
    String? merchant,
    double? amount,
    String? currency,
    String? billingCycle,
    DateTime? nextBillingDate,
    String? category,
    String? status,
    String? source,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SubscriptionRow(
    id: id ?? this.id,
    name: name ?? this.name,
    merchant: merchant ?? this.merchant,
    amount: amount ?? this.amount,
    currency: currency ?? this.currency,
    billingCycle: billingCycle ?? this.billingCycle,
    nextBillingDate: nextBillingDate ?? this.nextBillingDate,
    category: category ?? this.category,
    status: status ?? this.status,
    source: source ?? this.source,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SubscriptionRow copyWithCompanion(SubscriptionEntriesCompanion data) {
    return SubscriptionRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      merchant: data.merchant.present ? data.merchant.value : this.merchant,
      amount: data.amount.present ? data.amount.value : this.amount,
      currency: data.currency.present ? data.currency.value : this.currency,
      billingCycle: data.billingCycle.present
          ? data.billingCycle.value
          : this.billingCycle,
      nextBillingDate: data.nextBillingDate.present
          ? data.nextBillingDate.value
          : this.nextBillingDate,
      category: data.category.present ? data.category.value : this.category,
      status: data.status.present ? data.status.value : this.status,
      source: data.source.present ? data.source.value : this.source,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('merchant: $merchant, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('billingCycle: $billingCycle, ')
          ..write('nextBillingDate: $nextBillingDate, ')
          ..write('category: $category, ')
          ..write('status: $status, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    merchant,
    amount,
    currency,
    billingCycle,
    nextBillingDate,
    category,
    status,
    source,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubscriptionRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.merchant == this.merchant &&
          other.amount == this.amount &&
          other.currency == this.currency &&
          other.billingCycle == this.billingCycle &&
          other.nextBillingDate == this.nextBillingDate &&
          other.category == this.category &&
          other.status == this.status &&
          other.source == this.source &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SubscriptionEntriesCompanion extends UpdateCompanion<SubscriptionRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> merchant;
  final Value<double> amount;
  final Value<String> currency;
  final Value<String> billingCycle;
  final Value<DateTime> nextBillingDate;
  final Value<String> category;
  final Value<String> status;
  final Value<String> source;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SubscriptionEntriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.merchant = const Value.absent(),
    this.amount = const Value.absent(),
    this.currency = const Value.absent(),
    this.billingCycle = const Value.absent(),
    this.nextBillingDate = const Value.absent(),
    this.category = const Value.absent(),
    this.status = const Value.absent(),
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubscriptionEntriesCompanion.insert({
    required String id,
    required String name,
    required String merchant,
    required double amount,
    required String currency,
    required String billingCycle,
    required DateTime nextBillingDate,
    required String category,
    required String status,
    required String source,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       merchant = Value(merchant),
       amount = Value(amount),
       currency = Value(currency),
       billingCycle = Value(billingCycle),
       nextBillingDate = Value(nextBillingDate),
       category = Value(category),
       status = Value(status),
       source = Value(source),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<SubscriptionRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? merchant,
    Expression<double>? amount,
    Expression<String>? currency,
    Expression<String>? billingCycle,
    Expression<DateTime>? nextBillingDate,
    Expression<String>? category,
    Expression<String>? status,
    Expression<String>? source,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (merchant != null) 'merchant': merchant,
      if (amount != null) 'amount': amount,
      if (currency != null) 'currency': currency,
      if (billingCycle != null) 'billing_cycle': billingCycle,
      if (nextBillingDate != null) 'next_billing_date': nextBillingDate,
      if (category != null) 'category': category,
      if (status != null) 'status': status,
      if (source != null) 'source': source,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubscriptionEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? merchant,
    Value<double>? amount,
    Value<String>? currency,
    Value<String>? billingCycle,
    Value<DateTime>? nextBillingDate,
    Value<String>? category,
    Value<String>? status,
    Value<String>? source,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SubscriptionEntriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      merchant: merchant ?? this.merchant,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      billingCycle: billingCycle ?? this.billingCycle,
      nextBillingDate: nextBillingDate ?? this.nextBillingDate,
      category: category ?? this.category,
      status: status ?? this.status,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
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
    if (merchant.present) {
      map['merchant'] = Variable<String>(merchant.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (billingCycle.present) {
      map['billing_cycle'] = Variable<String>(billingCycle.value);
    }
    if (nextBillingDate.present) {
      map['next_billing_date'] = Variable<DateTime>(nextBillingDate.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
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
    return (StringBuffer('SubscriptionEntriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('merchant: $merchant, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('billingCycle: $billingCycle, ')
          ..write('nextBillingDate: $nextBillingDate, ')
          ..write('category: $category, ')
          ..write('status: $status, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TrialEntriesTable extends TrialEntries
    with TableInfo<$TrialEntriesTable, TrialRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrialEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subscriptionNameMeta = const VerificationMeta(
    'subscriptionName',
  );
  @override
  late final GeneratedColumn<String> subscriptionName = GeneratedColumn<String>(
    'subscription_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountAfterTrialMeta = const VerificationMeta(
    'amountAfterTrial',
  );
  @override
  late final GeneratedColumn<double> amountAfterTrial = GeneratedColumn<double>(
    'amount_after_trial',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trialEndDateMeta = const VerificationMeta(
    'trialEndDate',
  );
  @override
  late final GeneratedColumn<DateTime> trialEndDate = GeneratedColumn<DateTime>(
    'trial_end_date',
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
    subscriptionName,
    amountAfterTrial,
    currency,
    trialEndDate,
    status,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trials';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrialRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('subscription_name')) {
      context.handle(
        _subscriptionNameMeta,
        subscriptionName.isAcceptableOrUnknown(
          data['subscription_name']!,
          _subscriptionNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_subscriptionNameMeta);
    }
    if (data.containsKey('amount_after_trial')) {
      context.handle(
        _amountAfterTrialMeta,
        amountAfterTrial.isAcceptableOrUnknown(
          data['amount_after_trial']!,
          _amountAfterTrialMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountAfterTrialMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('trial_end_date')) {
      context.handle(
        _trialEndDateMeta,
        trialEndDate.isAcceptableOrUnknown(
          data['trial_end_date']!,
          _trialEndDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_trialEndDateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
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
  TrialRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrialRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      subscriptionName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subscription_name'],
      )!,
      amountAfterTrial: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount_after_trial'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      trialEndDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}trial_end_date'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TrialEntriesTable createAlias(String alias) {
    return $TrialEntriesTable(attachedDatabase, alias);
  }
}

class TrialRow extends DataClass implements Insertable<TrialRow> {
  final String id;
  final String subscriptionName;
  final double amountAfterTrial;
  final String currency;
  final DateTime trialEndDate;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TrialRow({
    required this.id,
    required this.subscriptionName,
    required this.amountAfterTrial,
    required this.currency,
    required this.trialEndDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['subscription_name'] = Variable<String>(subscriptionName);
    map['amount_after_trial'] = Variable<double>(amountAfterTrial);
    map['currency'] = Variable<String>(currency);
    map['trial_end_date'] = Variable<DateTime>(trialEndDate);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TrialEntriesCompanion toCompanion(bool nullToAbsent) {
    return TrialEntriesCompanion(
      id: Value(id),
      subscriptionName: Value(subscriptionName),
      amountAfterTrial: Value(amountAfterTrial),
      currency: Value(currency),
      trialEndDate: Value(trialEndDate),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TrialRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrialRow(
      id: serializer.fromJson<String>(json['id']),
      subscriptionName: serializer.fromJson<String>(json['subscriptionName']),
      amountAfterTrial: serializer.fromJson<double>(json['amountAfterTrial']),
      currency: serializer.fromJson<String>(json['currency']),
      trialEndDate: serializer.fromJson<DateTime>(json['trialEndDate']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'subscriptionName': serializer.toJson<String>(subscriptionName),
      'amountAfterTrial': serializer.toJson<double>(amountAfterTrial),
      'currency': serializer.toJson<String>(currency),
      'trialEndDate': serializer.toJson<DateTime>(trialEndDate),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TrialRow copyWith({
    String? id,
    String? subscriptionName,
    double? amountAfterTrial,
    String? currency,
    DateTime? trialEndDate,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TrialRow(
    id: id ?? this.id,
    subscriptionName: subscriptionName ?? this.subscriptionName,
    amountAfterTrial: amountAfterTrial ?? this.amountAfterTrial,
    currency: currency ?? this.currency,
    trialEndDate: trialEndDate ?? this.trialEndDate,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TrialRow copyWithCompanion(TrialEntriesCompanion data) {
    return TrialRow(
      id: data.id.present ? data.id.value : this.id,
      subscriptionName: data.subscriptionName.present
          ? data.subscriptionName.value
          : this.subscriptionName,
      amountAfterTrial: data.amountAfterTrial.present
          ? data.amountAfterTrial.value
          : this.amountAfterTrial,
      currency: data.currency.present ? data.currency.value : this.currency,
      trialEndDate: data.trialEndDate.present
          ? data.trialEndDate.value
          : this.trialEndDate,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrialRow(')
          ..write('id: $id, ')
          ..write('subscriptionName: $subscriptionName, ')
          ..write('amountAfterTrial: $amountAfterTrial, ')
          ..write('currency: $currency, ')
          ..write('trialEndDate: $trialEndDate, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    subscriptionName,
    amountAfterTrial,
    currency,
    trialEndDate,
    status,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrialRow &&
          other.id == this.id &&
          other.subscriptionName == this.subscriptionName &&
          other.amountAfterTrial == this.amountAfterTrial &&
          other.currency == this.currency &&
          other.trialEndDate == this.trialEndDate &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TrialEntriesCompanion extends UpdateCompanion<TrialRow> {
  final Value<String> id;
  final Value<String> subscriptionName;
  final Value<double> amountAfterTrial;
  final Value<String> currency;
  final Value<DateTime> trialEndDate;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TrialEntriesCompanion({
    this.id = const Value.absent(),
    this.subscriptionName = const Value.absent(),
    this.amountAfterTrial = const Value.absent(),
    this.currency = const Value.absent(),
    this.trialEndDate = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TrialEntriesCompanion.insert({
    required String id,
    required String subscriptionName,
    required double amountAfterTrial,
    required String currency,
    required DateTime trialEndDate,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       subscriptionName = Value(subscriptionName),
       amountAfterTrial = Value(amountAfterTrial),
       currency = Value(currency),
       trialEndDate = Value(trialEndDate),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TrialRow> custom({
    Expression<String>? id,
    Expression<String>? subscriptionName,
    Expression<double>? amountAfterTrial,
    Expression<String>? currency,
    Expression<DateTime>? trialEndDate,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subscriptionName != null) 'subscription_name': subscriptionName,
      if (amountAfterTrial != null) 'amount_after_trial': amountAfterTrial,
      if (currency != null) 'currency': currency,
      if (trialEndDate != null) 'trial_end_date': trialEndDate,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TrialEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? subscriptionName,
    Value<double>? amountAfterTrial,
    Value<String>? currency,
    Value<DateTime>? trialEndDate,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TrialEntriesCompanion(
      id: id ?? this.id,
      subscriptionName: subscriptionName ?? this.subscriptionName,
      amountAfterTrial: amountAfterTrial ?? this.amountAfterTrial,
      currency: currency ?? this.currency,
      trialEndDate: trialEndDate ?? this.trialEndDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
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
    if (subscriptionName.present) {
      map['subscription_name'] = Variable<String>(subscriptionName.value);
    }
    if (amountAfterTrial.present) {
      map['amount_after_trial'] = Variable<double>(amountAfterTrial.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (trialEndDate.present) {
      map['trial_end_date'] = Variable<DateTime>(trialEndDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
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
    return (StringBuffer('TrialEntriesCompanion(')
          ..write('id: $id, ')
          ..write('subscriptionName: $subscriptionName, ')
          ..write('amountAfterTrial: $amountAfterTrial, ')
          ..write('currency: $currency, ')
          ..write('trialEndDate: $trialEndDate, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsageEntriesTable extends UsageEntries
    with TableInfo<$UsageEntriesTable, UsageRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsageEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _subscriptionIdMeta = const VerificationMeta(
    'subscriptionId',
  );
  @override
  late final GeneratedColumn<String> subscriptionId = GeneratedColumn<String>(
    'subscription_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _useCountMeta = const VerificationMeta(
    'useCount',
  );
  @override
  late final GeneratedColumn<int> useCount = GeneratedColumn<int>(
    'use_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
  @override
  List<GeneratedColumn> get $columns => [subscriptionId, useCount, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'usage';
  @override
  VerificationContext validateIntegrity(
    Insertable<UsageRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('subscription_id')) {
      context.handle(
        _subscriptionIdMeta,
        subscriptionId.isAcceptableOrUnknown(
          data['subscription_id']!,
          _subscriptionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_subscriptionIdMeta);
    }
    if (data.containsKey('use_count')) {
      context.handle(
        _useCountMeta,
        useCount.isAcceptableOrUnknown(data['use_count']!, _useCountMeta),
      );
    } else if (isInserting) {
      context.missing(_useCountMeta);
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
  Set<GeneratedColumn> get $primaryKey => {subscriptionId};
  @override
  UsageRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsageRow(
      subscriptionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subscription_id'],
      )!,
      useCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}use_count'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UsageEntriesTable createAlias(String alias) {
    return $UsageEntriesTable(attachedDatabase, alias);
  }
}

class UsageRow extends DataClass implements Insertable<UsageRow> {
  final String subscriptionId;
  final int useCount;
  final DateTime updatedAt;
  const UsageRow({
    required this.subscriptionId,
    required this.useCount,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['subscription_id'] = Variable<String>(subscriptionId);
    map['use_count'] = Variable<int>(useCount);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UsageEntriesCompanion toCompanion(bool nullToAbsent) {
    return UsageEntriesCompanion(
      subscriptionId: Value(subscriptionId),
      useCount: Value(useCount),
      updatedAt: Value(updatedAt),
    );
  }

  factory UsageRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsageRow(
      subscriptionId: serializer.fromJson<String>(json['subscriptionId']),
      useCount: serializer.fromJson<int>(json['useCount']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'subscriptionId': serializer.toJson<String>(subscriptionId),
      'useCount': serializer.toJson<int>(useCount),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UsageRow copyWith({
    String? subscriptionId,
    int? useCount,
    DateTime? updatedAt,
  }) => UsageRow(
    subscriptionId: subscriptionId ?? this.subscriptionId,
    useCount: useCount ?? this.useCount,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UsageRow copyWithCompanion(UsageEntriesCompanion data) {
    return UsageRow(
      subscriptionId: data.subscriptionId.present
          ? data.subscriptionId.value
          : this.subscriptionId,
      useCount: data.useCount.present ? data.useCount.value : this.useCount,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsageRow(')
          ..write('subscriptionId: $subscriptionId, ')
          ..write('useCount: $useCount, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(subscriptionId, useCount, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsageRow &&
          other.subscriptionId == this.subscriptionId &&
          other.useCount == this.useCount &&
          other.updatedAt == this.updatedAt);
}

class UsageEntriesCompanion extends UpdateCompanion<UsageRow> {
  final Value<String> subscriptionId;
  final Value<int> useCount;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UsageEntriesCompanion({
    this.subscriptionId = const Value.absent(),
    this.useCount = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsageEntriesCompanion.insert({
    required String subscriptionId,
    required int useCount,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : subscriptionId = Value(subscriptionId),
       useCount = Value(useCount),
       updatedAt = Value(updatedAt);
  static Insertable<UsageRow> custom({
    Expression<String>? subscriptionId,
    Expression<int>? useCount,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (subscriptionId != null) 'subscription_id': subscriptionId,
      if (useCount != null) 'use_count': useCount,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsageEntriesCompanion copyWith({
    Value<String>? subscriptionId,
    Value<int>? useCount,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return UsageEntriesCompanion(
      subscriptionId: subscriptionId ?? this.subscriptionId,
      useCount: useCount ?? this.useCount,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (subscriptionId.present) {
      map['subscription_id'] = Variable<String>(subscriptionId.value);
    }
    if (useCount.present) {
      map['use_count'] = Variable<int>(useCount.value);
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
    return (StringBuffer('UsageEntriesCompanion(')
          ..write('subscriptionId: $subscriptionId, ')
          ..write('useCount: $useCount, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SubscriptionEntriesTable subscriptionEntries =
      $SubscriptionEntriesTable(this);
  late final $TrialEntriesTable trialEntries = $TrialEntriesTable(this);
  late final $UsageEntriesTable usageEntries = $UsageEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    subscriptionEntries,
    trialEntries,
    usageEntries,
  ];
}

typedef $$SubscriptionEntriesTableCreateCompanionBuilder =
    SubscriptionEntriesCompanion Function({
      required String id,
      required String name,
      required String merchant,
      required double amount,
      required String currency,
      required String billingCycle,
      required DateTime nextBillingDate,
      required String category,
      required String status,
      required String source,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SubscriptionEntriesTableUpdateCompanionBuilder =
    SubscriptionEntriesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> merchant,
      Value<double> amount,
      Value<String> currency,
      Value<String> billingCycle,
      Value<DateTime> nextBillingDate,
      Value<String> category,
      Value<String> status,
      Value<String> source,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SubscriptionEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $SubscriptionEntriesTable> {
  $$SubscriptionEntriesTableFilterComposer({
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

  ColumnFilters<String> get merchant => $composableBuilder(
    column: $table.merchant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get billingCycle => $composableBuilder(
    column: $table.billingCycle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextBillingDate => $composableBuilder(
    column: $table.nextBillingDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SubscriptionEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SubscriptionEntriesTable> {
  $$SubscriptionEntriesTableOrderingComposer({
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

  ColumnOrderings<String> get merchant => $composableBuilder(
    column: $table.merchant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get billingCycle => $composableBuilder(
    column: $table.billingCycle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextBillingDate => $composableBuilder(
    column: $table.nextBillingDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SubscriptionEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubscriptionEntriesTable> {
  $$SubscriptionEntriesTableAnnotationComposer({
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

  GeneratedColumn<String> get merchant =>
      $composableBuilder(column: $table.merchant, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get billingCycle => $composableBuilder(
    column: $table.billingCycle,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextBillingDate => $composableBuilder(
    column: $table.nextBillingDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SubscriptionEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubscriptionEntriesTable,
          SubscriptionRow,
          $$SubscriptionEntriesTableFilterComposer,
          $$SubscriptionEntriesTableOrderingComposer,
          $$SubscriptionEntriesTableAnnotationComposer,
          $$SubscriptionEntriesTableCreateCompanionBuilder,
          $$SubscriptionEntriesTableUpdateCompanionBuilder,
          (
            SubscriptionRow,
            BaseReferences<
              _$AppDatabase,
              $SubscriptionEntriesTable,
              SubscriptionRow
            >,
          ),
          SubscriptionRow,
          PrefetchHooks Function()
        > {
  $$SubscriptionEntriesTableTableManager(
    _$AppDatabase db,
    $SubscriptionEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubscriptionEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubscriptionEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SubscriptionEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> merchant = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> billingCycle = const Value.absent(),
                Value<DateTime> nextBillingDate = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubscriptionEntriesCompanion(
                id: id,
                name: name,
                merchant: merchant,
                amount: amount,
                currency: currency,
                billingCycle: billingCycle,
                nextBillingDate: nextBillingDate,
                category: category,
                status: status,
                source: source,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String merchant,
                required double amount,
                required String currency,
                required String billingCycle,
                required DateTime nextBillingDate,
                required String category,
                required String status,
                required String source,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SubscriptionEntriesCompanion.insert(
                id: id,
                name: name,
                merchant: merchant,
                amount: amount,
                currency: currency,
                billingCycle: billingCycle,
                nextBillingDate: nextBillingDate,
                category: category,
                status: status,
                source: source,
                createdAt: createdAt,
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

typedef $$SubscriptionEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubscriptionEntriesTable,
      SubscriptionRow,
      $$SubscriptionEntriesTableFilterComposer,
      $$SubscriptionEntriesTableOrderingComposer,
      $$SubscriptionEntriesTableAnnotationComposer,
      $$SubscriptionEntriesTableCreateCompanionBuilder,
      $$SubscriptionEntriesTableUpdateCompanionBuilder,
      (
        SubscriptionRow,
        BaseReferences<
          _$AppDatabase,
          $SubscriptionEntriesTable,
          SubscriptionRow
        >,
      ),
      SubscriptionRow,
      PrefetchHooks Function()
    >;
typedef $$TrialEntriesTableCreateCompanionBuilder =
    TrialEntriesCompanion Function({
      required String id,
      required String subscriptionName,
      required double amountAfterTrial,
      required String currency,
      required DateTime trialEndDate,
      required String status,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$TrialEntriesTableUpdateCompanionBuilder =
    TrialEntriesCompanion Function({
      Value<String> id,
      Value<String> subscriptionName,
      Value<double> amountAfterTrial,
      Value<String> currency,
      Value<DateTime> trialEndDate,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$TrialEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $TrialEntriesTable> {
  $$TrialEntriesTableFilterComposer({
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

  ColumnFilters<String> get subscriptionName => $composableBuilder(
    column: $table.subscriptionName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amountAfterTrial => $composableBuilder(
    column: $table.amountAfterTrial,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get trialEndDate => $composableBuilder(
    column: $table.trialEndDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TrialEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $TrialEntriesTable> {
  $$TrialEntriesTableOrderingComposer({
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

  ColumnOrderings<String> get subscriptionName => $composableBuilder(
    column: $table.subscriptionName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amountAfterTrial => $composableBuilder(
    column: $table.amountAfterTrial,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get trialEndDate => $composableBuilder(
    column: $table.trialEndDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TrialEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrialEntriesTable> {
  $$TrialEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get subscriptionName => $composableBuilder(
    column: $table.subscriptionName,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amountAfterTrial => $composableBuilder(
    column: $table.amountAfterTrial,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<DateTime> get trialEndDate => $composableBuilder(
    column: $table.trialEndDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TrialEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrialEntriesTable,
          TrialRow,
          $$TrialEntriesTableFilterComposer,
          $$TrialEntriesTableOrderingComposer,
          $$TrialEntriesTableAnnotationComposer,
          $$TrialEntriesTableCreateCompanionBuilder,
          $$TrialEntriesTableUpdateCompanionBuilder,
          (
            TrialRow,
            BaseReferences<_$AppDatabase, $TrialEntriesTable, TrialRow>,
          ),
          TrialRow,
          PrefetchHooks Function()
        > {
  $$TrialEntriesTableTableManager(_$AppDatabase db, $TrialEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrialEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrialEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrialEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> subscriptionName = const Value.absent(),
                Value<double> amountAfterTrial = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<DateTime> trialEndDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrialEntriesCompanion(
                id: id,
                subscriptionName: subscriptionName,
                amountAfterTrial: amountAfterTrial,
                currency: currency,
                trialEndDate: trialEndDate,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String subscriptionName,
                required double amountAfterTrial,
                required String currency,
                required DateTime trialEndDate,
                required String status,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => TrialEntriesCompanion.insert(
                id: id,
                subscriptionName: subscriptionName,
                amountAfterTrial: amountAfterTrial,
                currency: currency,
                trialEndDate: trialEndDate,
                status: status,
                createdAt: createdAt,
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

typedef $$TrialEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrialEntriesTable,
      TrialRow,
      $$TrialEntriesTableFilterComposer,
      $$TrialEntriesTableOrderingComposer,
      $$TrialEntriesTableAnnotationComposer,
      $$TrialEntriesTableCreateCompanionBuilder,
      $$TrialEntriesTableUpdateCompanionBuilder,
      (TrialRow, BaseReferences<_$AppDatabase, $TrialEntriesTable, TrialRow>),
      TrialRow,
      PrefetchHooks Function()
    >;
typedef $$UsageEntriesTableCreateCompanionBuilder =
    UsageEntriesCompanion Function({
      required String subscriptionId,
      required int useCount,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$UsageEntriesTableUpdateCompanionBuilder =
    UsageEntriesCompanion Function({
      Value<String> subscriptionId,
      Value<int> useCount,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$UsageEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $UsageEntriesTable> {
  $$UsageEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get subscriptionId => $composableBuilder(
    column: $table.subscriptionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get useCount => $composableBuilder(
    column: $table.useCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsageEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $UsageEntriesTable> {
  $$UsageEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get subscriptionId => $composableBuilder(
    column: $table.subscriptionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get useCount => $composableBuilder(
    column: $table.useCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsageEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsageEntriesTable> {
  $$UsageEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get subscriptionId => $composableBuilder(
    column: $table.subscriptionId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get useCount =>
      $composableBuilder(column: $table.useCount, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UsageEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsageEntriesTable,
          UsageRow,
          $$UsageEntriesTableFilterComposer,
          $$UsageEntriesTableOrderingComposer,
          $$UsageEntriesTableAnnotationComposer,
          $$UsageEntriesTableCreateCompanionBuilder,
          $$UsageEntriesTableUpdateCompanionBuilder,
          (
            UsageRow,
            BaseReferences<_$AppDatabase, $UsageEntriesTable, UsageRow>,
          ),
          UsageRow,
          PrefetchHooks Function()
        > {
  $$UsageEntriesTableTableManager(_$AppDatabase db, $UsageEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsageEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsageEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsageEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> subscriptionId = const Value.absent(),
                Value<int> useCount = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsageEntriesCompanion(
                subscriptionId: subscriptionId,
                useCount: useCount,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String subscriptionId,
                required int useCount,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => UsageEntriesCompanion.insert(
                subscriptionId: subscriptionId,
                useCount: useCount,
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

typedef $$UsageEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsageEntriesTable,
      UsageRow,
      $$UsageEntriesTableFilterComposer,
      $$UsageEntriesTableOrderingComposer,
      $$UsageEntriesTableAnnotationComposer,
      $$UsageEntriesTableCreateCompanionBuilder,
      $$UsageEntriesTableUpdateCompanionBuilder,
      (UsageRow, BaseReferences<_$AppDatabase, $UsageEntriesTable, UsageRow>),
      UsageRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SubscriptionEntriesTableTableManager get subscriptionEntries =>
      $$SubscriptionEntriesTableTableManager(_db, _db.subscriptionEntries);
  $$TrialEntriesTableTableManager get trialEntries =>
      $$TrialEntriesTableTableManager(_db, _db.trialEntries);
  $$UsageEntriesTableTableManager get usageEntries =>
      $$UsageEntriesTableTableManager(_db, _db.usageEntries);
}
