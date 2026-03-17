import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Added for SystemChrome
import 'package:google_fonts/google_fonts.dart';

import 'screens/home_screen.dart';
import 'services/notification_service.dart';
import 'services/sms_listener_service.dart';

void main() async {
  // Ensure bindings are initialized before calling async methods
  WidgetsFlutterBinding.ensureInitialized();

  // Set the top status bar to be transparent with light icons
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF09090B), // Matches our Onyx Black
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // --- PRESERVED FUNCTIONALITY ---
  await NotificationService.init();
  await SmsListenerService().init();

  runApp(PhishingApp());
}

class PhishingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Banking Phishing Detector',

      // Global Premium Minimalist Theme
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF09090B), // Onyx Black
        primaryColor: const Color(0xFF3B82F6), // Electric Blue

        // Globally apply the Outfit font
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),

        // Ensure default highlight colors match our Electric Blue
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF3B82F6),
          secondary: Color(0xFF3B82F6),
          surface: Color(0xFF09090B),
        ),

        // Smoother default page transitions
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      home: HomeScreen(),
    );
  }
}