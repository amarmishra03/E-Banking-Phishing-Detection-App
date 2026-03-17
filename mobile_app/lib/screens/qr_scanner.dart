import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/local_model_service.dart';

class QRScanner extends StatefulWidget {

  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {

  final model = LocalModelService();

  String result = "";

  bool scanned = false;

  @override
  void initState() {
    super.initState();
    model.loadModel("assets/models/url_model.json");
  }

  void analyzeQR(String url) {

    double prob = model.predict(url);

    if (prob > 0.5) {

      setState(() {
        result = "⚠ Phishing URL Detected";
      });

    } else {

      setState(() {
        result = "✅ Safe URL";
      });

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(title: Text("QR Code Scanner")),

      body: Column(

        children: [

          Expanded(

            flex: 4,

            child: MobileScanner(

              onDetect: (BarcodeCapture capture) {

                if (scanned) return;

                final List<Barcode> barcodes = capture.barcodes;

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

          ),

          Expanded(

            child: Center(
              child: Text(result),
            ),

          ),

        ],

      ),

    );
  }
}