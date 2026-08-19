import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_breakpoints.dart';
import '../bloc/product_bloc.dart';
import '../widgets/mobile_home_body.dart';
import '../widgets/tablet_home_body.dart';

Future<void> _refreshProducts(BuildContext context) async {
  final bloc = context.read<ProductBloc>();
  bloc.add(ProductsRequested());
  await bloc.stream.firstWhere((state) => state is! ProductLoading);
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final body = AppBreakpoints.isMobile(constraints)
                ? const MobileContant()
                : const TabletContant();
            return RefreshIndicator(
              onRefresh: () => _refreshProducts(context),
              child: body,
            );
          },
        ),
      ),
    );
  }
}