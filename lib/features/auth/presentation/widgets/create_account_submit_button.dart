import 'package:flutter/material.dart';

class CreateAccountSubmitButton extends StatelessWidget {
  const CreateAccountSubmitButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MaterialButton(
            onPressed: onPressed,
            elevation: 0,
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            color: Colors.redAccent,
            height: 55,
            child: Text(
              'Create account',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}