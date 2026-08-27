import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:juniorflutterroadmap/core/common/helpers/helpers.dart';
import 'package:juniorflutterroadmap/core/utils/app_primary_button.dart';
import 'package:juniorflutterroadmap/core/utils/app_validators.dart';
import 'package:juniorflutterroadmap/features/auth/data/dtos/sign_up/sign_up_request_dto.dart';
import 'package:juniorflutterroadmap/features/auth/presentation/bloc/auth_bloc.dart';
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
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool nameIsAccepted = false;
  bool emailIsAccepted = false;
  bool passwordIsAccepted = false;
  bool confirmPasswordIsAccepted = false;
  bool showPassword = false;
  bool showConfirmPassword = false;

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

  void _submit() {
    if (context.read<AuthBloc>().state is AuthLoading) return;
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            SignUpRequested(
              SignUpRequestDto(
                name: _nameController.text.trim(),
                email: _emailController.text.trim(),
                password: _passwordController.text.trim(),
              ),
            ),
          );
    }
  }

  void _onNameChanged(String value) {
    setState(() {
      nameIsAccepted = value.trim().isNotEmpty;
    });
  }

  void _onNameSubmitted(String value) {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).requestFocus(_emailFocus);
    }
  }

  void _onEmailChanged(String value) {
    setState(() {
      emailIsAccepted = AppValidators.validateEmail(context, value) == null;
    });
  }

  void _onEmailSubmitted(String value) {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).requestFocus(_passwordFocus);
    }
  }

  void _onPasswordChanged(String value) {
    setState(() {
      passwordIsAccepted = AppValidators.validatePassword(context, value) == null;
    });
  }

  void _onPasswordSubmitted(String value) {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).requestFocus(_confirmPasswordFocus);
    }
  }

  void _onConfirmPasswordChanged(String value) {
    setState(() {
      confirmPasswordIsAccepted =
          value.isNotEmpty && value == _passwordController.text;
    });
  }

  void _onConfirmPasswordSubmitted(String value) {
    if (_formKey.currentState!.validate()) {
      _submit();
    }
  }

  String? _validateName(String? value) =>
      AppValidators.validateName(context, value);

  String? _validateConfirmPassword(String? value) =>
      AppValidators.validateConfirmPassword(
        context,
        value,
        _passwordController.text,
      );

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    _nameController.dispose();
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
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }          if (state is AuthSignUpSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(
            SnackBar(
              content: Text(context.t.accountCreated),
            ),
          );
          context.go(AppRoutes.signIn);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        final hasError = state is AuthError;
        return Scaffold(
          body: AuthBackgroundWidget(
            title: context.t.createAccount,
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
                            spacing: context.spaceXl,
                            children: [
                              const Spacer(flex: 3),
                              AuthTextField(
                                controller: _nameController,
                                isAccepted: nameIsAccepted,
                                onChanged: _onNameChanged,
                                onFieldSubmitted: _onNameSubmitted,
                                validator: _validateName,
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.next,
                                autofocus: true,
                                hintText: context.t.name,
                                prefixIcon: IconsaxPlusLinear.user,
                              ),
                              AuthTextField(
                                controller: _emailController,
                                isAccepted: emailIsAccepted,
                                onChanged: _onEmailChanged,
                                onFieldSubmitted: _onEmailSubmitted,
                                validator: (v) => AppValidators.validateEmail(context, v),
                                focusNode: _emailFocus,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                hintText: context.t.email,
                                prefixIcon: IconsaxPlusLinear.sms,
                              ),
                              AuthTextField(
                                controller: _passwordController,
                                isAccepted: passwordIsAccepted,
                                onChanged: _onPasswordChanged,
                                onFieldSubmitted: _onPasswordSubmitted,
                                validator: (v) => AppValidators.validatePassword(context, v),
                                focusNode: _passwordFocus,
                                keyboardType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.next,
                                obscureText: showPassword,
                                hintText: context.t.password,
                                prefixIcon: IconsaxPlusLinear.password_check,
                                suffixIcon: IconButton(
                                  onPressed: _togglePassword,
                                  icon: Icon(
                                    showPassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: context.colors.textSecondary,
                                  ),
                                ),
                              ),
                              AuthTextField(
                                controller: _confirmPasswordController,
                                isAccepted: confirmPasswordIsAccepted,
                                onChanged: _onConfirmPasswordChanged,
                                onFieldSubmitted: _onConfirmPasswordSubmitted,
                                validator: _validateConfirmPassword,
                                focusNode: _confirmPasswordFocus,
                                keyboardType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.done,
                                obscureText: showConfirmPassword,
                                hintText: context.t.confirmPassword,
                                prefixIcon: IconsaxPlusLinear.password_check,
                                suffixIcon: IconButton(
                                  onPressed: _toggleConfirmPassword,
                                  icon: Icon(
                                    showConfirmPassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: context.colors.textSecondary,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              AppPrimaryButton(
                                label: context.t.createAccount,
                                isLoading: isLoading,
                                hasError: hasError,
                                onPressed: _submit,
                              ),
                              const Spacer(),
                              AlreadyHaveAccountButton(
                                onPressed: () {
                                  context.go(AppRoutes.signIn);
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