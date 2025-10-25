import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AnimatedHeader extends StatelessWidget {
  const AnimatedHeader({super.key});

  Future<void> _launchEmail() async {
    final Uri email = Uri(
      scheme: 'mailto',
      path: 'mhdanaz.av@gmail.com',
      query: Uri.encodeFull(
          'subject=Let\'s Collaborate&body=Hi Muhammed Anas,'),
    );
    await launchUrl(email);
  }

  Future<void> _downloadResume() async {
    const url = 'https://drive.google.com/file/d/1ST2UcVqNDXR7eIgzt1IxZ0ofympgkyhj/view?usp=sharing';
    await launchUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final bool isMobile = constraints.maxWidth < 600;
      
      return isMobile 
          ? _buildMobileLayout()  // 📱 Mobile layout
          : _buildDesktopLayout(context); // 🖥️ Your original desktop layout
    });
  }

  // 📱 MOBILE LAYOUT - Completely separate from desktop
  Widget _buildMobileLayout() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Main Heading
          Text(
            'Crafting Seamless Web & Mobile Experiences',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 12), // Reduced gap
          
          // Animated Text
          SizedBox(
            height: 80, // Reduced height
            child: DefaultTextStyle(
              style: const TextStyle(
                fontSize: 16, 
                color: Color.fromARGB(255, 255, 255, 255), 
                fontWeight: FontWeight.w500
              ),
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Hi there, I\'m Muhammed Anas',
                    speed: const Duration(milliseconds: 60),
                  ),
                  TypewriterAnimatedText(
                    'Full Stack Developer ',
                    speed: const Duration(milliseconds: 80),
                  ),
                  TypewriterAnimatedText(
                    'Experienced in REST APIs, Scalable Systems',
                    speed: const Duration(milliseconds: 80),
                  ),
                  TypewriterAnimatedText(
                    'Let\'s Build Something Innovative Together',
                    speed: const Duration(milliseconds: 80),
                  ),
                ],
                repeatForever: true,
                isRepeatingAnimation: true,
              ),
            ),
          ),
          
          const SizedBox(height: 1), // Reduced gap
          
          // Buttons - In same line for mobile
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _AnimatedButton(
                label: 'Work With Me',
                backgroundColor: const Color.fromARGB(255, 66, 83, 234),
                onPressed: _launchEmail,
                isMobile: true,
              ),
              const SizedBox(width: 12),
              _AnimatedButton(
                label: 'View Resume',
                outlined: true,
                onPressed: _downloadResume,
                isMobile: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 🖥️ DESKTOP LAYOUT - Your EXACT original code
  Widget _buildDesktopLayout(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ✅ LEFT SECTION - Your original desktop layout
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Crafting Seamless Web & Mobile Experiences',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 10),
                DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 24, 
                    color: Color.fromARGB(255, 255, 255, 255), 
                    fontWeight: FontWeight.w500
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Hi there, I\'m Muhammed Anas',
                        speed: const Duration(milliseconds: 60),
                      ),
                      TypewriterAnimatedText(
                        'Full Stack Developer – Java, Spring Boot & Flutter',
                        speed: const Duration(milliseconds: 80),
                      ),
                      TypewriterAnimatedText(
                        'Experienced in REST APIs, Scalable Systems',
                        speed: const Duration(milliseconds: 80),
                      ),
                      TypewriterAnimatedText(
                        'Let\'s Build Something Innovative Together',
                        speed: const Duration(milliseconds: 80),
                      ),
                    ],
                    repeatForever: true,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    // 📩 EMAIL BUTTON with animation
                    _AnimatedButton(
                      label: 'Work With Me',
                      backgroundColor: const Color.fromARGB(255, 66, 83, 234),
                      onPressed: _launchEmail,
                      isMobile: false,
                    ),
                    const SizedBox(width: 12),
                    // 📄 RESUME BUTTON with animation
                    _AnimatedButton(
                      label: 'View Resume',
                      outlined: true,
                      onPressed: _downloadResume,
                      isMobile: false,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ✅ RIGHT SECTION — Floating Orbs (Desktop only)
          Expanded(
            flex: 4,
            child: SizedBox(
              height: 260,
              child: Stack(
                children: [
                  const Positioned(
                    right: 0,
                    top: 20,
                    child: _FloatingOrb(size: 120, label: ''),
                  ),
                  Positioned(
                    right: 60,
                    top: 80,
                    child: _FloatingOrb(size: 80, label: ''),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 🌐 Button with hover & press animation
class _AnimatedButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final bool outlined;
  final bool isMobile;

  const _AnimatedButton({
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.outlined = false,
    required this.isMobile,
  });

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final scale = _isPressed
        ? 0.95
        : _isHovered
            ? 1.05
            : 1.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onPressed();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          child: widget.outlined
              ? OutlinedButton(
                  onPressed: widget.onPressed,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: EdgeInsets.symmetric(
                        horizontal: widget.isMobile ? 16 : 22, // Smaller for mobile
                        vertical: widget.isMobile ? 10 : 14),  // Smaller for mobile
                  ),
                  child: Text(
                    widget.label,
                    style: TextStyle(fontSize: widget.isMobile ? 12 : 16), // Smaller text
                  ),
                )
              : ElevatedButton(
                  onPressed: widget.onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.backgroundColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: EdgeInsets.symmetric(
                        horizontal: widget.isMobile ? 18 : 28, // Smaller for mobile
                        vertical: widget.isMobile ? 10 : 14),  // Smaller for mobile
                  ),
                  child: Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: widget.isMobile ? 12 : 16, // Smaller text
                      color: Colors.white,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

// ✨ FLOATING ORB ANIMATION
class _FloatingOrb extends StatefulWidget {
  final double size;
  final String label;
  const _FloatingOrb({required this.size, required this.label});

  @override
  State<_FloatingOrb> createState() => _FloatingOrbState();
}

class _FloatingOrbState extends State<_FloatingOrb>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        final offset = 8.0 * (0.5 - (_ctrl.value - 0.5).abs());
        return Transform.translate(
          offset: Offset(0, offset),
          child: child,
        );
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF8C7BFF), Color(0xFF56D9FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow( 
              color: Colors.blue.withOpacity(0.12), 
              blurRadius: 20, 
              spreadRadius: 2, 
            ),
          ],
        ),
      ),
    );
  }
}