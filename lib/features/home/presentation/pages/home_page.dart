import 'package:flutter/material.dart';
import '../widgets/banner_slider.dart';
import '../widgets/category_list.dart';
import '../widgets/home_header.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/product_grid.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: const HomeHeader(),
                ),
              ),

              const SliverPersistentHeader(
                pinned: true,
                delegate: HomeSearchBarHeaderDelegate(),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 30)),

              const SliverToBoxAdapter(child: BannerSlider()),
              const SliverToBoxAdapter(child: SizedBox(height: 30)),

              const SliverToBoxAdapter(child: CategoryList()),

              const ProductGrid(),
            ],
          ),
        ),
      ),
    );
  }
}