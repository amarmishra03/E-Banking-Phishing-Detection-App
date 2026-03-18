import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/local_model_service.dart';

class SmsScanner extends StatefulWidget {
  @override
  _SmsScannerState createState() => _SmsScannerState();
}

class _SmsScannerState extends State<SmsScanner> with SingleTickerProviderStateMixin {
  final controller = TextEditingController();
  final model = LocalModelService();
  String result = "";

  // UI Animation Controllers
  late AnimationController _entranceController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    model.loadModel("assets/models/sms_model.json");

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
  void checkSms() {
    // Dismiss keyboard on analyze for a clean result reveal
    FocusScope.of(context).unfocus();

    double prob = model.predict(controller.text);

    setState(() {
      if (prob > 0.5) {
        result = "⚠ Phishing SMS Detected";
      } else {
        result = "✅ Safe Message";
      }
    });
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
          // Subtle Ambient Glow (Electric Blue) positioned for the text area
          Positioned(
            top: 100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF3B82F6).withOpacity(0.04),
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
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          "Message Scan",
                          style: GoogleFonts.outfit(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Paste SMS content to detect social engineering.",
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Premium Multi-line Input
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.02),
                            borderRadius: BorderRadius.circular(20), // Slightly softer corners for large areas
                            border: Border.all(color: Colors.white.withOpacity(0.1)),
                          ),
                          child: TextField(
                            controller: controller,
                            maxLines: 6, // Expanded for paragraphs
                            style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, height: 1.5),
                            cursorColor: const Color(0xFF3B82F6),
                            decoration: InputDecoration(
                              hintText: "Paste message text here...",
                              hintStyle: GoogleFonts.outfit(color: Colors.white.withOpacity(0.2)),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(24),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Interactive Scan Button
                        PremiumPrimaryButton(
                          title: "Analyze Content",
                          onTap: () {
                            if (controller.text.isNotEmpty) checkSms();
                          },
                        ),
                        const SizedBox(height: 40),

                        // Animated Result Card
                        if (result.isNotEmpty)
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            switchInCurve: Curves.easeOutBack,
                            child: Container(
                              key: ValueKey(result),
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                // High contrast inversion for threats
                                color: isThreat ? Colors.white : const Color(0xFF3B82F6).withOpacity(0.05),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isThreat ? Colors.white : const Color(0xFF3B82F6).withOpacity(0.3),
                                  width: isThreat ? 0 : 1,
                                ),
                                boxShadow: isThreat
                                    ? [BoxShadow(color: Colors.white.withOpacity(0.2), blurRadius: 30, offset: const Offset(0, 10))]
                                    : [],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        isThreat ? Icons.gpp_bad_rounded : Icons.verified_user_rounded,
                                        color: isThreat ? const Color(0xFF09090B) : const Color(0xFF3B82F6),
                                        size: 28,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        isThreat ? "THREAT DETECTED" : "VERIFIED SAFE",
                                        style: GoogleFonts.outfit(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 1.5,
                                          color: isThreat ? const Color(0xFF09090B).withOpacity(0.5) : const Color(0xFF3B82F6).withOpacity(0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    result.replaceAll("⚠ ", "").replaceAll("✅ ", ""),
                                    style: GoogleFonts.outfit(
                                      fontSize: 20,
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
              color: _isHovered ? const Color(0xFF2563EB) : const Color(0xFF3B82F6), // Electric Blue Shift
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