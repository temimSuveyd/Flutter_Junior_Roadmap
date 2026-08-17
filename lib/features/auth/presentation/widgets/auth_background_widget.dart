import 'package:flutter/material.dart';
import 'package:juniorflutterroadmap/core/constants/app_colors.dart';
import 'package:juniorflutterroadmap/core/constants/app_typography.dart';

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
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: screenHeight * 0.4,
                  decoration: BoxDecoration(
                    color: context.background.withValues(alpha: 0.3),
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
                  height: screenHeight * 0.4,
                  color: Colors.black.withValues(alpha: 0.3),
                  child: Text(
                    title,
                    style: AppTypography.headlineMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipPath(
              clipper: WelcomeCustomClipper(),
              child: Container(
                width: double.infinity,
                height: screenHeight * 0.8,
                decoration: BoxDecoration(
                  color: context.background,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(100),
                    topRight: Radius.circular(0),
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
      ),
    );
  }
}

class WelcomeCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    // 1. Kalem sol üstte (0,0) konumunda başlıyor.
    // 2. Sol kenardan aşağıya, beyaz alanın başladığı yüksekliğe iniyoruz.
    path.lineTo(0, size.height * 0.2);

    // 3. Görseldeki o yumuşak dalgayı (eğriyi) çiziyoruz:
    path.quadraticBezierTo(
      size.width * 0.30,
      size.height * 0.10,
      size.width,
      size.height * 0.25,
    );

    // 4. Sağ kenardan en aşağıya (sağ alt köşeye) iniyoruz.
    path.lineTo(size.width, size.height);

    // 5. Alt kenardan dümdüz sol alt köşeye gidiyoruz.
    path.lineTo(0, size.height);

    // 6. Şekli kapatıp içini dolduruyoruz.
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}