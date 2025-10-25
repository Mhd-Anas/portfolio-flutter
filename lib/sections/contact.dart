import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:portfolio_web/services/api_service.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final subjectCtrl = TextEditingController();
  final messageCtrl = TextEditingController();

  bool loading = false;
  bool showPlane = false;
  bool _hovering = false;

  late AnimationController _planeController;

  @override
  void initState() {
    super.initState();
    _planeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
  }

  @override
  void dispose() {
    _planeController.dispose();
    nameCtrl.dispose();
    emailCtrl.dispose();
    subjectCtrl.dispose();
    messageCtrl.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      loading = true;
    });

    final api = Provider.of<ApiService>(context, listen: false);
    try {
      final success = await api.submitContact(
        nameCtrl.text.trim(),
        emailCtrl.text.trim(),
        subjectCtrl.text.trim(),
        messageCtrl.text.trim(),
      );

      if (success) {
        nameCtrl.clear();
        emailCtrl.clear();
        subjectCtrl.clear();
        messageCtrl.clear();

        // Trigger plane animation
        setState(() => showPlane = true);
        _planeController.forward(from: 0).then((_) {
          setState(() => showPlane = false);
        });
      }
    } catch (_) {
      // No error text shown
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 600;
        
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 55,
            vertical: isMobile ? 30 : 60,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
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
        // Left Info Section
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Get In Touch',
                  style: TextStyle(
                      fontSize: 26, fontWeight: FontWeight.bold)),
              SizedBox(height: 13),
              Text(
                'I am very approachable and would love to speak to you. Follow me on social media or simply complete the enquiry form.',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
        const SizedBox(width: 25),

        // Right Form Section
        Expanded(
          flex: 6,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.02),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: _buildForm(),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Info Section (top)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Get In Touch',
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 13),
            Text(
              'I am very approachable and would love to speak to you. Follow me on social media or simply complete the enquiry form.',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
        const SizedBox(height: 30),

        // Form Section (bottom)
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.02),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: _buildForm(),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: nameCtrl,
            decoration: const InputDecoration(hintText: 'Name'),
            validator: (v) =>
                v == null || v.isEmpty ? 'Enter name' : null,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: emailCtrl,
            decoration:
                const InputDecoration(hintText: 'Email'),
            validator: (v) => v == null || !v.contains('@')
                ? 'Enter valid email'
                : null,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: subjectCtrl,
            decoration:
                const InputDecoration(hintText: 'Subject'),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: messageCtrl,
            decoration: const InputDecoration(
                hintText: 'Your message'),
            maxLines: 5,
            validator: (v) =>
                v == null || v.isEmpty ? 'Enter message' : null,
          ),
          const SizedBox(height: 12),

          // ✅ Animated Button + Plane
          Stack(
            clipBehavior: Clip.none,
            children: [
              MouseRegion(
                onEnter: (_) => setState(() => _hovering = true),
                onExit: (_) => setState(() => _hovering = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: _hovering
                        ? const Color(0xFF03E9F4)
                        : Colors.transparent,
                    border: Border.all(
                        color: const Color(0xFF03E9F4)),
                    boxShadow: _hovering
                        ? [
                            BoxShadow(
                                color: const Color(0xFF03E9F4)
                                    .withOpacity(0.7),
                                blurRadius: 20),
                            BoxShadow(
                                color: const Color(0xFF03E9F4)
                                    .withOpacity(0.5),
                                blurRadius: 40),
                          ]
                        : [],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                    ),
                    onPressed: loading ? null : submit,
                    child: Text(
                      'Send Message',
                      style: TextStyle(
                        color: _hovering
                            ? Colors.black
                            : const Color(0xFF03E9F4),
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),

              // ✈️ Emoji Plane Animation
              if (showPlane)
                Positioned(
                  left: 110,
                  top: -20,
                  child: AnimatedBuilder(
                    animation: _planeController,
                    builder: (context, child) {
                      final t = _planeController.value;
                      // Create a curved dotted flight path
                      final pathX = t * 280;
                      final pathY = -sin(t * pi) * 140;
                      return Transform.translate(
                        offset: Offset(pathX, pathY),
                        child: Opacity(
                          opacity: 1 - t,
                          child: Row(
                            children: [
                              // plane emoji
                              const Text(
                                '🛫', // or '✈️' / '📨'
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Color(0xFF03E9F4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}