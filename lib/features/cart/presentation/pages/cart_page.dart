import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:juniorflutterroadmap/core/common/helpers/helpers.dart';
import 'package:juniorflutterroadmap/core/utils/app_app_bar.dart';
import 'package:juniorflutterroadmap/core/utils/empty_state.dart';
import 'package:juniorflutterroadmap/features/cart/presentation/bloc/cart_bloc/cart_bloc.dart';
import 'package:juniorflutterroadmap/features/cart/presentation/widgets/cart_content.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: context.t.cart,
        showBackButton: false,
      ),
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartPaymentSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.t.paymentSuccess),
                backgroundColor: context.colors.success,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CartEmpty || state is CartInitial) {
            return EmptyState(
              message: context.t.emptyCart,
            );
          }

          if (state is CartLoaded) {
            return CartContent(state: state);
          }

          if (state is CartProcessing) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  SizedBox(height: context.spacing.spaceLg),
                  Text(
                    context.t.processingPayment,
                    style: context.typography.titleMedium,
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
