import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

import 'url_scanner.dart';
import 'sms_scanner.dart';
import 'history_screen.dart';
import 'qr_scanner.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    // --- PRESERVED FUNCTIONALITY ---
    requestSmsPermission();
    requestNotificationPermission();

    // --- ENTRANCE ANIMATION ---
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOutCubic),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOutCubic),
    );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  // --- PRESERVED FUNCTIONALITY ---
  Future requestSmsPermission() async {
    var status = await Permission.sms.request();
    if (status.isGranted) print("SMS permission granted");
  }

  Future requestNotificationPermission() async {
    var status = await Permission.notification.request();
    if (status.isGranted) print("Notification permission granted");
  }

  // --- CUSTOM NAVIGATION ANIMATION ---
  Route _animatedRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero)
                .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09090B), // Color 1: Onyx Black
      body: Stack(
        children: [
          // Subtle Ambient Glow (Color 3: Electric Blue)
          Positioned(
            top: -150,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF3B82F6).withOpacity(0.08),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF3B82F6).withOpacity(0.05), blurRadius: 100)
                ],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),

                      // Header
                      Text(
                        "PhishGuard",
                        style: GoogleFonts.outfit(
                          fontSize: 42,
                          fontWeight: FontWeight.w800,
                          color: Colors.white, // Color 2: Pure White
                          letterSpacing: -1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Secure your digital footprint.",
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.5),
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      const SizedBox(height: 50),

                      // Action Grid
                      Expanded(
                        child: GridView.count(
                          physics: const BouncingScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          children: [
                            PremiumActionCard(
                              title: "Scan URL",
                              icon: Icons.link_rounded,
                              onTap: () => Navigator.push(context, _animatedRoute(UrlScanner())),
                            ),
                            PremiumActionCard(
                              title: "Check SMS",
                              icon: Icons.chat_bubble_outline_rounded,
                              onTap: () => Navigator.push(context, _animatedRoute(SmsScanner())),
                            ),
                            PremiumActionCard(
                              title: "Scan QR",
                              icon: Icons.qr_code_scanner_rounded,
                              onTap: () => Navigator.push(context, _animatedRoute(QRScanner())),
                            ),
                          ],
                        ),
                      ),

                      // History Tile
                      PremiumActionCard(
                        title: "Detection History",
                        icon: Icons.history_rounded,
                        isWide: true,
                        onTap: () => Navigator.push(context, _animatedRoute(HistoryScreen())),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- PREMIUM INTERACTIVE CARD (Tap & Hover Physics) ---
class PremiumActionCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isWide;

  const PremiumActionCard({
    required this.title,
    required this.icon,
    required this.onTap,
    this.isWide = false,
  });

  @override
  _PremiumActionCardState createState() => _PremiumActionCardState();
}

class _PremiumActionCardState extends State<PremiumActionCard> with SingleTickerProviderStateMixin {
  late AnimationController _interactionController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _interactionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _interactionController, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void dispose() {
    _interactionController.dispose();
    super.dispose();
  }

  void _onTapDown() {
    HapticFeedback.lightImpact();
    _interactionController.forward();
  }

  void _onTapUp() {
    _interactionController.reverse();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => _onTapDown(),
        onTapUp: (_) => _onTapUp(),
        onTapCancel: () => _interactionController.reverse(),
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            width: widget.isWide ? double.infinity : null,
            height: widget.isWide ? 80 : null,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _isHovered ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.02),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: _isHovered
                    ? const Color(0xFF3B82F6).withOpacity(0.5) // Blue border on hover
                    : Colors.white.withOpacity(0.05),
                width: 1,
              ),
              boxShadow: _isHovered
                  ? [BoxShadow(color: const Color(0xFF3B82F6).withOpacity(0.1), blurRadius: 20)]
                  : [],
            ),
            child: widget.isWide ? _buildWideLayout() : _buildGridLayout(),
          ),
        ),
      ),
    );
  }

  Widget _buildGridLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(widget.icon, color: const Color(0xFF3B82F6), size: 32), // Electric Blue Icon
        const Spacer(),
        Text(
          widget.title,
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildWideLayout() {
    return Row(
      children: [
        Icon(widget.icon, color: const Color(0xFF3B82F6), size: 28),
        const SizedBox(width: 16),
        Text(
          widget.title,
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        const Icon(Icons.arrow_forward_rounded, color: Colors.white38, size: 20),
      ],
    );
  }
}