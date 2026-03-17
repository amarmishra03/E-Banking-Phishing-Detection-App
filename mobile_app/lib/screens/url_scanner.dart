import 'package:flutter/material.dart';
import 'package:mobile_app/services/notification_service.dart';
import '../services/local_model_service.dart';
import '../services/database_service.dart';

class UrlScanner extends StatefulWidget {
  @override
  _UrlScannerState createState() => _UrlScannerState();
}

class _UrlScannerState extends State<UrlScanner> {

  final controller = TextEditingController();
  final model = LocalModelService();
  final db = DatabaseService();

  String result = "";

  @override
  void initState() {
    super.initState();
    model.loadModel("assets/models/url_model.json");
  }

  void scanUrl() async {

    double prob = model.predict(controller.text);

    double risk = prob * 100;

    String status;

    if (prob > 0.8) {
      status = "⚠ HIGH RISK";
    } else if (prob > 0.5) {
      status = "⚠ SUSPICIOUS";
    } else {
      status = "✅ SAFE";
    }

    result = "$status\nRisk Score: ${risk.toStringAsFixed(2)}%";

    await db.insertLog(controller.text, result);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(title: Text("URL Scanner")),

      body: Padding(
        padding: EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: "Enter URL",
              ),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: scanUrl,
              child: Text("Scan"),
            ),

            SizedBox(height: 20),

            Text(
              result,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),

          ],
        ),
      ),
    );
  }
}