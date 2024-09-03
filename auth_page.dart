import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kagamchat/firestore_service.dart';
import 'package:kagamchat/main_chat_page.dart';
import 'package:kagamchat/sign_in_page.dart';

class AuthPage extends StatefulWidget {
  final Function(bool) toggleTheme;
  final Function(Locale) changeLanguage;
  final Function(String) changeNotificationSound;
  final bool isDarkMode;
  final String selectedNotificationSound;

  AuthPage({
    required this.toggleTheme,
    required this.changeLanguage,
    required this.changeNotificationSound,
    required this.isDarkMode,
    required this.selectedNotificationSound,
  });

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final user = snapshot.data!;
            _firestoreService.addUser(user);
            return MainChatPage(
              toggleTheme: widget.toggleTheme,
              changeLanguage: widget.changeLanguage,
              changeNotificationSound: widget.changeNotificationSound,
              isDarkMode: widget.isDarkMode,
              selectedNotificationSound: widget.selectedNotificationSound,
            );
          } else {
            return SignInPage(
              toggleTheme: widget.toggleTheme,
              changeLanguage: widget.changeLanguage,
              changeNotificationSound: widget.changeNotificationSound,
              isDarkMode: widget.isDarkMode,
              selectedNotificationSound: widget.selectedNotificationSound,
            );
          }
        },
      ),
    );
  }
}
