import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.autofocus = false,
    this.hintStyleColor = Colors.blueGrey,
    this.textStyleColor = Colors.redAccent,
    this.iconColor = Colors.redAccent,
    this.borderColor = Colors.redAccent,
    this.focusedBorderColor = Colors.redAccent,
    this.suffixIcon,
    this.suffixIconColor,
    this.keyboardType,
    this.validator,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.onChanged,
    this.isAccepted = false,
  });

  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final bool autofocus;
  final Color hintStyleColor;
  final Color textStyleColor;
  final Color iconColor;
  final Color borderColor;
  final Color focusedBorderColor;
  final IconData? suffixIcon;
  final Color? suffixIconColor;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final bool isAccepted;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      obscureText: obscureText,
      autofocus: autofocus,
      style: TextStyle(color: textStyleColor, fontSize: 14),
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
          borderSide: BorderSide(color: focusedBorderColor),
        ),
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 12, color: hintStyleColor),
        prefixIcon: Icon(prefixIcon, color: iconColor),
        suffixIcon: suffixIcon != null
            ? Icon(
                suffixIcon,
                color: isAccepted ? iconColor:Colors.blueGrey ,
              )
            : null,
        contentPadding: EdgeInsets.all(10),
      ),
    );
  }
}
