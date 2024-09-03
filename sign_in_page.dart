import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kagamchat/components/my_button.dart';
import 'package:kagamchat/components/my_textfield.dart';
import 'package:kagamchat/main_chat_page.dart';
import 'package:kagamchat/components/square_tile.dart';
import 'package:kagamchat/firestore_service.dart'; // Import the Firestore service
import 'package:kagamchat/register_page.dart'; // Import the Register Page

class SignInPage extends StatefulWidget {
  final void Function(bool) toggleTheme;
  final void Function(Locale) changeLanguage;
  final void Function(String) changeNotificationSound;
  final bool isDarkMode;
  final String selectedNotificationSound;

  SignInPage({
    Key? key,
    required this.toggleTheme,
    required this.changeLanguage,
    required this.changeNotificationSound,
    required this.isDarkMode,
    required this.selectedNotificationSound,
  }) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirestoreService _firestoreService =
      FirestoreService(); // Initialize Firestore service

  void signUserIn(BuildContext context) async {
    try {
      print('SignInPage: Attempting to sign in...');
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      final user = userCredential.user;
      if (user != null) {
        await _firestoreService.addUser(user); // Add user to Firestore
      }

      print('SignInPage: Sign in successful. User: ${userCredential.user}');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MainChatPage(
            toggleTheme: widget.toggleTheme,
            changeLanguage: widget.changeLanguage,
            changeNotificationSound: widget.changeNotificationSound,
            isDarkMode: widget.isDarkMode,
            selectedNotificationSound: widget.selectedNotificationSound,
          ),
        ),
      );
    } catch (e) {
      print('SignInPage: Error during sign in: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign in error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 15),
                ClipOval(
                  child: Image.asset(
                    'lib/images/logo.png',
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 35),
                const Text(
                  'Welcome back you\'ve been missed!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18, // Font size buraya girin
                    fontWeight: FontWeight.bold, // Font weight buraya girin
                  ),
                ),
                SizedBox(height: 25),
                MyTextField(
                  controller: emailController,
                  hintText: 'email',
                  obscureText: false,
                ),
                SizedBox(height: 10),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18, // Font size buraya girin
                          fontWeight:
                              FontWeight.bold, // Font weight buraya girin
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                MyButton(
                  onTap: () => signUserIn(context),
                ),
                SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 1.0,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18, // Font size buraya girin
                            fontWeight:
                                FontWeight.bold, // Font weight buraya girin
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 1.0,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: SquareTile(imagePath: 'lib/images/google.png'),
                      ),
                    ),
                    SizedBox(width: 25),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Not a member?',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18, // Font size buraya girin
                        fontWeight: FontWeight.bold, // Font weight buraya girin
                      ),
                    ),
                    SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(
                              toggleTheme: widget.toggleTheme,
                              changeLanguage: widget.changeLanguage,
                              changeNotificationSound:
                                  widget.changeNotificationSound,
                              isDarkMode: widget.isDarkMode,
                              selectedNotificationSound:
                                  widget.selectedNotificationSound,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Register now',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18, // Font size buraya girin
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
