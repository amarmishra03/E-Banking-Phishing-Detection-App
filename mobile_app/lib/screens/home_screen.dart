import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'url_scanner.dart';
import 'sms_scanner.dart';
import 'history_screen.dart';
import 'dashboard_screen.dart';
import 'qr_scanner.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    requestSmsPermission();
    requestNotificationPermission();
  }

  Future requestSmsPermission() async {

    var status = await Permission.sms.request();

    if (status.isGranted) {
      print("SMS permission granted");
    } else {
      print("SMS permission denied");
    }

  }

  Future requestNotificationPermission() async {

    var status = await Permission.notification.request();

    if (status.isGranted) {
      print("Notification permission granted");
    } else {
      print("Notification permission denied");
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("E-Banking Phishing Detector"),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            ElevatedButton(
              child: Text("Scan URL"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => UrlScanner())
                );
              },
            ),

            SizedBox(height: 20),

            ElevatedButton(
              child: Text("Check SMS"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SmsScanner())
                );
              },
            ),

            SizedBox(height: 20),

            ElevatedButton(
              child: Text("Detection History"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => HistoryScreen())
                );
              },
            ),

            ElevatedButton(
              child: Text("Threat Dashboard"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DashboardScreen())
                );
              },
            ),

            ElevatedButton(
              child: Text("Scan QR Code"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => QRScanner())
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}