import 'package:flutter/material.dart';
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
                        spacing: 20,
                        children: [
                          Spacer(flex: 3),
                          AuthTextField(
                            isAccepted: emailIsAccepted,
                            onChanged: (value) {
                              setState(() {
                                emailIsAccepted =
                                    AppValidators.validateEmail(value) == null;
                              });
                            },
                            onFieldSubmitted: (value) {
                              if (_formKey.currentState!.validate()) {
                                FocusScope.of(
                                  context,
                                ).requestFocus(_passwordFocus);
                              }
                            },
                            validator: (value) =>
                                AppValidators.validateEmail(value),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofocus: true,
                            hintText: 'Email',
                            prefixIcon: Icons.email_outlined,
                            focusedBorderColor: Colors.red,
                            suffixIcon: Icons.check,
                          ),
                          AuthTextField(
                            onChanged: (value) {
                              setState(() {
                                passwordIsAccepted =
                                    AppValidators.validatePassword(value) ==
                                    null;
                              });
                            },
                            isAccepted: passwordIsAccepted,
                            focusNode: _passwordFocus,
                            onFieldSubmitted: (value) {
                              if (_formKey.currentState!.validate()) {
                                FocusScope.of(
                                  context,
                                ).requestFocus(_confirmPasswordFocus);
                              }
                            },
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) =>
                                AppValidators.validatePassword(value),
                            textInputAction: TextInputAction.next,
                            autofocus: false,
                            obscureText: true,
                            hintText: 'password',
                            prefixIcon: Icons.password_rounded,
                            iconColor: Colors.red,
                            suffixIcon: Icons.check,
                            suffixIconColor: Colors.red,
                          ),
                          AuthTextField(
                            onChanged: (value) {
                              setState(() {
                                confirmPasswordIsAccepted =
                                    AppValidators.validatePassword(value) ==
                                    null;
                              });
                            },
                            isAccepted: confirmPasswordIsAccepted,
                            focusNode: _confirmPasswordFocus,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) =>
                                AppValidators.validatePassword(value),
                            autofocus: false,
                            obscureText: true,
                            hintText: 'confirm password',
                            prefixIcon: Icons.password_rounded,
                            iconColor: Colors.red,
                            suffixIcon: Icons.check,
                            suffixIconColor: Colors.red,
                          ),
                          Spacer(),
                          CreateAccountSubmitButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Account created'),
                                  ),
                                );
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) => const HomePage(),
                                  ),
                                );
                              }
                            },
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