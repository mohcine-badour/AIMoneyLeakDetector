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

@DriftDatabase(tables: [SubscriptionEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'billkiller'));

  @override
  int get schemaVersion => 1;
}
