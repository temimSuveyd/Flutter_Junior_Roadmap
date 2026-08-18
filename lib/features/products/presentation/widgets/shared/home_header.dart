import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:juniorflutterroadmap/core/theme/theme_cubit.dart';
import '../../../../../core/common/helpers/helpers.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ThemeCubit>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return IconButton(
              onPressed: cubit.toggleTheme,
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(context.surface),
              ),
              icon: Icon(
                themeMode == ThemeMode.dark
                    ? IconsaxPlusBroken.moon
                    : IconsaxPlusBroken.sun_1,
                color: context.textPrimary,
              ),
            );
          },
        ),
        IconButton(
          onPressed: () {},
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(context.surface),
          ),
          icon: Icon(
            IconsaxPlusLinear.category_2,
            color: context.textPrimary,
          ),
        ),
      ],
    );
  }
}
