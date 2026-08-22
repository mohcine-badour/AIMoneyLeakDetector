import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_routes.dart';
import 'paywall_providers.dart';

/// Opens a feature or the paywall when the free limit is reached.
abstract final class PaywallNavigation {
  static void addSubscription(
    BuildContext context,
    WidgetRef ref, {
    bool replace = false,
  }) {
    _open(
      context,
      AppRoutes.addSubscription,
      ref.read(featureAccessProvider).canAddSubscription,
      replace: replace,
    );
  }

  static void addTrial(
    BuildContext context,
    WidgetRef ref, {
    bool replace = false,
  }) {
    _open(
      context,
      AppRoutes.addTrial,
      ref.read(featureAccessProvider).canAddTrial,
      replace: replace,
    );
  }

  static void scanReceipt(
    BuildContext context,
    WidgetRef ref, {
    bool replace = false,
  }) {
    _open(
      context,
      AppRoutes.scanReceipt,
      ref.read(featureAccessProvider).canUseScanner,
      replace: replace,
    );
  }

  static void savings(
    BuildContext context,
    WidgetRef ref, {
    bool replace = false,
  }) {
    _open(
      context,
      AppRoutes.savings,
      ref.read(featureAccessProvider).canUseAiAnalysis,
      replace: replace,
    );
  }

  static void paywall(BuildContext context, {bool replace = false}) {
    _open(context, AppRoutes.paywall, true, replace: replace);
  }

  static void _open(
    BuildContext context,
    String location,
    bool allowed, {
    required bool replace,
  }) {
    final route = allowed ? location : AppRoutes.paywall;
    if (replace) {
      context.go(route);
    } else {
      context.push(route);
    }
  }
}
