import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/placeholder_screen.dart';

/// Stub until cloud sign-in ships. Welcome still offers the path.
class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: AppStrings.signIn,
      subtitle: AppStrings.signInUnavailable,
      actionLabel: AppStrings.goHome,
      onAction: () => context.go(AppRoutes.launch),
    );
  }
}
