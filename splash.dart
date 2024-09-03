import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kagamchat/auth_page.dart';
import 'package:kagamchat/settings_page.dart';

class SplashScreen extends StatefulWidget {
  final Function(bool) toggleTheme;
  final Function(Locale) changeLanguage;
  final Function(String) changeNotificationSound;
  final bool isDarkMode;
  final String selectedNotificationSound;

  SplashScreen({
    required this.toggleTheme,
    required this.changeLanguage,
    required this.changeNotificationSound,
    required this.isDarkMode,
    required this.selectedNotificationSound,
  });

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    print('SplashScreen: Initializing...');
    Timer(Duration(seconds: 4), () async {
      print('SplashScreen: Resetting FirebaseAuth instance...');
      await FirebaseAuth.instance.signOut();

      print('SplashScreen: Timer finished. Navigating to AuthPage...');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => SettingsPage(
            toggleTheme: widget.toggleTheme,
            changeLanguage: widget.changeLanguage,
            changeNotificationSound: widget.changeNotificationSound,
            isDarkMode: widget.isDarkMode,
            selectedNotificationSound: widget.selectedNotificationSound,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipOval(
              child: Image.asset('lib/images/logo.png',
                  width: 250, height: 250, fit: BoxFit.cover),
            ),
            SizedBox(height: 20),
            Text(
              'KAGAMCHAT',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
