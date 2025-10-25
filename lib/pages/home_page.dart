import 'package:flutter/material.dart';
import 'package:portfolio_web/widgets/animated_header.dart';
import 'package:portfolio_web/widgets/navbar/desktop_navbar.dart';
import 'package:portfolio_web/widgets/navbar/mobile_navbar.dart';
import 'package:portfolio_web/widgets/circular_background.dart';
import 'package:portfolio_web/sections/about.dart';
import 'package:portfolio_web/sections/work.dart';
import 'package:portfolio_web/sections/contact.dart';
import 'package:portfolio_web/sections/footer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Add ScrollController for navigation
  final ScrollController _scrollController = ScrollController();

  // Navigation function
  void _scrollToSection(int sectionIndex) {
    final sections = [
      0.0, // Home (top)
      600.0, // About section approximate position
      1200.0, // Work section approximate position  
      1800.0, // Contact section approximate position
    ];

    if (sectionIndex < sections.length) {
      _scrollController.animateTo(
        sections[sectionIndex],
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Important: dispose controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isMobile = constraints.maxWidth < 600;
          
          return Stack(
            children: [
              // 🌌 Floating circles background (Separate Class)
              const CircularBackground(backgroundColor: Colors.black),
              
              // 📝 Scrollable Content with ScrollController
              SafeArea(
                bottom: false,
                child: SingleChildScrollView(
                  controller: _scrollController, // Add controller here
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: const [
                      SizedBox(height: 40),
                      AnimatedHeader(),
                      SizedBox(height: 40),
                      AboutSection(),
                      SizedBox(height: 40),
                      WorkSection(),
                      SizedBox(height: 40),
                      ContactSection(),
                      SizedBox(height: 80),
                      Footer(),
                    ],
                  ),
                ),
              ),

              // 📌 Navbar - Pass navigation function
              if (isMobile)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: MobileNavBar(onItemSelected: _scrollToSection),
                )
              else
                Positioned(
                  top: 20,
                  right: 20,
                  child: DesktopNavBar(onItemSelected: _scrollToSection),
                ),
            ],
          );
        },
      ),
    );
  }
}