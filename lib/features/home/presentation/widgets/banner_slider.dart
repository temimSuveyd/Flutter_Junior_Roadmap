import 'package:flutter/material.dart';
import '../../data/mock_data.dart';

class BannerSlider extends StatelessWidget {
  const BannerSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: bannerImages.length,
        itemBuilder: (context, index) => Container(
          width: screenWidth - 36,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(right: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(bannerImages[index].imageUrl),
            ),
          ),
        ),
      ),
    );
  }
}