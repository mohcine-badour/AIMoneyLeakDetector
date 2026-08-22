import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/features/paywall/domain/billing_snapshot.dart';
import 'package:kichta/features/paywall/domain/entitlement.dart';
import 'package:kichta/features/paywall/domain/entitlement_copy.dart';
import 'package:kichta/features/paywall/domain/entitlement_mapper.dart';
import 'package:kichta/features/paywall/domain/monetization_config.dart';
import 'package:kichta/features/paywall/domain/paywall_plan.dart';

void main() {
  const config = MonetizationConfig();

  test('active subscriptions map to Pro without trusting a local flag', () {
    final entitlement = EntitlementMapper.fromSnapshot(
      snapshot: const BillingSnapshot(
        hasEntitlementRecord: true,
        isActive: true,
        willRenew: true,
        productId: 'billkiller_pro_yearly',
      ),
      config: config,
    );

    expect(entitlement.isPro, isTrue);
    expect(entitlement.period, EntitlementPeriod.active);
    expect(entitlement.willRenew, isTrue);
    expect(entitlement.plan, PaywallPlan.yearly);
  });

  test('billing retry stays Pro during the grace period', () {
    final entitlement = EntitlementMapper.fromSnapshot(
      snapshot: const BillingSnapshot(
        hasEntitlementRecord: true,
        isActive: true,
        willRenew: true,
        hasBillingIssue: true,
        productId: 'billkiller_pro_monthly',
      ),
      config: config,
    );

    expect(entitlement.isPro, isTrue);
    expect(entitlement.period, EntitlementPeriod.gracePeriod);
    expect(EntitlementCopy.status(entitlement), isNotNull);
  });

  test('cancelled auto-renew stays Pro until expiration', () {
    final entitlement = EntitlementMapper.fromSnapshot(
      snapshot: BillingSnapshot(
        hasEntitlementRecord: true,
        isActive: true,
        willRenew: false,
        expiresAt: DateTime.utc(2026, 9, 21),
        productId: 'billkiller_pro_monthly',
      ),
      config: config,
    );

    expect(entitlement.isPro, isTrue);
    expect(entitlement.willRenew, isFalse);
  });

  test('expired entitlements are not Pro', () {
    final entitlement = EntitlementMapper.fromSnapshot(
      snapshot: BillingSnapshot(
        hasEntitlementRecord: true,
        isActive: false,
        expiresAt: DateTime.utc(2026, 7, 1),
        productId: 'billkiller_pro_monthly',
      ),
      config: config,
    );

    expect(entitlement.isPro, isFalse);
    expect(entitlement.period, EntitlementPeriod.expired);
  });

  test(
    'introductory and trial periods are marked without changing money math',
    () {
      final entitlement = EntitlementMapper.fromSnapshot(
        snapshot: const BillingSnapshot(
          hasEntitlementRecord: true,
          isActive: true,
          willRenew: true,
          isIntroductory: true,
          productId: 'billkiller_pro_yearly',
        ),
        config: config,
      );

      expect(entitlement.isPro, isTrue);
      expect(entitlement.isIntroductory, isTrue);
    },
  );
}
