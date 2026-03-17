import 'package:flutter/services.dart';
import 'local_model_service.dart';
import 'database_service.dart';
import 'notification_service.dart';
import '../utils/url_extractor.dart';

class SmsListenerService {

  static const platform = MethodChannel("sms_channel");

  final model = LocalModelService();
  final db = DatabaseService();

  Future init() async {

    await model.loadModel("assets/models/sms_model.json");

    platform.setMethodCallHandler((call) async {

      if (call.method == "onSmsReceived") {

        String sms = call.arguments;

        List<String> urls = UrlExtractor.extractUrls(sms);

        double prob = model.predict(sms);

        if (urls.isNotEmpty) {

          for (var url in urls) {

            double urlProb = model.predict(url);

            if (urlProb > prob) {
              prob = urlProb;
            }

          }

        }

        if (prob > 0.5) {

          String alertMessage = "Phishing SMS detected: $sms";

          if (urls.isNotEmpty) {
            alertMessage += "\nPossible malicious link found";
          }

          await NotificationService.showAlert(alertMessage);

          await db.insertLog(sms, "Phishing SMS");

        }

      }

    });
  }
}