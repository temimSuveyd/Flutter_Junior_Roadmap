import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:juniorflutterroadmap/core/common/helpers/helpers.dart';
import 'package:juniorflutterroadmap/core/local/cubit/local_cubit.dart';
import 'package:juniorflutterroadmap/core/theme/theme_cubit.dart';

/// رأس الصفحة الرئيسية يحتوي على أزرار تبديل الثيم واللغة.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();
    final localeCubit = context.read<LocaleCubit>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // زر تبديل الثيم (فاتح/داكن).
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

        // زر تبديل اللغة (EN/AR).
        BlocBuilder<LocaleCubit, LocaleState>(
          builder: (context, state) {
            final isEn = state.locale.languageCode == 'en';
            return GestureDetector(
              onTap: () => localeCubit.changeLocale(isEn ? 'ar' : 'en'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: context.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  isEn ? 'EN' : 'AR',
                  style: context.labelLarge.copyWith(
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
