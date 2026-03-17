import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';

import 'screens/home_screen.dart';
import 'services/local_model_service.dart';
import 'services/notification_service.dart';
import 'services/sms_listener_service.dart';

final LocalModelService model = LocalModelService();

final AppLinks appLinks = AppLinks();

void handleIncomingLinks() {

  appLinks.uriLinkStream.listen((Uri uri) async {

    String url = uri.toString();

    double prob = model.predict(url);

    if (prob > 0.5) {

      await NotificationService.showAlert(
        "⚠ Suspicious website detected!\n$url"
      );

    }

  });

}

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.init();

  await SmsListenerService().init();

  await model.loadModel("assets/models/url_model.json");

  handleIncomingLinks();

  runApp(PhishingApp());

}

class PhishingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Banking Phishing Detector',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomeScreen(),
    );
  }
}