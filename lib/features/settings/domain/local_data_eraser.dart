import '../../../core/database/app_database.dart';
import '../../../core/security/document_store.dart';
import '../../../core/security/secure_store.dart';
import '../../notifications/domain/reminder_scheduler.dart';
import '../../onboarding/data/onboarding_repository.dart';

enum ErasureKind { localData, account }

class ErasureResult {
  const ErasureResult({
    required this.kind,
    required this.localDataRemoved,
    required this.cloudDeletionPending,
    required this.appStoreSubscriptionUnchanged,
  });

  final ErasureKind kind;
  final bool localDataRemoved;
  final bool cloudDeletionPending;
  final bool appStoreSubscriptionUnchanged;
}

/// Wipes on-device user data. Does not cancel App Store billing.
class LocalDataEraser {
  const LocalDataEraser({
    required this.database,
    required this.onboarding,
    required this.reminders,
    required this.secureStore,
    required this.documents,
  });

  final AppDatabase database;
  final OnboardingRepository onboarding;
  final ReminderScheduler reminders;
  final SecureStore secureStore;
  final DocumentStore documents;

  Future<ErasureResult> erase(ErasureKind kind) async {
    await database.eraseAllUserData();
    await onboarding.clear();
    await reminders.sync(const []);
    await secureStore.clear();
    await documents.discard();
    return ErasureResult(
      kind: kind,
      localDataRemoved: true,
      cloudDeletionPending: kind == ErasureKind.account,
      appStoreSubscriptionUnchanged: true,
    );
  }
}
