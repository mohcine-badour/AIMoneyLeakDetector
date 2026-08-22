import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/providers/app_database_provider.dart';
import '../../../core/security/security_providers.dart';
import '../notifications/notifications_providers.dart';
import '../onboarding/data/onboarding_repository.dart';
import '../subscriptions/subscriptions_providers.dart';
import '../subscriptions/usage_controller.dart';
import '../trials/trials_providers.dart';
import 'domain/local_data_eraser.dart';

final dataEraserProvider = Provider<LocalDataEraser>((ref) {
  return LocalDataEraser(
    database: ref.watch(appDatabaseProvider),
    onboarding: ref.watch(onboardingRepositoryProvider),
    reminders: ref.watch(reminderSchedulerProvider),
    secureStore: ref.watch(secureStoreProvider),
    documents: ref.watch(documentStoreProvider),
  );
});

final privacyActionProvider =
    NotifierProvider<PrivacyActionController, PrivacyActionState>(
      PrivacyActionController.new,
    );

class PrivacyActionState {
  const PrivacyActionState({this.isErasing = false, this.error});

  final bool isErasing;
  final String? error;
}

class PrivacyActionController extends Notifier<PrivacyActionState> {
  @override
  PrivacyActionState build() => const PrivacyActionState();

  Future<ErasureResult?> erase(ErasureKind kind) async {
    state = const PrivacyActionState(isErasing: true);
    try {
      final result = await ref.read(dataEraserProvider).erase(kind);
      ref.invalidate(subscriptionsProvider);
      ref.invalidate(trialsProvider);
      ref.invalidate(declaredUsageCountsProvider);
      state = const PrivacyActionState();
      return result;
    } on Object {
      state = const PrivacyActionState(error: AppStrings.deleteDataFailed);
      return null;
    }
  }
}
