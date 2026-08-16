import 'package:flutter/material.dart';

class CreateAccountButton extends StatelessWidget {
  const CreateAccountButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have account",
          style: TextStyle(
            fontSize: 12,
            color: Colors.blueGrey,
            fontWeight: FontWeight.w300,
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            'Create account',
            style: TextStyle(
              fontSize: 12,
              color: Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}