import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatefulWidget {
  const Footer({super.key});

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  int _activeIndex = -1;
  Timer? _timer;

  final List<_IconDataModel> _icons = const [
    _IconDataModel(
      icon: FontAwesomeIcons.github,
      color: Color(0xFF333333),
      url: 'https://github.com/Mhd-Anas',
    ),
    _IconDataModel(
      icon: FontAwesomeIcons.linkedin,
      color: Color(0xFF0077B5),
      url: 'https://www.linkedin.com/in/anas-muhd/',
    ),
    _IconDataModel(
      icon: FontAwesomeIcons.whatsapp,
      color: Color(0xFF25D366),
      url: 'https://wa.me/919746495720',
    ),
    _IconDataModel(
      icon: FontAwesomeIcons.facebook,
      color: Color(0xFF1877F2),
      url: 'https://www.facebook.com/yourprofile',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoHoverLoop();
  }

  void _startAutoHoverLoop() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _activeIndex = (_activeIndex + 1) % _icons.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 600;
        
        return Container(
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? 20 : 40, 
            horizontal: isMobile ? 16 : 24
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Social Icons Row
              Wrap(
                spacing: isMobile ? 5 : 10,
                runSpacing: isMobile ? 10 : 0,
                alignment: WrapAlignment.center,
                children: List.generate(_icons.length, (index) {
                  final iconData = _icons[index];
                  final isAutoActive = _activeIndex == index;

                  return InkWell(
                    onTap: () => _launchURL(iconData.url),
                    borderRadius: BorderRadius.circular(100),
                    mouseCursor: SystemMouseCursors.click,
                    child: AnimatedBrandIcon(
                      icon: iconData.icon,
                      bgColor: iconData.color,
                      isAutoActive: isAutoActive,
                      isMobile: isMobile,
                    ),
                  );
                }),
              ),

              SizedBox(height: isMobile ? 16 : 20),

              // Copyright Text
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 0),
                child: Text(
                  '© 2025 Muhammed Anas • Built with Flutter',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: isMobile ? 12 : 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AnimatedBrandIcon extends StatefulWidget {
  final IconData icon;
  final Color bgColor;
  final bool isAutoActive;
  final bool isMobile;

  const AnimatedBrandIcon({
    super.key,
    required this.icon,
    required this.bgColor,
    required this.isAutoActive,
    required this.isMobile,
  });

  @override
  State<AnimatedBrandIcon> createState() => _AnimatedBrandIconState();
}

class _AnimatedBrandIconState extends State<AnimatedBrandIcon> {
  bool isHovered = false;

  bool get isActive => isHovered || widget.isAutoActive;

  @override
  Widget build(BuildContext context) {
    final size = widget.isMobile ? 60.0 : 80.0;
    final iconSize = widget.isMobile ? 25.0 : 35.0;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: Container(
        width: size,
        height: size,
        margin: EdgeInsets.symmetric(horizontal: widget.isMobile ? 5 : 10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background fill animation
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              bottom: isActive ? 0 : -size,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: widget.bgColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Rotating icon
            AnimatedRotation(
              duration: const Duration(milliseconds: 500),
              turns: isActive ? 1 : 0,
              child: Icon(
                widget.icon,
                size: iconSize,
                color: isActive ? Colors.white : Colors.black,
              ),
            ),

            // Border
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black, 
                  width: widget.isMobile ? 2 : 3
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconDataModel {
  final IconData icon;
  final Color color;
  final String url;

  const _IconDataModel({
    required this.icon,
    required this.color,
    required this.url,
  });
}