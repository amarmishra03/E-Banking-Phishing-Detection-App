import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

import '../services/local_model_service.dart';

class QRScanner extends StatefulWidget {
  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner>
    with SingleTickerProviderStateMixin {

  final LocalModelService model = LocalModelService();

  String result = "";
  bool scanned = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    model.loadModel("assets/models/url_model.json");

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
  }

  void analyzeQR(String url) {

    double prob = model.predict(url);
    double risk = prob * 100;

    String status;

    if (prob > 0.8) {
      status = "⚠ HIGH RISK";
    } else if (prob > 0.5) {
      status = "⚠ SUSPICIOUS";
    } else {
      status = "✅ SAFE";
    }

    setState(() {
      result = "$status\nRisk Score: ${risk.toStringAsFixed(2)}%";
    });

    _animationController.forward();
  }

  void resetScanner() {
    setState(() {
      scanned = false;
      result = "";
    });
    _animationController.reset();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF09090B),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "QR Scanner",
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
      ),

      body: Stack(
        children: [

          /// CAMERA VIEW
          MobileScanner(
            onDetect: (BarcodeCapture capture) {

              if (scanned) return;

              final barcodes = capture.barcodes;

              for (final barcode in barcodes) {

                final String? code = barcode.rawValue;

                if (code != null) {
                  scanned = true;
                  analyzeQR(code);
                  break;
                }
              }
            },
          ),

          /// DARK OVERLAY
          Container(
            color: Colors.black.withOpacity(0.4),
          ),

          /// SCAN FRAME
          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFF3B82F6),
                  width: 2,
                ),
              ),
            ),
          ),

          /// RESULT CARD
          if (result.isNotEmpty)
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFF3B82F6).withOpacity(0.4),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          Text(
                            result,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 16),

                          ElevatedButton(
                            onPressed: resetScanner,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3B82F6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              "Scan Again",
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w600,
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