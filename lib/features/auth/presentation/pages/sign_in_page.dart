import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:juniorflutterroadmap/core/constants/app_colors.dart';
import 'package:juniorflutterroadmap/core/constants/app_spacing.dart';
import 'package:juniorflutterroadmap/core/utils/app_primary_button.dart';
import 'package:juniorflutterroadmap/core/utils/app_validators.dart';
import 'package:juniorflutterroadmap/features/auth/data/dtos/sign_in/sign_in_request_dto.dart';
import 'package:juniorflutterroadmap/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:juniorflutterroadmap/features/auth/presentation/pages/create_account_page.dart';
import 'package:juniorflutterroadmap/features/home/presentation/pages/home_page.dart';

import '../widgets/auth_background_widget.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/create_account_button.dart';
import '../widgets/forgot_password_button.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordFocus = FocusNode();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool passwordIsAccepted = false;
  bool emailIsAccepted = false;
  bool showPassword = false;

  void _togglePassword() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();
      context.read<AuthBloc>().add(
        SignInRequested(SignInRequestDto(email: email, password: password)),
      );
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

  String? _validateEmail(String? value) => AppValidators.validateEmail(value);

  void _onPasswordChanged(String value) {
    setState(() {
      passwordIsAccepted = AppValidators.validatePassword(value) == null;
    });
  }

  void _onPasswordSubmitted(String value) {
    if (_formKey.currentState!.validate()) {
      _submit();
    }
  }

  String? _validatePassword(String? value) =>
      AppValidators.validatePassword(value);

  @override
  void dispose() {
    _passwordFocus.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
        if (state is AuthSignInSuccess) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        final hasError = state is AuthError;
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
                                controller: _emailController,
                                isAccepted: emailIsAccepted,
                                onChanged: _onEmailChanged,
                                onFieldSubmitted: _onEmailSubmitted,
                                validator: _validateEmail,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                autofocus: true,
                                hintText: 'Email',
                                prefixIcon: IconsaxPlusLinear.sms,
                              ),
                              AuthTextField(
                                controller: _passwordController,
                                onChanged: _onPasswordChanged,
                                onFieldSubmitted: _onPasswordSubmitted,
                                isAccepted: passwordIsAccepted,
                                focusNode: _passwordFocus,
                                keyboardType: TextInputType.visiblePassword,
                                validator: _validatePassword,
                                autofocus: false,
                                obscureText: showPassword,
                                hintText: 'password',
                                prefixIcon: IconsaxPlusLinear.password_check,
                                suffixIcon: IconButton(
                                  onPressed: () => _togglePassword(),
                                  icon: Icon(
                                    showPassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: context.textSecondary,
                                  ),
                                ),
                              ),
                              ForgotPasswordButton(onPressed: () {}),
                              Spacer(),
                              AppPrimaryButton(
                                label: 'Sign in',
                                isLoading: isLoading,
                                hasError: hasError,
                                onPressed: _submit,
                              ),
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
      },
    );
  }
}
