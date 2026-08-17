
import 'package:flutter/material.dart';
import 'package:juniorflutterroadmap/features/home/presentation/widgets/shared/banner_slider.dart';
import 'package:juniorflutterroadmap/features/home/presentation/widgets/shared/category_list.dart';
import 'package:juniorflutterroadmap/features/home/presentation/widgets/shared/home_header.dart';
import 'package:juniorflutterroadmap/features/home/presentation/widgets/shared/home_search_bar.dart';
import 'package:juniorflutterroadmap/features/home/presentation/widgets/tablet/tablet_product_grid.dart';

class TabletContant extends StatelessWidget {
  const TabletContant({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    
          const TabletProductGrid(),
        ],
      ),
    );
  }
}