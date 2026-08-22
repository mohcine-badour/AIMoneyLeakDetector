import 'package:flutter/material.dart';

import 'auth_form_view.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthFormView(isRegister: true);
  }
}
