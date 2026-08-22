import 'package:flutter/material.dart';

import '../../../core/constants/app_icons.dart';
import '../domain/onboarding_pages.dart';

extension OnboardingIconVisual on OnboardingIcon {
  IconData get data => switch (this) {
    OnboardingIcon.chartBar => AppIcons.chartBar,
    OnboardingIcon.apps => AppIcons.apps,
    OnboardingIcon.sparkles => AppIcons.sparkles,
    OnboardingIcon.shieldCheck => AppIcons.shieldCheck,
    OnboardingIcon.arrowRight => AppIcons.arrowRight,
    OnboardingIcon.check => AppIcons.check,
    OnboardingIcon.info => AppIcons.info,
    OnboardingIcon.swipe => AppIcons.swipe,
  };
}
