import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package
import 'package:kagamchat/main_chat_page.dart';
import 'package:kagamchat/settings_page.dart';
import 'package:kagamchat/profile_page.dart';
import 'package:kagamchat/firestore_service.dart';

class PersonPage extends StatefulWidget {
  final Function(bool) toggleTheme;
  final Function(Locale) changeLanguage;
  final Function(String) changeNotificationSound;
  final bool isDarkMode;
  final String selectedNotificationSound;

  PersonPage({
    required this.toggleTheme,
    required this.changeLanguage,
    required this.changeNotificationSound,
    required this.isDarkMode,
    required this.selectedNotificationSound,
  });

  @override
  _PersonPageState createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  late Future<List<Map<String, dynamic>>> friendsList;
  final FirestoreService _firestoreService = FirestoreService();
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    friendsList = _fetchFriends();
  }

  Future<List<Map<String, dynamic>>> _fetchFriends() async {
    try {
      // Fetch the list of friend references
      final friendRefs = await _firestoreService.getUserFriends(user!.uid);
      final List<Map<String, dynamic>> friends = [];

      // Iterate over each reference and fetch the data
      for (var friendRef in friendRefs) {
        // Check if 'friend' is a List
        if (friendRef['friend'] is List) {
          final List<dynamic> refs = friendRef['friend'] as List<dynamic>;
          for (var ref in refs) {
            if (ref is DocumentReference) {
              final DocumentReference docRef = ref;
              final friendDoc = await docRef.get();

              if (friendDoc.exists) {
                friends.add(friendDoc.data() as Map<String, dynamic>);
              } else {
                print('Document does not exist for friend ref: $docRef');
              }
            } else {
              print('Expected DocumentReference but got: ${ref.runtimeType}');
            }
          }
        } else if (friendRef['friend'] is DocumentReference) {
          // Handle single DocumentReference
          final DocumentReference docRef =
              friendRef['friend'] as DocumentReference;
          final friendDoc = await docRef.get();

          if (friendDoc.exists) {
            friends.add(friendDoc.data() as Map<String, dynamic>);
          } else {
            print('Document does not exist for friend ref: $docRef');
          }
        } else {
          print(
              'Expected DocumentReference or List<DocumentReference> but got: ${friendRef['friend'].runtimeType}');
        }
      }

      return friends;
    } catch (e) {
      print('Error fetching friends: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kişiler'),
        actions: [
          IconButton(
            icon: Icon(Icons.person_add),
            onPressed: () {
              // Add functionality to navigate to add person page
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: friendsList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching friends'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No friends found'));
          } else {
            final contacts = snapshot.data!;
            print(contacts);
            return ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];

                return ListTile(
                  title: Text(contact['firstName'] ?? 'Unknown'),
                  subtitle: Text(contact['email'] ?? 'No email'),
                  trailing: IconButton(
                    icon: Icon(Icons.message),
                    onPressed: () {
                      // Add functionality to navigate to the chat page with the selected person
                      print('Chat with ${contact['name']}');
                    },
                  ),
                );
              },
            );
          }
        },
      ),
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
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
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
              break;
            case 1:
              // Stay on PersonPage
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    firstName: FirebaseAuth.instance.currentUser!.displayName ??
                        'John Doe',
                    nickname: FirebaseAuth.instance.currentUser!.displayName ??
                        'Johnny',
                    email: FirebaseAuth.instance.currentUser!.email ?? '',
                    toggleTheme: widget.toggleTheme,
                    changeLanguage: widget.changeLanguage,
                    changeNotificationSound: widget.changeNotificationSound,
                    isDarkMode: widget.isDarkMode,
                    selectedNotificationSound: widget.selectedNotificationSound,
                  ),
                ),
              );
              break;
            case 3:
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
              break;
            default:
          }
        },
      ),
    );
  }
}
