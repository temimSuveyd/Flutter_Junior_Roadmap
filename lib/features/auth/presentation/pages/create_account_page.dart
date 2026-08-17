import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:juniorflutterroadmap/core/constants/app_spacing.dart';
import 'package:juniorflutterroadmap/core/utils/app_primary_button.dart';
import 'package:juniorflutterroadmap/core/utils/app_validators.dart';
import 'package:juniorflutterroadmap/features/auth/data/dtos/sign_up/sign_up_request_dto.dart';
import 'package:juniorflutterroadmap/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:juniorflutterroadmap/features/auth/presentation/pages/sign_in_page.dart';
import 'package:juniorflutterroadmap/features/home/presentation/pages/home_page.dart';

import '../widgets/already_have_account_button.dart';
import '../widgets/auth_background_widget.dart';
import '../widgets/auth_text_field.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool emailIsAccepted = false;
  bool passwordIsAccepted = false;
  bool confirmPasswordIsAccepted = false;
  bool showPassword = false;
  bool showConfirmPassword = false;

  void _submit() {
    if (_confirmPasswordController.text != _passwordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('passwords are not compatible')),
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();
      context.read<AuthBloc>().add(
        SignUpRequested(SignUpRequestDto(email: email, password: password)),
      );
    }
  }

  void _togglePassword() {
    setState(() {
      showPassword = !showPassword;
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
    if (value == _passwordController.text) {
      _submit();
    }
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return 'passwords are not compatible';
    }
    return null;
  }

  @override
  void dispose() {
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        if (state is AuthSignUpSuccess) {
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
                                isAccepted: passwordIsAccepted,
                                focusNode: _passwordFocus,
                                onFieldSubmitted: _onPasswordSubmitted,
                                keyboardType: TextInputType.visiblePassword,
                                validator: _validatePassword,
                                textInputAction: TextInputAction.next,
                                autofocus: false,
                                obscureText: showPassword,
                                hintText: 'password',
                                prefixIcon: IconsaxPlusLinear.password_check,
                                suffixIcon: IconButton(
                                  onPressed: () => _togglePassword(),
                                  icon: Icon(
                                    showPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                ),
                              ),
                              AuthTextField(
                                controller: _confirmPasswordController,
                                onChanged: _onConfirmPasswordChanged,
                                onFieldSubmitted: _onConfirmPasswordSubmitted,
                                isAccepted: confirmPasswordIsAccepted,
                                focusNode: _confirmPasswordFocus,
                                keyboardType: TextInputType.visiblePassword,
                                validator: _validateConfirmPassword,
                                autofocus: false,
                                obscureText: showConfirmPassword,
                                hintText: 'confirm password',
                                prefixIcon: IconsaxPlusLinear.password_check,
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
                              AppPrimaryButton(
                                label: 'Create account',
                                isLoading: isLoading,
                                hasError: hasError,
                                onPressed: _submit,
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
      },
    );
  }
}