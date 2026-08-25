import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../../../core/common/helpers/helpers.dart';
import '../../../../../features/products/data/models/category_model.dart';
import '../../bloc/product_bloc/product_bloc.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      buildWhen: (previous, current) =>
          previous.categories != current.categories ||
          previous.selectedCategoryId != current.selectedCategoryId,
      builder: (context, state) {
        final categories = state.categories;
        final selectedCategoryId = state.selectedCategoryId;

        if (categories.isEmpty) {
          return const SizedBox.shrink();
        }

        final items = <CategoryModel?>[null, ...categories];

        return SizedBox(
          height: 84,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemCount: items.length,
            separatorBuilder: (context, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final category = items[index];
              final isSelected = category?.id == selectedCategoryId;
              return CategoryChip(
                category: category,
                isSelected: isSelected,
                onTap: () => context
                    .read<ProductBloc>()
                    .add(CategorySelected(category?.id)),
              );
            },
          ),
        );
      },
    );
  }
}

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    required this.category,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final CategoryModel? category;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = category?.name ?? context.t.all;
    final hasImage = category != null && category!.image.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? context.primary : context.surface,
              border: Border.all(
                color: isSelected
                    ? context.primary
                    : context.border.withValues(alpha: 0.6),
              ),
              image: hasImage
                  ? DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(category!.image),
                    )
                  : null,
            ),
            child: hasImage
                ? null
                : Icon(
                    IconsaxPlusLinear.category,
                    size: 24,
                    color:
                        isSelected ? context.surface : context.textSecondary,
                  ),
          ),
          const SizedBox(height: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 64),
            child: Text(
              label,
              style: context.labelSmall.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? context.primary : context.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
