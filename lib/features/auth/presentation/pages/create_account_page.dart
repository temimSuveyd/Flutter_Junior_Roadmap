import 'package:flutter/material.dart';
import 'package:juniorflutterroadmap/core/constants/app_spacing.dart';
import 'package:juniorflutterroadmap/core/utils/app_validators.dart';
import 'package:juniorflutterroadmap/features/auth/presentation/pages/sign_in_page.dart';
import 'package:juniorflutterroadmap/features/home/presentation/pages/home_page.dart';

import '../widgets/already_have_account_button.dart';
import '../widgets/auth_background_widget.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/create_account_submit_button.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();
  bool emailIsAccepted = false;
  bool passwordIsAccepted = false;
  bool confirmPasswordIsAccepted = false;

  bool showPassrod = false;
  bool showConfirmPassword = false;
  final TextEditingController _passrodController = .new();
  final TextEditingController _confirmPasswordController = .new();

  void _createAccount() {
    if (_confirmPasswordController.value != _passrodController.value) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('passwords are not compatible')));
    }
    if (_formKey.currentState!.validate() &&
        _confirmPasswordController.value == _passrodController.value) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Account created')));
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
    }
  }

  void _togglePassword() {
    setState(() {
      showPassrod = !showPassrod;
    });
  }

  void _toggleConfirmPassword() {
    setState(() {
      showConfirmPassword = !showConfirmPassword;
    });
  }

  void _onEmailChanged(String value) {
    setState(() {
      emailIsAccepted = AppValidators.validateEmail(value) == null;
    });
  }

  void _onEmailSubmitted(String value) {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).requestFocus(_passwordFocus);
    }
  }

  String? _validateEmail(String? value) => AppValidators.validateEmail(value);

  void _onPasswordChanged(String value) {
    setState(() {
      passwordIsAccepted = AppValidators.validatePassword(value) == null;
    });
  }

  void _onPasswordSubmitted(String value) {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).requestFocus(_confirmPasswordFocus);
    }
  }

  String? _validatePassword(String? value) =>
      AppValidators.validatePassword(value);

  void _onConfirmPasswordChanged(String value) {
    setState(() {
      confirmPasswordIsAccepted = AppValidators.validatePassword(value) == null;
    });
  }

  void _onConfirmPasswordSubmitted(String value) {
    if (value == _passrodController.text) {
      _createAccount();
    }
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passrodController.text) {
      return 'passwords are not compatible';
    }
    return null;
  }

  @override
  void dispose() {
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackgroundWidget(
        title: 'Create Account',
        content: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        spacing: AppSpacing.xl,
                        children: [
                          Spacer(flex: 3),
                          AuthTextField(
                            isAccepted: emailIsAccepted,
                            onChanged: _onEmailChanged,
                            onFieldSubmitted: _onEmailSubmitted,
                            validator: _validateEmail,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofocus: true,
                            hintText: 'Email',
                            prefixIcon: Icons.email_outlined,
                          ),
                          AuthTextField(
                            controller: _passrodController,
                            onChanged: _onPasswordChanged,
                            isAccepted: passwordIsAccepted,
                            focusNode: _passwordFocus,
                            onFieldSubmitted: _onPasswordSubmitted,
                            keyboardType: TextInputType.visiblePassword,
                            validator: _validatePassword,
                            textInputAction: TextInputAction.next,
                            autofocus: false,
                            obscureText: showPassrod,
                            hintText: 'password',
                            prefixIcon: Icons.password_rounded,
                            suffixIcon: IconButton(
                              onPressed: () => _togglePassword(),
                              icon: Icon(
                                showPassrod
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                          ),
                          AuthTextField(
                            onChanged: _onConfirmPasswordChanged,
                            onFieldSubmitted: _onConfirmPasswordSubmitted,
                            isAccepted: confirmPasswordIsAccepted,
                            focusNode: _confirmPasswordFocus,
                            keyboardType: TextInputType.visiblePassword,
                            validator: _validateConfirmPassword,
                            autofocus: false,
                            obscureText: showConfirmPassword,
                            hintText: 'confirm password',
                            prefixIcon: Icons.password_rounded,
                            suffixIcon: IconButton(
                              onPressed: () => _toggleConfirmPassword(),
                              icon: Icon(
                                showConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                          ),
                          Spacer(),
                          CreateAccountSubmitButton(
                            onPressed: () => _createAccount(),
                          ),
                          Spacer(),
                          AlreadyHaveAccountButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const SignInPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
