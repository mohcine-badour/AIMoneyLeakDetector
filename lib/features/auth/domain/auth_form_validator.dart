import '../../../core/constants/app_strings.dart';

class AuthFormErrors {
  const AuthFormErrors({this.email, this.password, this.confirmPassword});

  final String? email;
  final String? password;
  final String? confirmPassword;

  bool get hasErrors =>
      email != null || password != null || confirmPassword != null;
}

/// Local email and password checks. Nothing is sent to a server.
abstract final class AuthFormValidator {
  static AuthFormErrors validate({
    required String email,
    required String password,
    String confirmPassword = '',
    bool isRegister = false,
  }) {
    return AuthFormErrors(
      email: _emailError(email),
      password: _passwordError(password),
      confirmPassword: isRegister
          ? _confirmError(password, confirmPassword)
          : null,
    );
  }

  static String? _emailError(String email) {
    final value = email.trim();
    final at = value.indexOf('@');
    if (value.isEmpty || at < 1 || at >= value.length - 3) {
      return AppStrings.errorEmailInvalid;
    }
    final domain = value.substring(at + 1);
    if (!domain.contains('.') ||
        domain.startsWith('.') ||
        domain.endsWith('.')) {
      return AppStrings.errorEmailInvalid;
    }
    return null;
  }

  static String? _passwordError(String password) {
    if (password.length < 8) {
      return AppStrings.errorPasswordShort;
    }
    return null;
  }

  static String? _confirmError(String password, String confirmPassword) {
    if (password != confirmPassword) {
      return AppStrings.errorPasswordMismatch;
    }
    return null;
  }
}
