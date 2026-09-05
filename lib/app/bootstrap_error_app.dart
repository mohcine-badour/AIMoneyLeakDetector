import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import 'theme/app_theme.dart';

/// Minimal fallback shown when critical startup (the encrypted database) fails,
/// so a boot error is a readable screen with a retry — not a blank crash. Runs
/// outside the ProviderScope, so it depends on nothing but the theme.
class BootstrapErrorApp extends StatelessWidget {
  const BootstrapErrorApp({required this.onRetry, super.key});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.dark,
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppStrings.bootstrapErrorTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppStrings.bootstrapErrorMessage,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () => onRetry(),
                    child: const Text(AppStrings.bootstrapErrorRetry),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
