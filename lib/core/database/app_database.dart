import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

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
    : super(executor ?? driftDatabase(name: 'billkiller'));

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
