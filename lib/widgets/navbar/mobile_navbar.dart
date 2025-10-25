import 'package:flutter/material.dart';

class MobileNavBar extends StatefulWidget {
  final Function(int)? onItemSelected;
  
  const MobileNavBar({super.key, this.onItemSelected});

  @override
  State<MobileNavBar> createState() => _MobileNavBarState();
}

class _MobileNavBarState extends State<MobileNavBar>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _lineController;
  late Animation<double> _lineAnimation;

  final List<String> _navItems = ['Home', 'About', 'Work', 'Contact'];

  @override
  void initState() {
    super.initState();
    _lineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _lineAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(_lineController);
  }

  @override
  void dispose() {
    _lineController.dispose();
    super.dispose();
  }

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _lineController.forward(from: 0.0);

    // Call navigation callback
    widget.onItemSelected?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth;
          final itemWidth = availableWidth / _navItems.length;
          
          return Row(
            children: List.generate(_navItems.length, (index) {
              final isSelected = _selectedIndex == index;
              
              return Expanded(
                child: GestureDetector(
                  onTap: () => _onItemTap(index),
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Text
                        Text(
                          _navItems[index],
                          style: TextStyle(
                            fontSize: 14,
                            color: isSelected ? const Color(0xFFd94f5c) : const Color(0xFF777777),
                            letterSpacing: 1.1,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        
                        // Animated Line
                        if (isSelected)
                          AnimatedBuilder(
                            animation: _lineAnimation,
                            builder: (context, child) {
                              return Container(
                                margin: const EdgeInsets.only(top: 4),
                                height: 2,
                                width: itemWidth * 0.6,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFFd94f5c).withOpacity(_lineAnimation.value),
                                      const Color(0xFFd94f5c),
                                    ],
                                    stops: const [0.0, 1.0],
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}