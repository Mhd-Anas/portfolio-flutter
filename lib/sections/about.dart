import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_web/widgets/profile_card.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 600;
        final bool isTablet = constraints.maxWidth < 1200;

        return Padding(
          padding: EdgeInsets.only(
            left: isMobile ? 20 : (isTablet ? 40 : 70),
            right: isMobile ? 20 : (isTablet ? 40 : 20),
            top: isMobile ? 40 : 80,
            bottom: isMobile ? 40 : 80,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: Container(
                padding: EdgeInsets.all(isMobile ? 20 : 40),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 👤 Profile Image (left)
        const ProfileCard(),

        const SizedBox(width: 55),

        // 📝 Text Section (right)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🟦 Section Heading
              Text(
                "About Me",
                style: GoogleFonts.inter(
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.5,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 30),

              // 📝 Description
              Text(
                "I am a passionate Full Stack Developer who enjoys building scalable, efficient, and user-friendly applications. My work involves Java, Spring Boot, Flutter, and MySQL, with a strong focus on creating intuitive user interfaces that keep people engaged.\n"
                "When working on a project, I always begin by studying it thoroughly — understanding its purpose, exploring current trends, and ensuring that every feature aligns with user expectations. I believe that great design is not just about appearance but about how smoothly a user experiences each interaction.\n"
                "Recently, I have also developed a deep interest in prompt engineering, as it enables smarter and more efficient development processes when used correctly. It's fascinating to see how technology can save time and enhance creativity at the same time.\n"
                "I am always eager to learn, explore new tools, and discover innovative features that can improve the way applications function. I enjoy discussing ideas, experimenting with new concepts, and turning creative thoughts into real, working solutions.\n"
                "I am open to new opportunities where I can contribute my skills, learn from talented teams, and continue growing as a developer while delivering meaningful digital experiences.",
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(217, 255, 255, 255),
                  height: 1.8,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      // ← ADD THIS for scrollable content
      child: Column(
        children: [
          // 👤 Profile Image (top)
          const ProfileCard(),

          const SizedBox(height: 30),

          // 📝 Text Section (bottom)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🟦 Section Heading
              Text(
                "About Me",
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.5,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 20),

              // 📝 Description - SHORTER VERSION
              Text(
                "I'm a passionate Full Stack Developer specializing in Java, Spring Boot, Flutter, and MySQL. I create scalable, user-friendly applications with intuitive interfaces.\n\n"
                "I thoroughly understand each project's purpose and user needs, ensuring features deliver smooth experiences. I also explore prompt engineering to enhance development efficiency.\n\n"
                "Eager to learn new technologies and turn ideas into practical solutions. Open to opportunities where I can contribute, grow, and deliver impactful digital experiences.",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(217, 255, 255, 255),
                  height: 1.6,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
