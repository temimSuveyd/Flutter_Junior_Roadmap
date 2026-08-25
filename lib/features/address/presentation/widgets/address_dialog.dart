import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/helpers/helpers.dart';
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
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  bool _prefilled = false;

  @override
  void initState() {
    super.initState();
    context.read<AddressCubit>().fetchCurrentAddress();
  }

  @override
  void dispose() {
    _cityController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _retry() {
    _prefilled = false;
    context.read<AddressCubit>().fetchCurrentAddress();
  }

  void _onSave() {
    context.read<AddressCubit>().saveAddress(
      _cityController.text,
      _addressController.text,
    );
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
        if (state.detected != null && !_prefilled) {
          _prefilled = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            _cityController.text = state.detected!.city;
            _addressController.text = state.detected!.fullAddress;
          });
        }

        return AlertDialog(
          title: Text(t.addressTitle),
          content: SizedBox(
            width: double.maxFinite,
            child: state.isFetching
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
                      FilledButton.icon(
                        onPressed: _retry,
                        icon: const Icon(Icons.my_location),
                        label: Text(t.useMyLocation),
                      ),
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.addressHint,
                          style: context.typography.bodySmall.copyWith(
                            color: context.colors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _cityController,
                          decoration: InputDecoration(
                            labelText: t.cityLabel,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _addressController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: t.addressLabel,
                            alignLabelWithHint: true,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
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
            if (!state.isFetching && state.error == null)
              FilledButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    context.colors.primary,
                  ),
                ),
                onPressed: _onSave,
                child: Text(
                  t.saveAddress,
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
