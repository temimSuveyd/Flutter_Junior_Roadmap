import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product_bloc/product_bloc.dart';
import '../widgets/home_body.dart';

bool _isRefreshing = false;

Future<void> _refreshProducts(BuildContext context) async {
  if (_isRefreshing) return;
  _isRefreshing = true;
  try {
    final bloc = context.read<ProductBloc>();
    final completer = Completer<void>();
    final subscription = bloc.stream.listen((state) {
      if (state is! ProductLoading && !completer.isCompleted) {
        completer.complete();
      }
    });
    bloc.add(ProductsRequested());
    await completer.future.timeout(const Duration(seconds: 15));
    await subscription.cancel();
  } finally {
    _isRefreshing = false;
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: const HomeContent(),
        ),
      ),
    );
  }
}
