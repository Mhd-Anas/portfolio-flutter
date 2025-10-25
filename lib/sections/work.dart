import 'dart:math';
import 'package:flutter/material.dart';

class WorkSection extends StatelessWidget {
  const WorkSection({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = [
      {
        'title': 'Circular Menu',
        'description':
            'Developed an interactive circular menu, showcasing clean UI/UX and smooth Flutter animations.',
        'type': CardType.circularMenu,
        'color': Colors.purpleAccent,
        'icon': Icons.circle_outlined,
      },
      {
        'title': 'Chat Bot',
        'description':
            'Built AI using Flutter + Spring Boot. Integrated Ollama model for real-time intelligent conversations.',
        'type': CardType.robot,
        'color': Colors.blueAccent,
        'icon': Icons.message,
      },
      {
        'title': 'Digital Marketing',
        'description':
            'Provided freelance dev support for UAE clients, focusing on SEO, bug fixing, and performance improvements.',
        'type': CardType.graph,
        'color': Colors.orangeAccent,
        'icon': Icons.show_chart,
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 600;
        
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 40,
            vertical: isMobile ? 20 : 40,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: isMobile ? 600 : 1100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'My Recent Work',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // 📱 MOBILE: Horizontal scrolling
                  if (isMobile)
                    SizedBox(
                      height: 380, // Fixed height for horizontal scroll
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: projects.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 15),
                        itemBuilder: (context, index) {
                          final p = projects[index];
                          return AnimatedWorkCard(
                            title: p['title'] as String,
                            description: p['description'] as String,
                            color: p['color'] as Color,
                            type: p['type'] as CardType,
                            icon: p['icon'] as IconData,
                            isMobile: true,
                            cardWidth: 280, // Smaller for mobile
                            cardHeight: 350, // Smaller for mobile
                          );
                        },
                      ),
                    )
                  else 
                  // 🖥️ DESKTOP: Your current Wrap layout
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      alignment: WrapAlignment.center,
                      children: projects
                          .map(
                            (p) => AnimatedWorkCard(
                              title: p['title'] as String,
                              description: p['description'] as String,
                              color: p['color'] as Color,
                              type: p['type'] as CardType,
                              icon: p['icon'] as IconData,
                              isMobile: false,
                              cardWidth: 300, // Original size
                              cardHeight: 400, // Original size
                            ),
                          )
                          .toList(),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

enum CardType { circularMenu, robot, graph }

class AnimatedWorkCard extends StatefulWidget {
  final String title;
  final String description;
  final Color color;
  final CardType type;
  final IconData icon;
  final bool isMobile;
  final double cardWidth;
  final double cardHeight;

  const AnimatedWorkCard({
    super.key,
    required this.title,
    required this.description,
    required this.color,
    required this.type,
    required this.icon,
    required this.isMobile,
    required this.cardWidth,
    required this.cardHeight,
  });

  @override
  State<AnimatedWorkCard> createState() => _AnimatedWorkCardState();
}

class _AnimatedWorkCardState extends State<AnimatedWorkCard>
    with TickerProviderStateMixin {
  bool showAnimation = false;
  late AnimationController circularController;
  late AnimationController robotController;
  late AnimationController graphController;
  late AnimationController bounceController;

  @override
  void initState() {
    super.initState();
    circularController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    robotController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    graphController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
      lowerBound: 0.0,
      upperBound: 0.08,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          bounceController.reverse();
        }
      });
  }

  @override
  void dispose() {
    circularController.dispose();
    robotController.dispose();
    graphController.dispose();
    bounceController.dispose();
    super.dispose();
  }

  void _onCardClick() {
    setState(() => showAnimation = true);
    bounceController.forward();

    switch (widget.type) {
      case CardType.circularMenu:
        circularController.repeat();
        break;
      case CardType.robot:
        robotController.repeat();
        break;
      case CardType.graph:
        graphController.forward(from: 0);
        break;
    }

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() => showAnimation = false);
        circularController.stop();
        robotController.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onCardClick,
      child: AnimatedBuilder(
        animation: bounceController,
        builder: (context, child) {
          final scale = 1 - bounceController.value;
          return Transform.scale(
            scale: scale,
            child: Container(
              width: widget.cardWidth, // Use custom width
              height: widget.cardHeight, // Use custom height
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    widget.color.withOpacity(0.15),
                    Colors.black.withOpacity(0.4)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white12),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: showAnimation
                    ? _buildAnimatedContent()
                    : _buildDefaultContent(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDefaultContent() {
    return Column(
      key: const ValueKey('default'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(widget.icon, size: 40, color: widget.color),
        const SizedBox(height: 12),
        Text(
          widget.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedContent() {
    switch (widget.type) {
      case CardType.circularMenu:
        return _CircularMenuAnimation(controller: circularController);
      case CardType.robot:
        return _RobotEmojiAnimation(controller: robotController);
      case CardType.graph:
        return _GraphAnimation(controller: graphController);
    }
  }
}

/// 🟣 Circular Menu Animation
class _CircularMenuAnimation extends StatelessWidget {
  final AnimationController controller;
  const _CircularMenuAnimation({required this.controller});

  @override
  Widget build(BuildContext context) {
    const icons = [
      Icons.home,
      Icons.star,
      Icons.settings,
      Icons.person,
      Icons.message,
    ];
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final angle = controller.value * 2 * pi;
        return Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              for (int i = 0; i < icons.length; i++)
                Transform(
                  transform: Matrix4.identity()
                    ..translate(
                      80 * cos(angle + (2 * pi * i / icons.length)),
                      80 * sin(angle + (2 * pi * i / icons.length)),
                    ),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white12,
                    child: Icon(icons[i], color: Colors.white, size: 18),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// 🧍‍♂️ Robot Emoji Full Walk
/// 🤖 Robot Model Animation (Bounce + Fade-in)
class _RobotEmojiAnimation extends StatelessWidget {
  final AnimationController controller;
  const _RobotEmojiAnimation({required this.controller});

  @override
  Widget build(BuildContext context) {
    // Smooth bounce effect
    final bounce = Tween<double>(begin: 0, end: -15)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(controller);

    // Fade-in animation
    final fade = CurvedAnimation(
      parent: controller,
      curve: Curves.easeIn,
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Opacity(
          opacity: fade.value,
          child: Transform.translate(
            offset: Offset(0, bounce.value * sin(controller.value * 2 * 3.14)),
            child: Image.asset(
              'assets/robot.png',
              height: 120,
              width: 120,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }
}
/// 📈 Graph Animation
class _GraphAnimation extends StatelessWidget {
  final AnimationController controller;
  const _GraphAnimation({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _GraphPainter(progress: controller.value),
          child: Container(),
        );
      },
    );
  }
}
class _GraphPainter extends CustomPainter {
  final double progress;
  _GraphPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final axisPaint = Paint()
      ..color = Colors.white38
      ..strokeWidth = 1.2;
    final linePaint = Paint()
      ..color = Colors.orangeAccent
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke; // ← FIXED: Removed extra comma

    final left = 20.0;
    final bottom = size.height - 20;

    canvas.drawLine(Offset(left, bottom), Offset(size.width - 20, bottom), axisPaint);
    canvas.drawLine(Offset(left, bottom), Offset(left, 20), axisPaint);

    final points = [
      Offset(left, bottom),
      Offset(80, bottom - 60),
      Offset(140, bottom - 130),
      Offset(200, bottom - 180),
      Offset(260, bottom - 230),
    ];

    final path = Path()..moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      final prev = points[i - 1];
      final curr = points[i];
      final x = prev.dx + (curr.dx - prev.dx) * progress;
      final y = prev.dy + (curr.dy - prev.dy) * progress;
      path.lineTo(x, y);
    }

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(_GraphPainter oldDelegate) =>
      oldDelegate.progress != progress;
}