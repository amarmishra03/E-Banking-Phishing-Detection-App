import 'package:flutter/material.dart';
import '../services/local_model_service.dart';

class SmsScanner extends StatefulWidget {
  @override
  _SmsScannerState createState() => _SmsScannerState();
}

class _SmsScannerState extends State<SmsScanner> {

  final controller = TextEditingController();
  final model = LocalModelService();

  String result = "";

  @override
  void initState() {
    super.initState();
    model.loadModel("assets/models/sms_model.json");
  }

  void checkSms() {

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

    return Scaffold(

      appBar: AppBar(title: Text("SMS Scanner")),

      body: Padding(
        padding: EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(
              controller: controller,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Paste SMS Message",
              ),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: checkSms,
              child: Text("Analyze"),
            ),

            SizedBox(height: 20),

            Text(result, style: TextStyle(fontSize: 18)),

          ],
        ),
      ),
    );
  }
}