import 'package:flutter/material.dart';
import 'desktop_navbar.dart';
import 'mobile_navbar.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Just return desktop navbar as default (won't be used in new approach)
    return const DesktopNavBar();
  }
}