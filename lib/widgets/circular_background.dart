import 'package:flutter/material.dart';

class CircularBackground extends StatefulWidget {
  final Color backgroundColor;
  
  const CircularBackground({
    super.key,
    this.backgroundColor = Colors.black,
  });

  @override
  State<CircularBackground> createState() => _CircularBackgroundState();
}

class _CircularBackgroundState extends State<CircularBackground> 
    with TickerProviderStateMixin {
  late final List<_CircleData> circles;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    circles = [
      _CircleData(size: 80, left: 0.25, duration: 25, delay: 0),
      _CircleData(size: 20, left: 0.10, duration: 12, delay: 2),
      _CircleData(size: 20, left: 0.70, duration: 25, delay: 4),
      _CircleData(size: 60, left: 0.40, duration: 18, delay: 0),
      _CircleData(size: 20, left: 0.65, duration: 25, delay: 0),
      _CircleData(size: 110, left: 0.75, duration: 25, delay: 3),
      _CircleData(size: 150, left: 0.35, duration: 25, delay: 7),
      _CircleData(size: 25, left: 0.50, duration: 45, delay: 15),
      _CircleData(size: 15, left: 0.20, duration: 35, delay: 2),
      _CircleData(size: 150, left: 0.85, duration: 11, delay: 0),
    ];

    // 👇 Repeats forever for a continuous animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 100),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildAnimatedCircle(_CircleData data, BoxConstraints constraints) {
    final double screenHeight = constraints.maxHeight;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Progress based on animation time + delay
        double t = ((_controller.value * (100 / data.duration)) +
                (data.delay / data.duration)) %
            1.0;

        // Looping upward motion continuously
        double dy = screenHeight - t * (screenHeight + 400);

        return Positioned(
          left: constraints.maxWidth * data.left,
          top: dy,
          child: Container(
            width: data.size,
            height: data.size,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.18),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // 🌌 Floating circles background
              ...circles.map((c) => _buildAnimatedCircle(c, constraints)),
            ],
          );
        },
      ),
    );
  }
}

// 🟡 Circle Configuration Class
class _CircleData {
  final double size;
  final double left;
  final int duration;
  final int delay;

  _CircleData({
    required this.size,
    required this.left,
    required this.duration,
    required this.delay,
  });
}