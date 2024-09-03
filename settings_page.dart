import 'package:flutter/material.dart';
import 'package:kagamchat/main_chat_page.dart';
import 'package:kagamchat/person_page.dart';
import 'package:kagamchat/profile_page.dart' as profile;
import 'package:kagamchat/sign_in_page.dart';

class SettingsPage extends StatefulWidget {
  final Function(bool) toggleTheme;
  final Function(Locale) changeLanguage;
  final Function(String) changeNotificationSound;
  final bool isDarkMode;
  final String selectedNotificationSound;

  SettingsPage({
    required this.toggleTheme,
    required this.changeLanguage,
    required this.changeNotificationSound,
    required this.isDarkMode,
    required this.selectedNotificationSound,
  });

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;
  String _selectedLanguage = 'en';
  String _selectedNotificationSound = 'Default Sound';

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
    _selectedNotificationSound = widget.selectedNotificationSound;
  }

  void _openLanguageSelector() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Dil Seçin'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('English'),
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'en';
                  });
                  widget.changeLanguage(Locale('en'));
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Türkçe'),
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'tr';
                  });
                  widget.changeLanguage(Locale('tr'));
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _openNotificationSoundSelector() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bildirim Sesi Seçin'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Varsayılan Ses'),
                onTap: () {
                  setState(() {
                    _selectedNotificationSound = 'Varsayılan Ses';
                  });
                  widget.changeNotificationSound('Varsayılan Ses');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Bildirim Sesi 1'),
                onTap: () {
                  setState(() {
                    _selectedNotificationSound = 'Bildirim Sesi 1';
                  });
                  widget.changeNotificationSound('Bildirim Sesi 1');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Bildirim Sesi 2'),
                onTap: () {
                  setState(() {
                    _selectedNotificationSound = 'Bildirim Sesi 2';
                  });
                  widget.changeNotificationSound('Bildirim Sesi 2');
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _signOut() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => SignInPage(
          toggleTheme: widget.toggleTheme,
          changeLanguage: widget.changeLanguage,
          changeNotificationSound: widget.changeNotificationSound,
          isDarkMode: widget.isDarkMode,
          selectedNotificationSound: widget.selectedNotificationSound,
        ),
      ),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ayarlar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Dialog(
                              backgroundColor: Colors.transparent,
                              child: Center(
                                child: ClipOval(
                                  child: GestureDetector(
                                    onTap:
                                        () {}, // İçerik tıklanabilir hale gelsin ama bir işlem yapmasın
                                    child: Image.network(
                                      'https://img.freepik.com/free-photo/close-up-smiley-man-taking-selfie_23-2149155156.jpg',
                                      fit: BoxFit.cover,
                                      width:
                                          300, // İsteğe bağlı: tam ekranın daha küçük bir kısmı olacak şekilde ayarlayabilirsiniz
                                      height:
                                          300, // İsteğe bağlı: tam ekranın daha küçük bir kısmı olacak şekilde ayarlayabilirsiniz
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                          'https://img.freepik.com/free-photo/close-up-smiley-man-taking-selfie_23-2149155156.jpg'),
                    ),
                  ),
                  SizedBox(width: 40),
                  Expanded(
                    child: Text(
                      'Mahmut Alperen Çavuş',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
              SizedBox(height: 40),
              ListTile(
                title: Text(
                  'Dil',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                trailing: Icon(Icons.language, color: Colors.orange),
                onTap: _openLanguageSelector,
              ),
              Divider(height: 60),
              ListTile(
                title: Text(
                  'Karanlık Mod',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                trailing: Switch(
                  value: _isDarkMode,
                  inactiveTrackColor: Colors.orange,
                  activeColor: Colors.white,
                  onChanged: (value) {
                    setState(() {
                      _isDarkMode = value;
                    });
                    widget.toggleTheme(value);
                  },
                ),
              ),
              Divider(height: 60),
              ListTile(
                title: Text(
                  'Bildirim Sesi',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                trailing: Icon(Icons.music_note, color: Colors.orange),
                onTap: _openNotificationSoundSelector,
              ),
              SizedBox(height: 40),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: _signOut,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white),
                  child: Text("Çıkış Yap"),
                ),
              )
            ],
          ),
        ),
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
        onTap: (index) {
          if (index == 0) {
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
          }
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
        },
      ),
    );
  }
}
