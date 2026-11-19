import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/database/app_database.dart';
import '../features/before_subscribe/domain/subscription_candidate.dart';
import '../features/cancellation/domain/cancellation_message.dart';
import '../features/cancellation/presentation/cancellation_message_dialog.dart';
import '../features/onboarding/data/onboarding_repository.dart';
import '../features/subscriptions/data/drift_subscription_repository.dart';
import '../features/subscriptions/domain/subscription.dart';
import '../features/trials/data/drift_trial_repository.dart';
import '../features/trials/domain/trial.dart';
import 'router/app_routes.dart';

/// App Store screenshot mode. Debug builds only.
///
/// Turned on with `flutter run --dart-define=STORE_SCREENSHOTS=true`; always
/// false in release, so the published app is unaffected.
///
/// On launch it replaces the local data with example subscriptions and trials
/// (generic names, no real brands), skips onboarding and opens the screen named
/// by the `shots_scene` preference:
/// `home`, `subscriptions`, `detail:<key>`, `cancel:<key>`, `cancelmsg:<key>`
/// (the guide with its message draft open), `trials`, `trial:<key>`,
/// `upcoming`, `insights`, `evaluate`, `scan`, `settings`, `privacy`, `custom`.
const bool kStoreScreenshots =
    kDebugMode && bool.fromEnvironment('STORE_SCREENSHOTS');

abstract final class StoreScreenshots {
  StoreScreenshots._();

  static const String sceneKey = 'shots_scene';
  static const String _prefix = 'shots-';

  static String _scene = 'home';
  static final Map<String, Subscription> _seeded = <String, Subscription>{};

  /// Seeds the example data and returns the first location, or null when the
  /// mode is off.
  static Future<String?> prepare(
    SharedPreferences prefs,
    AppDatabase database,
  ) async {
    if (!kStoreScreenshots) return null;
    _scene = prefs.getString(sceneKey) ?? 'home';
    await prefs.setBool(OnboardingRepository.completedKey, true);
    try {
      await _seed(database);
    } catch (error, stack) {
      debugPrint('[Shots] seed failed: $error\n$stack');
    }
    return _initialLocation(_scene);
  }

  /// Opens scenes that need a pushed route or a dialog after the first frame.
  static void afterStart(GoRouter router) {
    if (!kStoreScreenshots) return;
    if (_scene == 'evaluate') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        router.push(AppRoutes.beforeYouSubscribe, extra: _candidate());
      });
    } else if (_scene.startsWith('cancelmsg:')) {
      final sub = _seeded['$_prefix${_scene.split(':')[1]}'];
      if (sub == null) return;
      // Same draft as the guide's "Generate cancellation message" button.
      Future<void>.delayed(const Duration(milliseconds: 1500), () {
        final context = router.routerDelegate.navigatorKey.currentContext;
        if (context == null || !context.mounted) return;
        showCancellationMessageDialog(
          context: context,
          message: CancellationMessage.compose(
            merchant: sub.merchant,
            subscriptionName: sub.name,
            nextBillingDate: sub.nextBillingDate,
          ),
        );
      });
    }
  }

  static String _initialLocation(String scene) {
    final parts = scene.split(':');
    final key = parts.length > 1 ? parts[1] : '';
    return switch (parts.first) {
      'subscriptions' || 'evaluate' => AppRoutes.subscriptions,
      'detail' => AppRoutes.subscriptionDetailLocation('$_prefix$key'),
      'cancel' ||
      'cancelmsg' => AppRoutes.cancellationGuideLocation('$_prefix$key'),
      'trials' => AppRoutes.trials,
      'trial' => AppRoutes.trialDetailLocation('${_prefix}trial-$key'),
      'upcoming' => AppRoutes.upcoming,
      'insights' => AppRoutes.savings,
      'scan' => AppRoutes.scanReceipt,
      'settings' => AppRoutes.settings,
      'privacy' => AppRoutes.privacyPolicy,
      'custom' => AppRoutes.addCustomSubscription,
      _ => AppRoutes.dashboard,
    };
  }

  static DateTime _inDays(int days) {
    final now = DateTime.now();
    final date = DateTime(now.year, now.month, now.day + days);
    return DateTime.utc(date.year, date.month, date.day);
  }

  static Future<void> _seed(AppDatabase database) async {
    final subscriptions = DriftSubscriptionRepository(database);
    final trials = DriftTrialRepository(database);

    for (final existing in await subscriptions.getAll()) {
      await subscriptions.deleteById(existing.id);
    }
    for (final existing in await trials.getAll()) {
      await trials.deleteById(existing.id);
    }

    final created = DateTime.now().toUtc().subtract(const Duration(days: 40));
    Subscription sub(
      String key,
      String name,
      double amount,
      SubscriptionCategory category,
      int days, {
      BillingCycle cycle = BillingCycle.monthly,
      String? merchant,
    }) {
      return Subscription.create(
        id: '$_prefix$key',
        name: name,
        merchant: merchant ?? name,
        amount: amount,
        billingCycle: cycle,
        nextBillingDate: _inDays(days),
        category: category,
        createdAt: created,
        updatedAt: created,
      );
    }

    final examples = <Subscription>[
      sub(
        'streaming',
        'Streaming',
        15.49,
        SubscriptionCategory.entertainment,
        1,
      ),
      sub(
        'gym',
        'Gym membership',
        34,
        SubscriptionCategory.fitness,
        3,
        merchant: 'City gym',
      ),
      sub('design', 'Design app', 9.99, SubscriptionCategory.software, 6),
      sub('movies', 'Movie club', 11.99, SubscriptionCategory.entertainment, 9),
      sub('music', 'Music', 10.99, SubscriptionCategory.entertainment, 12),
      sub(
        'cloud',
        'Cloud storage',
        29.99,
        SubscriptionCategory.cloudStorage,
        14,
        cycle: BillingCycle.yearly,
      ),
      sub('news', 'News', 8, SubscriptionCategory.news, 17),
      sub(
        'language',
        'Language course',
        12.99,
        SubscriptionCategory.education,
        24,
      ),
    ];
    for (final item in examples) {
      _seeded[item.id] = item;
      await subscriptions.save(item);
    }

    Trial trial(String key, String name, double after, int days) {
      return Trial.create(
        id: '${_prefix}trial-$key',
        subscriptionName: name,
        amountAfterTrial: after,
        trialEndDate: _inDays(days),
        createdAt: created,
        updatedAt: created,
      );
    }

    for (final item in <Trial>[
      trial('photo', 'Photo editor', 7.99, 2),
      trial('meditation', 'Meditation', 12.99, 6),
      trial('meals', 'Meal plans', 9.99, 11),
    ]) {
      await trials.save(item);
    }
  }

  static SubscriptionCandidate _candidate() {
    return SubscriptionCandidate(
      name: 'Series plus',
      merchant: 'Series plus',
      amount: 13.99,
      currency: 'USD',
      billingCycle: BillingCycle.monthly,
      nextBillingDate: _inDays(30),
      category: SubscriptionCategory.entertainment,
    );
  }
}
