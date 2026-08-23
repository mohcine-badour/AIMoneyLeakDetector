import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kichta/core/database/app_database.dart';
import 'package:kichta/core/security/document_store.dart';
import 'package:kichta/core/security/in_memory_secure_store.dart';
import 'package:kichta/features/notifications/domain/reminder_scheduler.dart';
import 'package:kichta/features/notifications/domain/scheduled_reminder.dart';
import 'package:kichta/features/onboarding/data/onboarding_repository.dart';
import 'package:kichta/features/auth/data/guest_session_repository.dart';
import 'package:kichta/features/onboarding/domain/onboarding_answers.dart';
import 'package:kichta/features/settings/domain/local_data_eraser.dart';
import 'package:kichta/features/subscriptions/data/drift_subscription_repository.dart';
import 'package:kichta/features/subscriptions/domain/subscription.dart';
import 'package:kichta/features/trials/data/drift_trial_repository.dart';
import 'package:kichta/features/trials/domain/trial.dart';

class _RecordingReminders implements ReminderScheduler {
  List<ScheduledReminder>? last;

  @override
  Future<void> sync(List<ScheduledReminder> reminders) async {
    last = reminders;
  }

  @override
  Future<bool> requestPermission() async => true;
}

void main() {
  test('erasing local data removes records, tokens, and documents', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    await DriftSubscriptionRepository(database).save(
      Subscription.create(
        id: 'netflix',
        name: 'Netflix',
        merchant: 'Netflix',
        amount: 22.99,
        billingCycle: BillingCycle.monthly,
        nextBillingDate: DateTime.utc(2026, 9, 3),
        category: SubscriptionCategory.entertainment,
      ),
    );
    await DriftTrialRepository(database).save(
      Trial.create(
        id: 'chatgpt',
        subscriptionName: 'ChatGPT',
        amountAfterTrial: 20,
        trialEndDate: DateTime.utc(2026, 8, 26),
      ),
    );
    final onboarding = OnboardingRepository(prefs);
    await onboarding.save(
      OnboardingAnswers(
        spendingRange: SpendingRange.from50to100,
        savingsGoal: SavingsGoal.amount50,
        entryPath: OnboardingEntryPath.addManually,
        completedAt: DateTime.utc(2026, 8, 21),
      ),
    );
    final guestSession = GuestSessionRepository(prefs);
    await guestSession.create();
    final store = InMemorySecureStore();
    await store.write(key: 'token.session', value: 'abc');
    final documents = EphemeralDocumentStore();
    await documents.hold(Uint8List.fromList([9, 8, 7]));
    await prefs.setStringList('insights/dismissed', ['overlap-netflix']);
    await prefs.setBool('reminders/enabled', false);
    final reminders = _RecordingReminders();

    final eraser = LocalDataEraser(
      database: database,
      onboarding: onboarding,
      guestSession: guestSession,
      reminders: reminders,
      secureStore: store,
      documents: documents,
      preferences: prefs,
    );

    final result = await eraser.erase(ErasureKind.account);

    expect(result.localDataRemoved, isTrue);
    expect(result.cloudDeletionPending, isFalse);
    expect(result.appStoreSubscriptionUnchanged, isTrue);
    expect(await DriftSubscriptionRepository(database).getAll(), isEmpty);
    expect(await DriftTrialRepository(database).getAll(), isEmpty);
    expect(onboarding.isCompleted, isFalse);
    expect(guestSession.hasSession, isFalse);
    expect(await store.read('token.session'), isNull);
    expect(documents.currentBytes, isNull);
    expect(reminders.last, isEmpty);
    expect(prefs.getStringList('insights/dismissed'), isNull);
    expect(prefs.getBool('reminders/enabled'), isNull);
  });
}
