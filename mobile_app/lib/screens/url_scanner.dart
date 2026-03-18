import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/services/notification_service.dart';
import '../services/local_model_service.dart';
import '../services/database_service.dart';

class UrlScanner extends StatefulWidget {
  @override
  _UrlScannerState createState() => _UrlScannerState();
}

class _UrlScannerState extends State<UrlScanner> with SingleTickerProviderStateMixin {
  final controller = TextEditingController();
  final model = LocalModelService();
  final db = DatabaseService();

  String result = "";

  // UI Animation Controllers
  late AnimationController _entranceController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    model.loadModel("assets/models/url_model.json");

    // --- ENTRANCE ANIMATION ---
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOutCubic),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOutCubic),
    );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    controller.dispose();
    super.dispose();
  }

  // --- PRESERVED FUNCTIONALITY ---
  void scanUrl() async {
    // Dismiss keyboard on scan for premium feel
    FocusScope.of(context).unfocus();

    double prob = model.predict(controller.text);

    if (prob > 0.5) {
      result = "⚠ Phishing URL Detected";
      NotificationService.showAlert("Phishing URL detected!");
    } else {
      result = "✅ Safe URL";
    }

    await db.insertLog(controller.text, result);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isThreat = result.contains("Phishing");

    return Scaffold(
      backgroundColor: const Color(0xFF09090B), // Onyx Black
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Subtle Ambient Glow (Electric Blue)
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF3B82F6).withOpacity(0.05),
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
                      const SizedBox(height: 20),
                      Text(
                        "URL Scanner",
                        style: GoogleFonts.outfit(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Analyze web addresses for malicious signatures.",
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Premium Minimalist Input
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.02),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: TextField(
                          controller: controller,
                          style: GoogleFonts.outfit(color: Colors.white, fontSize: 16),
                          cursorColor: const Color(0xFF3B82F6),
                          decoration: InputDecoration(
                            hintText: "Paste link here...",
                            hintStyle: GoogleFonts.outfit(color: Colors.white.withOpacity(0.2)),
                            prefixIcon: const Icon(Icons.link_rounded, color: Color(0xFF3B82F6)),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Interactive Scan Button
                      PremiumPrimaryButton(
                        title: "Initiate Scan",
                        onTap: () {
                          if (controller.text.isNotEmpty) scanUrl();
                        },
                      ),
                      const SizedBox(height: 40),

                      // Animated Result Card
                      if (result.isNotEmpty)
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          switchInCurve: Curves.easeOutBack,
                          child: Container(
                            key: ValueKey(result),
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              // High contrast inverted card for threats, subtle blue for safe
                              color: isThreat ? Colors.white : const Color(0xFF3B82F6).withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isThreat ? Colors.white : const Color(0xFF3B82F6).withOpacity(0.3),
                                width: isThreat ? 0 : 1,
                              ),
                              boxShadow: isThreat
                                  ? [BoxShadow(color: Colors.white.withOpacity(0.2), blurRadius: 30)]
                                  : [],
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  isThreat ? Icons.warning_rounded : Icons.check_circle_outline_rounded,
                                  color: isThreat ? const Color(0xFF09090B) : const Color(0xFF3B82F6),
                                  size: 40,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  result.replaceAll("⚠ ", "").replaceAll("✅ ", ""), // Clean up emojis for minimal look
                                  style: GoogleFonts.outfit(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isThreat ? const Color(0xFF09090B) : Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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

// --- PREMIUM PRIMARY BUTTON (Physics & Hover) ---
class PremiumPrimaryButton extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  const PremiumPrimaryButton({required this.title, required this.onTap});

  @override
  _PremiumPrimaryButtonState createState() => _PremiumPrimaryButtonState();
}

class _PremiumPrimaryButtonState extends State<PremiumPrimaryButton> with SingleTickerProviderStateMixin {
  late AnimationController _btnController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _btnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _btnController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _btnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) {
          HapticFeedback.lightImpact();
          _btnController.forward();
        },
        onTapUp: (_) {
          _btnController.reverse();
          widget.onTap();
        },
        onTapCancel: () => _btnController.reverse(),
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: _isHovered ? const Color(0xFF2563EB) : const Color(0xFF3B82F6), // Electric Blue
              borderRadius: BorderRadius.circular(16),
              boxShadow: _isHovered
                  ? [BoxShadow(color: const Color(0xFF3B82F6).withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8))]
                  : [BoxShadow(color: const Color(0xFF3B82F6).withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Center(
              child: Text(
                widget.title,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}