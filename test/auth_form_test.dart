import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/core/constants/app_strings.dart';
import 'package:kichta/features/auth/domain/auth_form_validator.dart';

void main() {
  test('sign-in validator requires email and a long enough password', () {
    final empty = AuthFormValidator.validate(email: '', password: '');
    expect(empty.email, AppStrings.errorEmailInvalid);
    expect(empty.password, AppStrings.errorPasswordShort);
    expect(empty.confirmPassword, isNull);

    final ok = AuthFormValidator.validate(
      email: 'ada@example.com',
      password: 'password1',
    );
    expect(ok.hasErrors, isFalse);
  });

  test('register validator requires matching passwords', () {
    final mismatch = AuthFormValidator.validate(
      email: 'ada@example.com',
      password: 'password1',
      confirmPassword: 'password2',
      isRegister: true,
    );
    expect(mismatch.confirmPassword, AppStrings.errorPasswordMismatch);

    final ok = AuthFormValidator.validate(
      email: 'ada@example.com',
      password: 'password1',
      confirmPassword: 'password1',
      isRegister: true,
    );
    expect(ok.hasErrors, isFalse);
  });
}
