import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/router/app_router.dart';
import 'app/router/app_routes.dart';
import 'core/providers/shared_preferences_provider.dart';
import 'features/onboarding/data/onboarding_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final onboarding = OnboardingRepository(prefs);

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: BillKillerApp(
        router: AppRouter.create(
          initialLocation: onboarding.isCompleted
              ? AppRoutes.dashboard
              : AppRoutes.launch,
        ),
      ),
    ),
  );
}
