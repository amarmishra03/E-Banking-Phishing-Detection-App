import 'package:flutter/services.dart';
import 'local_model_service.dart';
import 'database_service.dart';
import 'notification_service.dart';

class SmsListenerService {

  static const platform = MethodChannel("sms_channel");

  final model = LocalModelService();
  final db = DatabaseService();

  Future init() async {

    await model.loadModel("assets/models/sms_model.json");

    platform.setMethodCallHandler((call) async {

      if (call.method == "onSmsReceived") {

        String sms = call.arguments;

        double prob = model.predict(sms);

        if (prob > 0.5) {

          await NotificationService.showAlert(
              "Phishing SMS detected: $sms");

          await db.insertLog(sms, "Phishing SMS");

        }

      }

    });
  }
}