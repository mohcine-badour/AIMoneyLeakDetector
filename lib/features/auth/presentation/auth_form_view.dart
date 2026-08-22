import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_brand_icon.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../onboarding/data/onboarding_repository.dart';
import '../auth_form_controller.dart';
import '../domain/auth_form_validator.dart';

class AuthFormView extends ConsumerStatefulWidget {
  const AuthFormView({required this.isRegister, super.key});

  final bool isRegister;

  @override
  ConsumerState<AuthFormView> createState() => _AuthFormViewState();
}

class _AuthFormViewState extends ConsumerState<AuthFormView> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  var _hidePassword = true;
  var _hideConfirm = true;
  var _errors = const AuthFormErrors();
  late bool _isRegister;

  @override
  void initState() {
    super.initState();
    _isRegister = widget.isRegister;
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pending = ref.watch(authFormActionProvider).pending;
    return AppScaffold(
      showAppBar: false,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.sm,
        AppSpacing.page,
        AppSpacing.lg,
      ),
      body: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _BackButton(),
            Expanded(
              child: ListView(
                children: [
                  const SizedBox(height: 12),
                  _AuthHero(isRegister: _isRegister),
                  const SizedBox(height: 28),
                  _ModeSwitch(
                    isRegister: _isRegister,
                    onChanged: (isRegister) {
                      HapticFeedback.selectionClick();
                      setState(() {
                        _isRegister = isRegister;
                        _errors = const AuthFormErrors();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  _AuthField(
                    fieldKey: const Key('auth-email'),
                    label: AppStrings.fieldEmail,
                    hint: AppStrings.emailHint,
                    controller: _email,
                    errorText: _errors.email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                    onChanged: () => _clearFieldError(email: true),
                  ),
                  const SizedBox(height: 8),
                  _AuthField(
                    fieldKey: const Key('auth-password'),
                    label: AppStrings.fieldPassword,
                    hint: AppStrings.passwordHint,
                    controller: _password,
                    errorText: _errors.password,
                    obscureText: _hidePassword,
                    textInputAction: _isRegister
                        ? TextInputAction.next
                        : TextInputAction.done,
                    autofillHints: [
                      _isRegister
                          ? AutofillHints.newPassword
                          : AutofillHints.password,
                    ],
                    onChanged: () => _clearFieldError(password: true),
                    onSubmitted: _isRegister ? null : _submit,
                    suffix: _VisibilityToggle(
                      hidden: _hidePassword,
                      onTap: () =>
                          setState(() => _hidePassword = !_hidePassword),
                    ),
                  ),
                  if (_isRegister) ...[
                    const SizedBox(height: 8),
                    _AuthField(
                      fieldKey: const Key('auth-confirm-password'),
                      label: AppStrings.fieldConfirmPassword,
                      hint: AppStrings.passwordHint,
                      controller: _confirm,
                      errorText: _errors.confirmPassword,
                      obscureText: _hideConfirm,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.newPassword],
                      onChanged: () => _clearFieldError(confirm: true),
                      onSubmitted: _submit,
                      suffix: _VisibilityToggle(
                        hidden: _hideConfirm,
                        onTap: () =>
                            setState(() => _hideConfirm = !_hideConfirm),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  _AuthPrimaryButton(
                    key: const Key('auth-submit'),
                    label: _isRegister
                        ? AppStrings.createAccount
                        : AppStrings.signIn,
                    pending: pending,
                    onPressed: pending ? null : _submit,
                  ),
                  const SizedBox(height: 18),
                  const _OrDivider(),
                  const SizedBox(height: 12),
                  _SocialButton(
                    key: const Key('auth-apple'),
                    label: AppStrings.continueWithApple,
                    mark: const _AppleMark(),
                    onTap: _showSocialUnavailable,
                  ),
                  const SizedBox(height: 8),
                  _SocialButton(
                    key: const Key('auth-google'),
                    label: AppStrings.continueWithGoogle,
                    mark: const _GoogleMark(),
                    onTap: _showSocialUnavailable,
                  ),
                  const SizedBox(height: 8),
                  _SocialButton(
                    key: const Key('auth-facebook'),
                    label: AppStrings.continueWithFacebook,
                    mark: const _FacebookMark(),
                    onTap: _showSocialUnavailable,
                  ),
                  const SizedBox(height: 16),
                  const _LocalNote(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSocialUnavailable() {
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(AppStrings.socialSignInUnavailable)),
    );
  }

  void _clearFieldError({
    bool email = false,
    bool password = false,
    bool confirm = false,
  }) {
    if (!email && !password && !confirm) {
      return;
    }
    setState(() {
      _errors = AuthFormErrors(
        email: email ? null : _errors.email,
        password: password ? null : _errors.password,
        confirmPassword: confirm ? null : _errors.confirmPassword,
      );
    });
  }

  Future<void> _submit() async {
    final errors = AuthFormValidator.validate(
      email: _email.text,
      password: _password.text,
      confirmPassword: _confirm.text,
      isRegister: _isRegister,
    );
    setState(() => _errors = errors);
    if (errors.hasErrors) {
      return;
    }
    final ok = await ref
        .read(authFormActionProvider.notifier)
        .continueLocally();
    if (!mounted) {
      return;
    }
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.couldNotContinueMessage)),
      );
      return;
    }
    HapticFeedback.mediumImpact();
    if (ref.read(onboardingRepositoryProvider).isCompleted) {
      context.go(AppRoutes.dashboard);
      return;
    }
    context.go(AppRoutes.onboarding);
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: Material(
        color: tokens.bgMuted,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            HapticFeedback.selectionClick();
            if (context.canPop()) {
              context.pop();
              return;
            }
            context.go(AppRoutes.launch);
          },
          child: SizedBox(
            width: 36,
            height: 36,
            child: Icon(
              AppIcons.chevronLeft,
              size: 20,
              color: tokens.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthHero extends StatelessWidget {
  const _AuthHero({required this.isRegister});

  final bool isRegister;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Column(
      children: [
        const AppBrandIcon(size: 64),
        const SizedBox(height: 18),
        Text(
          isRegister
              ? AppStrings.authCreateHeadline
              : AppStrings.authWelcomeBack,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.6,
            height: 1.15,
            color: tokens.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppStrings.authContinueOnPhone,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            height: 1.35,
            color: tokens.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _ModeSwitch extends StatelessWidget {
  const _ModeSwitch({required this.isRegister, required this.onChanged});

  final bool isRegister;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: tokens.bgMuted,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: tokens.border, width: 0.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ModeTile(
              key: isRegister ? const Key('auth-switch') : null,
              label: AppStrings.signIn,
              selected: !isRegister,
              onTap: () => onChanged(false),
            ),
          ),
          Expanded(
            child: _ModeTile(
              key: isRegister ? null : const Key('auth-switch'),
              label: AppStrings.createAccount,
              selected: isRegister,
              onTap: () => onChanged(true),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeTile extends StatelessWidget {
  const _ModeTile({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Material(
      color: selected ? tokens.accent : Colors.transparent,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: SizedBox(
          height: 32,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.1,
                color: selected ? tokens.accentText : tokens.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthField extends StatelessWidget {
  const _AuthField({
    required this.fieldKey,
    required this.label,
    required this.controller,
    required this.onChanged,
    this.hint,
    this.errorText,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.obscureText = false,
    this.onSubmitted,
    this.suffix,
  });

  final Key fieldKey;
  final String label;
  final String? hint;
  final TextEditingController controller;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final bool obscureText;
  final VoidCallback onChanged;
  final VoidCallback? onSubmitted;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              color: tokens.textMuted,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: tokens.bgCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: errorText == null ? tokens.border : tokens.borderDanger,
              width: 0.5,
            ),
          ),
          padding: const EdgeInsets.fromLTRB(14, 0, 4, 0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  key: fieldKey,
                  controller: controller,
                  keyboardType: keyboardType,
                  textInputAction: textInputAction,
                  obscureText: obscureText,
                  autocorrect: false,
                  enableSuggestions: false,
                  autofillHints: autofillHints,
                  onChanged: (_) => onChanged(),
                  onSubmitted: onSubmitted == null
                      ? null
                      : (_) => onSubmitted!(),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                    letterSpacing: -0.2,
                    color: tokens.textPrimary,
                  ),
                  cursorColor: tokens.textPrimary,
                  decoration: InputDecoration(
                    isDense: true,
                    filled: false,
                    fillColor: Colors.transparent,
                    hintText: hint,
                    hintStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                      color: tokens.textMuted,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              if (suffix != null) suffix!,
            ],
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              errorText!,
              style: TextStyle(
                fontSize: 12,
                height: 1.3,
                color: tokens.dangerText,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _VisibilityToggle extends StatelessWidget {
  const _VisibilityToggle({required this.hidden, required this.onTap});

  final bool hidden;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return IconButton(
      onPressed: onTap,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 36, height: 36),
      visualDensity: VisualDensity.compact,
      style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
      icon: Icon(
        hidden ? AppIcons.visibility : AppIcons.visibilityOff,
        size: 18,
        color: tokens.textMuted,
      ),
    );
  }
}

class _AuthPrimaryButton extends StatelessWidget {
  const _AuthPrimaryButton({
    required this.label,
    required this.pending,
    required this.onPressed,
    super.key,
  });

  final String label;
  final bool pending;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed == null
            ? null
            : () {
                HapticFeedback.mediumImpact();
                onPressed!();
              },
        style: FilledButton.styleFrom(
          backgroundColor: tokens.accent,
          foregroundColor: tokens.accentText,
          disabledBackgroundColor: tokens.accent,
          minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: pending
            ? SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: tokens.accentText,
                ),
              )
            : Text(
                label,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.1,
                  color: tokens.accentText,
                ),
              ),
      ),
    );
  }
}

class _LocalNote extends StatelessWidget {
  const _LocalNote();

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Icon(AppIcons.lock, size: 13, color: tokens.textMuted),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            AppStrings.authLocalNote,
            style: TextStyle(
              fontSize: 12,
              height: 1.35,
              color: tokens.textMuted,
            ),
          ),
        ),
      ],
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Row(
      children: [
        Expanded(child: Divider(height: 1, color: tokens.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            AppStrings.authOr,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: tokens.textMuted,
            ),
          ),
        ),
        Expanded(child: Divider(height: 1, color: tokens.border)),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.mark,
    required this.onTap,
    super.key,
  });

  final String label;
  final Widget mark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Material(
      color: tokens.bgCard,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: tokens.border, width: 0.5),
          ),
          child: Row(
            children: [
              mark,
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.1,
                    color: tokens.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialMark extends StatelessWidget {
  const _SocialMark({required this.child});

  static const double tile = 32;
  static const double radius = 9;
  static const double icon = 18;

  final Widget child;

  static Widget svg(String raw) {
    return SvgPicture.string(
      raw,
      width: icon,
      height: icon,
      fit: BoxFit.contain,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tile,
      height: tile,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: SizedBox(width: icon, height: icon, child: child),
    );
  }
}

class _AppleMark extends StatelessWidget {
  const _AppleMark();

  @override
  Widget build(BuildContext context) {
    return const _SocialMark(
      child: Icon(
        AppIcons.apple,
        size: _SocialMark.icon,
        color: Color(0xFF000000),
      ),
    );
  }
}

class _GoogleMark extends StatelessWidget {
  const _GoogleMark();

  // Official four-color G. Brand colors do not invert.
  static const _svg =
      '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48">
<path fill="#EA4335" d="M24 9.5c3.54 0 6.71 1.22 9.21 3.6l6.85-6.85C35.9 2.38 30.47 0 24 0 14.62 0 6.51 5.38 2.56 13.22l7.98 6.19C12.43 13.72 17.74 9.5 24 9.5z"/>
<path fill="#4285F4" d="M46.98 24.55c0-1.57-.15-3.09-.38-4.55H24v8.62h12.94c-.58 2.96-2.26 5.48-4.78 7.18l7.73 6c4.51-4.18 7.09-10.36 7.09-17.25z"/>
<path fill="#FBBC05" d="M10.53 28.59c-.48-1.45-.76-2.99-.76-4.59s.27-3.14.76-4.59l-7.98-6.19C.92 16.46 0 20.12 0 24c0 3.88.92 7.54 2.56 10.78l7.97-6.19z"/>
<path fill="#34A853" d="M24 48c6.48 0 11.93-2.13 15.89-5.81l-7.73-6c-2.15 1.45-4.92 2.3-8.16 2.3-6.26 0-11.57-4.22-13.47-9.91l-7.98 6.19C6.51 42.62 14.62 48 24 48z"/>
</svg>''';

  @override
  Widget build(BuildContext context) {
    return _SocialMark(child: _SocialMark.svg(_svg));
  }
}

class _FacebookMark extends StatelessWidget {
  const _FacebookMark();

  // Simple Icons facebook (MIT). White f on #1877F2; brand color does not invert.
  static const _svg =
      '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
<path fill="#1877F2" d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"/>
</svg>''';

  @override
  Widget build(BuildContext context) {
    return _SocialMark(child: _SocialMark.svg(_svg));
  }
}
