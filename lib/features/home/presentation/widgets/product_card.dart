import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey.withValues(alpha: 0.2),
          ),
          child: Column(
            children: [
              Image.network(
                width: 100,
                'https://clipart-library.com/images_k/shoe-transparent-background/shoe-transparent-background-12.jpg',
              ),
              const Spacer(),
              const Text(
                'Shoe, Sneakers, Nike, Blue, Cobalt Blue PNG',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Text(
                    '120.00',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                  ),
                  const Spacer(),
                  ...List.generate(
                    3,
                    (colorIndex) => Container(
                      margin: const EdgeInsets.only(right: 1),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: colorIndex == 0
                              ? Colors.black
                              : Colors.transparent,
                          width: 0.5,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        width: colorIndex == 0 ? 12 : 15,
                        height: colorIndex == 0 ? 12 : 15,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: [
                            Colors.red,
                            Colors.amber,
                            Colors.blue,
                            Colors.green,
                          ][colorIndex],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: const Icon(
              IconsaxPlusLinear.heart,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}