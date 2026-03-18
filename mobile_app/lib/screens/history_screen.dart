import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/database_service.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  final db = DatabaseService();
  List logs = [];

  // UI Animation Controllers
  late AnimationController _entranceController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    loadLogs();

    // --- ENTRANCE ANIMATION ---
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
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
  void loadLogs() async {
    logs = await db.getLogs();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
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
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            "Detection Archive",
                            style: GoogleFonts.outfit(
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Review your past security scans.",
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),

                    // Data List or Empty State
                    Expanded(
                      child: logs.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                        itemCount: logs.length,
                        itemBuilder: (context, index) {
                          final log = logs[index];
                          final String resultText = log["result"] ?? "";
                          final bool isThreat = resultText.contains("Phishing");

                          // Staggered Cascading Animation for each item
                          return TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0.0, end: 1.0),
                            duration: Duration(milliseconds: 400 + (index * 100).clamp(0, 600)),
                            curve: Curves.easeOutCubic,
                            builder: (context, double value, child) {
                              return Transform.translate(
                                offset: Offset(0, 20 * (1 - value)),
                                child: Opacity(
                                  opacity: value,
                                  child: child,
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: PremiumHistoryCard(
                                input: log["input"] ?? "Unknown",
                                isThreat: isThreat,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.radar_rounded, size: 60, color: const Color(0xFF3B82F6).withOpacity(0.2)),
          const SizedBox(height: 16),
          Text(
            "No digital footprints found.",
            style: GoogleFonts.outfit(
              color: Colors.white.withOpacity(0.4),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

// --- PREMIUM INTERACTIVE HISTORY CARD ---
class PremiumHistoryCard extends StatefulWidget {
  final String input;
  final bool isThreat;

  const PremiumHistoryCard({required this.input, required this.isThreat});

  @override
  _PremiumHistoryCardState createState() => _PremiumHistoryCardState();
}

class _PremiumHistoryCardState extends State<PremiumHistoryCard> with SingleTickerProviderStateMixin {
  late AnimationController _cardController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _cardController.dispose();
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
          _cardController.forward();
        },
        onTapUp: (_) => _cardController.reverse(),
        onTapCancel: () => _cardController.reverse(),
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              // Threat = Inverted White. Safe = Transparent Black with Blue Accent
              color: widget.isThreat
                  ? Colors.white
                  : (_isHovered ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.02)),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: widget.isThreat
                    ? Colors.white
                    : const Color(0xFF3B82F6).withOpacity(_isHovered ? 0.5 : 0.1),
                width: 1,
              ),
              boxShadow: widget.isThreat && _isHovered
                  ? [BoxShadow(color: Colors.white.withOpacity(0.2), blurRadius: 20)]
                  : [],
            ),
            child: Row(
              children: [
                Icon(
                  widget.isThreat ? Icons.warning_rounded : Icons.check_circle_outline_rounded,
                  color: widget.isThreat ? const Color(0xFF09090B) : const Color(0xFF3B82F6),
                  size: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.input,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          color: widget.isThreat ? const Color(0xFF09090B) : Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.isThreat ? "THREAT BLOCKED" : "VERIFIED SAFE",
                        style: GoogleFonts.outfit(
                          color: widget.isThreat
                              ? const Color(0xFF09090B).withOpacity(0.6)
                              : const Color(0xFF3B82F6).withOpacity(0.8),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}