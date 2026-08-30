import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:juniorflutterroadmap/core/l10n/app_localizations.dart';
import 'package:juniorflutterroadmap/features/favorites/presentation/bloc/favorite_bloc/favorite_bloc.dart';
import 'package:juniorflutterroadmap/features/products/data/models/product_model.dart';
import 'package:juniorflutterroadmap/features/products/presentation/widgets/shared/product_card.dart';

class MockFavoriteBloc extends Bloc<FavoriteEvent, FavoriteState>
    implements FavoriteBloc {
  MockFavoriteBloc() : super(const FavoriteInitial());

  @override
  Future<void> close() async {}
}

/// Minimal app wrapper so widgets can use the app's localizations and
/// design-system context extensions (colors, spacing, ...).
Widget buildTestApp(Widget child, {FavoriteBloc? bloc}) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(
    body: BlocProvider<FavoriteBloc>.value(
      value: bloc ?? MockFavoriteBloc(),
      child: child,
    ),
  ),
);

/// Widget test for the product card (renders data + handles tap).
void main() {
  testWidgets('shows title and price, and calls onTap', (tester) async {
    var cardTapped = false;

    final mockBloc = MockFavoriteBloc();

    final product = ProductModel(
      image: ['https://img/1.jpg'],
      title: 'Coffee Mug',
      description: 'A nice mug',
      price: 12.5,
      id: 1,
      category: 'Home',
    );

    await tester.pumpWidget(
      buildTestApp(
        ProductCard(product: product, onTap: () => cardTapped = true),
        bloc: mockBloc,
      ),
    );

    expect(find.text('Coffee Mug'), findsOneWidget);
    expect(find.text('12.5'), findsOneWidget);

    await tester.tap(find.byType(ProductCard));
    expect(cardTapped, isTrue);
  });
}
