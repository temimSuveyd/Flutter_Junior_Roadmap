import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:juniorflutterroadmap/core/common/helpers/helpers.dart';
import 'package:juniorflutterroadmap/core/local/cubit/local_cubit.dart';
import 'package:juniorflutterroadmap/core/theme/theme_cubit.dart';

/// Home page header with theme and language toggle buttons.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();
    final localeCubit = context.read<LocaleCubit>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Theme toggle button (light/dark).
        BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return IconButton(
              onPressed: themeCubit.toggleTheme,
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

        // Language toggle button (EN/AR).
        BlocBuilder<LocaleCubit, LocaleState>(
          builder: (context, state) {
            final isEn = state.locale.languageCode == 'en';
            return GestureDetector(
              onTap: () => localeCubit.changeLocale(isEn ? 'ar' : 'en'),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: context.surface,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  isEn ? 'EN' : 'AR',
                  style: context.labelMedium.copyWith(
                    color: context.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
