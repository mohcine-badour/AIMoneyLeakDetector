import 'package:drift/drift.dart';

import 'database_encryption.dart';

part 'app_database.g.dart';

@DataClassName('SubscriptionRow')
class SubscriptionEntries extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get merchant => text()();
  RealColumn get amount => real()();
  TextColumn get currency => text()();
  TextColumn get billingCycle => text()();
  DateTimeColumn get nextBillingDate => dateTime()();
  TextColumn get category => text()();
  TextColumn get status => text()();
  TextColumn get source => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  String get tableName => 'subscriptions';

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('TrialRow')
class TrialEntries extends Table {
  TextColumn get id => text()();
  TextColumn get subscriptionName => text()();
  RealColumn get amountAfterTrial => real()();
  TextColumn get currency => text()();
  DateTimeColumn get trialEndDate => dateTime()();
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  String get tableName => 'trials';

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('UsageRow')
class UsageEntries extends Table {
  TextColumn get subscriptionId => text()();
  IntColumn get useCount => integer()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  String get tableName => 'usage';

  @override
  Set<Column<Object>> get primaryKey => {subscriptionId};
}

@DriftDatabase(tables: [SubscriptionEntries, TrialEntries, UsageEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? DatabaseEncryption.open(_requireKey()));

  factory AppDatabase.encrypted(String key) {
    return AppDatabase(DatabaseEncryption.open(key));
  }

  static String? _encryptionKey;

  static void bindEncryptionKey(String key) {
    _encryptionKey = key;
  }

  static String _requireKey() {
    final key = _encryptionKey;
    if (key == null || key.isEmpty) {
      throw StateError(
        'Open AppDatabase.encrypted after loading the Keychain key.',
      );
    }
    return key;
  }

  @override
  int get schemaVersion => 3;

  Future<void> eraseAllUserData() async {
    await transaction(() async {
      await delete(usageEntries).go();
      await delete(trialEntries).go();
      await delete(subscriptionEntries).go();
    });
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (migrator) async {
        await migrator.createAll();
      },
      onUpgrade: (migrator, from, to) async {
        if (from < 2) {
          await migrator.createTable(trialEntries);
        }
        if (from < 3) {
          await migrator.createTable(usageEntries);
        }
      },
    );
  }
}
