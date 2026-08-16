import 'package:flutter/material.dart';

class AlreadyHaveAccountButton extends StatelessWidget {
  const AlreadyHaveAccountButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have account',
          style: TextStyle(
            fontSize: 12,
            color: Colors.blueGrey,
            fontWeight: FontWeight.w300,
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            'Sign in',
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