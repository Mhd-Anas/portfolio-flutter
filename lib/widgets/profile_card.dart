import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  bool showPopup = false;
  late ConfettiController confettiController;

  @override
  void initState() {
    super.initState();
    confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // 🎉 Confetti animation
          Positioned(
            top: -20,
            child: IgnorePointer(
              child: ConfettiWidget(
                confettiController: confettiController,
                blastDirection: -pi / 2,
                emissionFrequency: 0.05,
                numberOfParticles: 25,
                gravity: 0.25,
                shouldLoop: false,
                colors: const [
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple,
                  Colors.green,
                ],
                createParticlePath: _randomParticlePath,
              ),
            ),
          ),

          // 👤 Profile Image Only
          GestureDetector(
            onDoubleTap: () {
              setState(() => showPopup = true);
              confettiController.play();
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) setState(() => showPopup = false);
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24, width: 2),
                image: const DecorationImage(
                  image: AssetImage('assets/profile.jpg'),
                  fit: BoxFit.cover,
                ),
                boxShadow: showPopup
                    ? [
                        BoxShadow(
                          color: Colors.cyanAccent.withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 3,
                        ),
                      ]
                    : [],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Path _randomParticlePath(Size size) {
    final random = Random();
    int shapeType = random.nextInt(3);
    Path path = Path();

    switch (shapeType) {
      case 0:
        path.addOval(Rect.fromCircle(center: Offset.zero, radius: 6));
        break;
      case 1:
        path.addRect(Rect.fromLTWH(-4, -4, 8, 8));
        break;
      default:
        const int points = 5;
        final double radius = 6;
        final double innerRadius = 3;
        final double step = pi / points;
        for (double i = 0; i < 2 * pi; i += step) {
          double r = (i % (2 * step) < step) ? radius : innerRadius;
          path.lineTo(r * cos(i), r * sin(i));
        }
        path.close();
    }
    return path;
  }
}