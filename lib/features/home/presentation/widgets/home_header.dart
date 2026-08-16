import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {},
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              Colors.grey.withValues(alpha: 0.15),
            ),
          ),
          icon: Icon(
            IconsaxPlusBroken.notification_1,
            color: Colors.black,
          ),
        ),
        IconButton(
          onPressed: () {},
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              Colors.grey.withValues(alpha: 0.15),
            ),
          ),
          icon: Icon(
            IconsaxPlusLinear.category_2,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}