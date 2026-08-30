import 'package:flutter/material.dart';
import 'package:juniorflutterroadmap/core/common/helpers/helpers.dart';

class AuthBackgroundWidget extends StatelessWidget {
  const AuthBackgroundWidget({
    super.key,
    required this.content,
    required this.title,
  });

  final Widget content;
  final String title;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableHeight = constraints.maxHeight;
        return Stack(
          children: [
            PositionedDirectional(
              top: 0,
              start: 0,
              end: 0,
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: availableHeight * 0.4,
                    decoration: BoxDecoration(
                      color: context.colors.background.withValues(alpha: 0.3),
                      image: const DecorationImage(
                        image: AssetImage(
                          'assets/images/auth_background_image.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: availableHeight * 0.4,
                    color: Colors.black.withValues(alpha: 0.3),
                    child: Text(
                      title,
                      style: context.headlineMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            PositionedDirectional(
              start: 0,
              end: 0,
              bottom: 0,
              child: ClipPath(
                clipper: WelcomeCustomClipper(),
                child: Container(
                  width: double.infinity,
                  height: availableHeight * 0.8,
                  decoration: BoxDecoration(
                    color: context.colors.background,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(100),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 110),
                    child: content,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class WelcomeCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    // 1. The pen starts at the top-left corner (0,0).
    // 2. Go down the left edge to the height where the white area begins.
    path.lineTo(0, size.height * 0.2);

    // 3. Draw the soft wave (curve) from the design:
    path.quadraticBezierTo(
      size.width * 0.30,
      size.height * 0.10,
      size.width,
      size.height * 0.25,
    );

    // 4. Go down the right edge to the bottom-right corner.
    path.lineTo(size.width, size.height);

    // 5. Go straight along the bottom edge to the bottom-left corner.
    path.lineTo(0, size.height);

    // 6. Close the shape and fill it.
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
