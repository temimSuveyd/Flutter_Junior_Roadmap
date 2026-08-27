import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:juniorflutterroadmap/core/common/helpers/helpers.dart';
import 'package:juniorflutterroadmap/core/local/cubit/local_cubit.dart';
import 'package:juniorflutterroadmap/core/theme/theme_cubit.dart';
import 'package:juniorflutterroadmap/features/address/presentation/cubit/address_cubit.dart';
import 'package:juniorflutterroadmap/features/address/presentation/widgets/address_dialog.dart';

/// Home page header with location, theme and language toggle buttons.
class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onAnimate() {
    if (!_animationController.isAnimating) {
      _animationController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();
    final localeCubit = context.read<LocaleCubit>();

    return Row(
      children: [
        const LocationButton(),
        const Spacer(),
        BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) => IconButton(
                onPressed: () {
                  _onAnimate();
                  themeCubit.toggleTheme();
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    context.colors.surface,
                  ),
                ),
                icon: Transform.rotate(
                  angle: _animationController.value * 2 * math.pi,
                  child: Icon(
                    themeMode == ThemeMode.dark
                        ? IconsaxPlusBroken.moon
                        : IconsaxPlusBroken.sun_1,
                    color: context.colors.textPrimary,
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(width: context.spaceSm),
        BlocBuilder<LocaleCubit, LocaleState>(
          builder: (context, state) {
            final isEn = state.locale.languageCode == 'en';
            return GestureDetector(
              onTap: () => localeCubit.changeLocale(isEn ? 'ar' : 'en'),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  isEn ? 'EN' : 'AR',
                  style: context.labelMedium.copyWith(
                    color: context.colors.textPrimary,
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

/// Opens the address dialog and reflects the saved city in the header.
class LocationButton extends StatelessWidget {
  const LocationButton({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return BlocBuilder<AddressCubit, AddressState>(
      builder: (context, state) {
        final city = state.savedAddress?.city;
        return InkWell(
          borderRadius: context.radius.radiusFull,
          onTap: () => showAddressDialog(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: context.radiusFull,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  IconsaxPlusBroken.location,
                  size: 18,
                  color: context.colors.textPrimary,
                ),
                const SizedBox(width: 6),
                Text(
                  city != null && city.isNotEmpty ? city : t.addressTitle,
                  style: context.labelMedium.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
