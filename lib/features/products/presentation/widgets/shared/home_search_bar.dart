import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../../../core/common/helpers/helpers.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        spacing: 10,
        children: [
          Icon(IconsaxPlusLinear.search_normal_1, size: 18),
          Text(
            context.t.search,
            style: TextStyle(
              fontSize: 12,
              color: context.textSecondary,
            ),
          ),
          const Spacer(),
          VerticalDivider(
            color: context.border,
            thickness: 0.6,
            width: 20,
            indent: 2,
            endIndent: 2,
          ),
          Icon(IconsaxPlusLinear.filter_search),
        ],
      ),
    );
  }
}

class HomeSearchBarHeaderDelegate extends SliverPersistentHeaderDelegate {
  const HomeSearchBarHeaderDelegate();

  @override
  double get minExtent => 44;

  @override
  double get maxExtent => 44;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return const HomeSearchBar();
  }

  @override
  bool shouldRebuild(covariant HomeSearchBarHeaderDelegate oldDelegate) {
    return true;
  }
}