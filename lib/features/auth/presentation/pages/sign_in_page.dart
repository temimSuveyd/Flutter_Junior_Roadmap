import 'package:flutter/material.dart';
import 'package:juniorflutterroadmap/core/constants/app_spacing.dart';
import 'package:juniorflutterroadmap/core/utils/app_validators.dart';
import 'package:juniorflutterroadmap/features/auth/presentation/pages/create_account_page.dart';
import 'package:juniorflutterroadmap/features/home/presentation/pages/home_page.dart';

import '../widgets/auth_background_widget.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/create_account_button.dart';
import '../widgets/forgot_password_button.dart';
import '../widgets/sign_in_button.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordFocus = FocusNode();
  bool passwordIsAccepted = false;
  bool emailIsAccepted = false;

  void _signIn() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Log in successful')));
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
    }
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

  String? _validateEmail(String? value) =>
      AppValidators.validateEmail(value);

  void _onPasswordChanged(String value) {
    setState(() {
      passwordIsAccepted = AppValidators.validatePassword(value) == null;
    });
  }

  void _onPasswordSubmitted(String value) {
    if (_formKey.currentState!.validate()) {
      _signIn();
    }
  }

  String? _validatePassword(String? value) =>
      AppValidators.validatePassword(value);

  @override
  void dispose() {
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackgroundWidget(
        title: 'Sign In',
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
                            // suffixIcon: Icons.check,
                          ),
                          AuthTextField(
                            onChanged: _onPasswordChanged,
                            onFieldSubmitted: _onPasswordSubmitted,
                            isAccepted: passwordIsAccepted,
                            focusNode: _passwordFocus,
                            keyboardType: TextInputType.visiblePassword,
                            validator: _validatePassword,
                            autofocus: false,
                            obscureText: true,
                            hintText: 'password',
                            prefixIcon: Icons.password_rounded,
                            suffixIcon: IconButton(onPressed: () {
                              
                            }, icon: Icon(Icons.remove_red_eye_outlined))
                          ),
                          ForgotPasswordButton(onPressed: () {}),
                          Spacer(),
                          SignInButton(onPressed: () => _signIn()),
                          Spacer(),
                          CreateAccountButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const CreateAccountPage(),
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
