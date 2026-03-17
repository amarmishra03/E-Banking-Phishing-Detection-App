import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'services/notification_service.dart';
import 'services/sms_listener_service.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.init();

  await SmsListenerService().init();

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