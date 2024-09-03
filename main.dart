import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kagamchat/firebase_options.dart';
import 'package:kagamchat/main_chat_page.dart';
import 'package:kagamchat/settings_page.dart';
import 'package:kagamchat/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;
  Locale _locale = Locale('en');
  String _notificationSound = 'Default Sound';

  void _toggleTheme(bool isDarkMode) {
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  void _changeNotificationSound(String sound) {
    setState(() {
      _notificationSound = sound;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kagam Chat',
      theme: ThemeData(
        primaryColor: Colors.orange,
        hintColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.orange,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.orange,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
        ),
      ),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: SplashScreen(
        toggleTheme: _toggleTheme,
        changeLanguage: _changeLanguage,
        changeNotificationSound: _changeNotificationSound,
        isDarkMode: _themeMode == ThemeMode.dark,
        selectedNotificationSound: _notificationSound,
      ),
      locale: _locale,
    );
  }
}
