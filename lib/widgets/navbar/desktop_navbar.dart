import 'package:flutter/material.dart';

class DesktopNavBar extends StatefulWidget {
  final Function(int)? onItemSelected;
  
  const DesktopNavBar({super.key, this.onItemSelected});

  @override
  State<DesktopNavBar> createState() => _DesktopNavBarState();
}

class _DesktopNavBarState extends State<DesktopNavBar> {
  String hoveredIcon = "";

  void _onItemTap(String id) {
    final index = _getIndexFromId(id);
    widget.onItemSelected?.call(index);
  }

  int _getIndexFromId(String id) {
    switch (id) {
      case "home": return 0;
      case "about": return 1;
      case "work": return 2;
      case "contact": return 3;
      default: return 0;
    }
  }

  Widget _iconItem(
      IconData icon, String id, List<Color> gradientColors, String title) {
    final bool isHovered = hoveredIcon == id;

    return MouseRegion(
      onEnter: (_) => setState(() => hoveredIcon = id),
      onExit: (_) => setState(() => hoveredIcon = ""),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _onItemTap(id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          width: isHovered ? 140 : 45,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(45),
            color: Colors.black,
            boxShadow: [
              if (isHovered)
                BoxShadow(
                  color: gradientColors.first.withOpacity(0.5),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
            ],
            gradient: isHovered
                ? LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Icon
              AnimatedOpacity(
                opacity: isHovered ? 0 : 1,
                duration: const Duration(milliseconds: 250),
                child: Icon(
                  icon,
                  color: Colors.grey[300],
                  size: 20,
                ),
              ),

              // Title
              AnimatedOpacity(
                opacity: isHovered ? 1 : 0,
                duration: const Duration(milliseconds: 250),
                child: Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _iconItem(Icons.home, "home", [Colors.blue, Colors.purple], "Home"),
        const SizedBox(width: 15),
        _iconItem(Icons.person, "about", [Colors.pink, Colors.orange], "About"),
        const SizedBox(width: 15),
        _iconItem(Icons.work, "work", [Colors.green, Colors.teal], "Work"),
        const SizedBox(width: 15),
        _iconItem(Icons.mail, "contact", [Colors.red, Colors.purpleAccent], "Contact"),
      ],
    );
  }
}