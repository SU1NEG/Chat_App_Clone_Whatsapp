import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kagamchat/person_page.dart';
import 'package:kagamchat/personel_chat_page.dart';
import 'package:kagamchat/settings_page.dart';
import 'package:kagamchat/profile_page.dart' as profile;
import 'package:kagamchat/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainChatPage extends StatefulWidget {
  final Function(bool) toggleTheme;
  final Function(Locale) changeLanguage;
  final Function(String) changeNotificationSound;
  final bool isDarkMode;
  final String selectedNotificationSound;

  MainChatPage({
    required this.toggleTheme,
    required this.changeLanguage,
    required this.changeNotificationSound,
    required this.isDarkMode,
    required this.selectedNotificationSound,
  });

  @override
  _MainChatPageState createState() => _MainChatPageState();
}

class _MainChatPageState extends State<MainChatPage> {
  final FirestoreService _firestoreService = FirestoreService();
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KAGAM CHAT'),
      ),
      body: _currentUser != null
          ? StreamBuilder<List<Map<String, dynamic>>>(
              stream: _firestoreService.getUserChats(_currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                      child: Text('Bir hata oluştu: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Henüz sohbet yok'));
                }

                final chats = snapshot.data!;

                return ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    return ChatTile(
                      imageUrl: chat['photoURL'] ?? '',
                      name: chat['displayName'] ?? 'Unknown',
                      message: chat['lastMessage'] ?? '',
                      time: (chat['lastMessageTime'] as Timestamp)
                          .toDate()
                          .toString(),
                    );
                  },
                );
              },
            )
          : Center(child: Text('Lütfen giriş yapın')),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Mesajlar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Kişiler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Ayarlar',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PersonPage(
                  toggleTheme: widget.toggleTheme,
                  changeLanguage: widget.changeLanguage,
                  changeNotificationSound: widget.changeNotificationSound,
                  isDarkMode: widget.isDarkMode,
                  selectedNotificationSound: widget.selectedNotificationSound,
                ),
              ),
            );
          }
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => profile.ProfilePage(
                  firstName: 'John Doe',
                  nickname: 'Johnny',
                  email: 'sdad',
                  toggleTheme: widget.toggleTheme,
                  changeLanguage: widget.changeLanguage,
                  changeNotificationSound: widget.changeNotificationSound,
                  isDarkMode: widget.isDarkMode,
                  selectedNotificationSound: widget.selectedNotificationSound,
                ),
              ),
            );
          }
          if (index == 3) {
            Navigator.push(
              context,
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
          }
        },
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String message;
  final String time;

  ChatTile({
    required this.imageUrl,
    required this.name,
    required this.message,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: imageUrl.isNotEmpty
            ? NetworkImage(imageUrl)
            : AssetImage('assets/default_avatar.png') as ImageProvider,
      ),
      title: Text(name),
      subtitle: Text(message),
      trailing: Text(time),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              userName: name,
              userImageUrl: imageUrl,
            ),
          ),
        );
      },
    );
  }
}
