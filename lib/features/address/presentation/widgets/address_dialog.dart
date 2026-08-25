import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/helpers/helpers.dart';
import '../../../../core/utils/app_primary_button.dart';
import '../../../../core/utils/app_value.dart';
import '../cubit/address_cubit.dart';

Future<void> showAddressDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return BlocProvider.value(
        value: context.read<AddressCubit>(),
        child: const _AddressDialogContent(),
      );
    },
  );
}

class _AddressDialogContent extends StatefulWidget {
  const _AddressDialogContent();

  @override
  State<_AddressDialogContent> createState() => _AddressDialogContentState();
}

class _AddressDialogContentState extends State<_AddressDialogContent> {
  @override
  void initState() {
    super.initState();
    context.read<AddressCubit>().fetchCurrentAddress();
  }

  void _retry() {
    context.read<AddressCubit>().fetchCurrentAddress();
  }

  void _onSave() {
    final address = context.read<AddressCubit>().state.detected;
    if (address == null) return;
    context.read<AddressCubit>().saveAddress(address.city, address.fullAddress);
    Navigator.of(context).pop();
  }

  String _errorText(BuildContext context, String? error) {
    final t = context.l10n.t;
    if (error == 'locationPermissionDenied') return t.locationPermissionDenied;
    return t.locationError;
  }

  @override
  Widget build(BuildContext context) {
    final t = context.l10n.t;

    return BlocBuilder<AddressCubit, AddressState>(
      builder: (context, state) {
        final content = state.isFetching
            ? const SizedBox(
                height: 80,
                child: Center(child: CircularProgressIndicator()),
              )
            : state.error != null
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_errorText(context, state.error)),
                      const SizedBox(height: 16),
                      AppPrimaryButton(
                        label: t.useMyLocation,
                        onPressed: _retry,
                      ),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppValue(
                        label: t.cityLabel,
                        value: state.detected?.city ?? '',
                      ),
                      AppValue(
                        label: t.addressLabel,
                        value: state.detected?.fullAddress ?? '',
                      ),
                      AppPrimaryButton(
                        label: t.saveAddress,
                        onPressed: _onSave,
                      ),
                    ],
                  );

        return AlertDialog(
          title: Text(t.addressTitle),
          content: SizedBox(width: double.maxFinite, child: content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                t.cancel,
                style: context.textTheme.labelMedium!.copyWith(
                  color: context.colors.textPrimary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
