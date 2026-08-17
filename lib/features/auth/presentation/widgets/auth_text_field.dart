import 'package:flutter/material.dart';
import 'package:juniorflutterroadmap/core/constants/app_colors.dart';
import 'package:juniorflutterroadmap/core/constants/app_typography.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.autofocus = false,
    this.hintStyleColor,
    this.textStyleColor,
    this.iconColor,
    this.borderColor,
    this.focusedBorderColor,
    this.suffixIcon,
    this.suffixIconColor,
    this.keyboardType,
    this.validator,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.onChanged,
    this.isAccepted = false,
    this.controller,
  });

  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final bool autofocus;
  final Color? hintStyleColor;
  final Color? textStyleColor;
  final Color? iconColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Widget? suffixIcon;
  final Color? suffixIconColor;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final bool isAccepted;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final hintColor = hintStyleColor ?? context.textSecondary;
    final textColor = textStyleColor ?? context.textPrimary;
    final activeColor = iconColor ?? context.primary;
    final borderColor = this.borderColor ?? context.primary;
    final focusedColor = focusedBorderColor ?? context.primary;

    return TextFormField(
    
      controller: controller,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      obscureText: obscureText,
      autofocus: autofocus,
      style: AppTypography.bodyMedium.copyWith(color: textColor),
      decoration: InputDecoration(
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: borderColor.withValues(alpha: 0.5)),
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: borderColor.withValues(alpha: 0.5)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: focusedColor),
        ),
        hintText: hintText,
        hintStyle: AppTypography.bodySmall.copyWith(color: hintColor),
        prefixIcon: Icon(prefixIcon, color: activeColor),
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.all(10),
      ),
    );
  }
}
